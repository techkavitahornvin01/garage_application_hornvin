import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GaragePaymentQrStorage {
  static const _prefsKey = 'garage_payment_qr_path';
  static const _filePrefix = 'garage_payment_qr_';

  static Future<String?> savedQrPath() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_prefsKey)?.trim();
    return path == null || path.isEmpty ? null : path;
  }

  static Future<File?> savedQrFile() async {
    final path = await savedQrPath();
    if (path == null) return null;

    final file = File(path);
    return file.existsSync() ? file : null;
  }

  static Future<File> saveQrFromPath(String sourcePath) async {
    final source = File(sourcePath);
    if (!source.existsSync()) {
      throw Exception('Selected QR image not found');
    }

    final directory = await getApplicationDocumentsDirectory();
    final extension = _safeExtension(sourcePath);
    final destination = File(
      '${directory.path}${Platform.pathSeparator}'
      '$_filePrefix${DateTime.now().millisecondsSinceEpoch}.$extension',
    );

    final savedFile = await source.copy(destination.path);
    final previousPath = await savedQrPath();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, savedFile.path);

    await _deleteIfManagedQr(previousPath, keepPath: savedFile.path);
    return savedFile;
  }

  static Future<void> clearSavedQr() async {
    final previousPath = await savedQrPath();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    await _deleteIfManagedQr(previousPath);
  }

  static Future<void> _deleteIfManagedQr(
    String? path, {
    String? keepPath,
  }) async {
    if (path == null || path == keepPath) return;

    final file = File(path);
    final fileName = file.uri.pathSegments.isEmpty
        ? ''
        : file.uri.pathSegments.last;
    if (!fileName.startsWith(_filePrefix)) return;

    try {
      if (file.existsSync()) await file.delete();
    } catch (_) {}
  }

  static String _safeExtension(String path) {
    final cleanPath = path.split('?').first;
    final dotIndex = cleanPath.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == cleanPath.length - 1) return 'png';

    final extension = cleanPath.substring(dotIndex + 1).toLowerCase();
    final isSafe = RegExp(r'^[a-z0-9]{2,5}$').hasMatch(extension);
    return isSafe ? extension : 'png';
  }
}
