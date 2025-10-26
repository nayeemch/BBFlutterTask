import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/preferences.dart';

class SharedPreferenceHelper {
  final SharedPreferences _sharedPreference;

  SharedPreferenceHelper(this._sharedPreference);

  // ---------------------------------------------------------------------------
  // Authentication Tokens
  // ---------------------------------------------------------------------------

  Future<String?> get authToken async =>
      _sharedPreference.getString(Preferences.authToken);
  Future<bool> saveAuthToken(String token) async =>
      _sharedPreference.setString(Preferences.authToken, token);
  Future<bool> removeAuthToken() async =>
      _sharedPreference.remove(Preferences.authToken);

  Future<String?> get refreshToken async =>
      _sharedPreference.getString(Preferences.refreshToken);
  Future<bool> saveRefreshToken(String token) async =>
      _sharedPreference.setString(Preferences.refreshToken, token);
  Future<bool> removeRefreshToken() async =>
      _sharedPreference.remove(Preferences.refreshToken);

  // ---------------------------------------------------------------------------
  // User Data
  // ---------------------------------------------------------------------------

  Future<String?> get userDisplayName async =>
      _sharedPreference.getString(Preferences.userDisplayName);
  Future<bool> saveUserDisplayName(String name) async =>
      _sharedPreference.setString(Preferences.userDisplayName, name);

  Future<String?> get userEmail async =>
      _sharedPreference.getString(Preferences.userEmail);
  Future<bool> saveUserEmail(String email) async =>
      _sharedPreference.setString(Preferences.userEmail, email);

  Future<String?> get userId async =>
      _sharedPreference.getString(Preferences.userId);
  Future<bool> saveUserId(String id) async =>
      _sharedPreference.setString(Preferences.userId, id);

  Future<bool> clearUserData() async {
    await Future.wait([
      removeAuthToken(),
      removeRefreshToken(),
      _sharedPreference.remove(Preferences.userDisplayName),
      _sharedPreference.remove(Preferences.userEmail),
      _sharedPreference.remove(Preferences.userId),
    ]);
    return true;
  }

  // ---------------------------------------------------------------------------
  // Login State
  // ---------------------------------------------------------------------------

  Future<bool> get isLoggedIn async =>
      _sharedPreference.getBool(Preferences.isLoggedIn) ?? false;
  Future<bool> saveIsLoggedIn(bool value) async =>
      _sharedPreference.setBool(Preferences.isLoggedIn, value);

  // ---------------------------------------------------------------------------
  // Theme
  // ---------------------------------------------------------------------------

  bool get isDarkMode =>
      _sharedPreference.getBool(Preferences.isDarkMode) ?? false;
  Future<void> changeBrightnessToDark(bool value) async =>
      _sharedPreference.setBool(Preferences.isDarkMode, value);

  // ---------------------------------------------------------------------------
  // Language
  // ---------------------------------------------------------------------------

  String? get currentLanguage =>
      _sharedPreference.getString(Preferences.currentLanguage);
  Future<void> changeLanguage(String language) async =>
      _sharedPreference.setString(Preferences.currentLanguage, language);
}
