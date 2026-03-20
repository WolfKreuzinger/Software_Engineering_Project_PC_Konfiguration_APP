import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLangKey = 'app_language';

class LanguageController extends ChangeNotifier {
  Locale _locale = const Locale('de');

  Locale get locale => _locale;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLangKey);
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
    SharedPreferences.getInstance().then(
      (prefs) => prefs.setString(_kLangKey, locale.languageCode),
    );
  }
}
