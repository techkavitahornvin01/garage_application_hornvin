import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'languages/en.dart';
import 'languages/hi.dart';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const supportedLocales = <Locale>[Locale('en'), Locale('hi')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale('en'));
  }

  String tr(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  String trText(String text) {
    return tr(text);
  }

  String trData(Object? value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty || text == 'null') return trText('n_a');
    return trText(text);
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .map((supportedLocale) => supportedLocale.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsContext on BuildContext {
  String tr(String key) => AppLocalizations.of(this).tr(key);

  String trText(String text) => AppLocalizations.of(this).trText(text);

  String trData(Object? value) => AppLocalizations.of(this).trData(value);
}

const Map<String, Map<String, String>> _localizedValues = {'en': en, 'hi': hi};
