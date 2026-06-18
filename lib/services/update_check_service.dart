import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hornvin/localization/app_localizations.dart';

class UpdateCheckService {
  Future<void> checkForUpdate(BuildContext context) async {
    try {
      // 1. Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion =
          int.tryParse(
            packageInfo.buildNumber, // use build number for easy comparison
          ) ??
          1;

      // 2. Setup & fetch Remote Config
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration
              .zero, // 0 for testing; use Duration(hours:1) in production
        ),
      );

      // 3. Set defaults (fallback if fetch fails)
      await remoteConfig.setDefaults({
        'minimum_version': 1,
        'latest_version': 1,
        'update_url':
            'https://play.google.com/store/apps/details?id=com.yourapp',
      });

      await remoteConfig.fetchAndActivate();

      // 4. Read values
      final minimumVersion = remoteConfig.getInt('minimum_version');
      final latestVersion = remoteConfig.getInt('latest_version');
      final updateUrl = remoteConfig.getString('update_url');

      // 5. Compare and show dialog
      if (!context.mounted) return;

      if (currentVersion < minimumVersion) {
        // FORCE UPDATE — user MUST update
        _showUpdateDialog(
          context,
          title: '🚨 Update Required',
          message:
              'This version is no longer supported. Please update to continue.',
          updateUrl: updateUrl,
          isForced: true,
        );
      } else if (currentVersion < latestVersion) {
        // OPTIONAL UPDATE — user can skip
        _showUpdateDialog(
          context,
          title: '🆕 Update Available',
          message:
              'A new version is available. Update now for the latest features!',
          updateUrl: updateUrl,
          isForced: false,
        );
      }
    } catch (e) {
      debugPrint('Update check failed: $e');
    }
  }

  void _showUpdateDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String updateUrl,
    required bool isForced,
  }) {
    showDialog(
      context: context,
      barrierDismissible: !isForced, // can't dismiss if forced
      builder: (context) => WillPopScope(
        onWillPop: () async => !isForced, // back button disabled if forced
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: [
            // Show "Later" only for optional updates
            if (!isForced)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  context.trText('Later'),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _launchURL(updateUrl),
              child: Text(context.trText('Update Now')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
