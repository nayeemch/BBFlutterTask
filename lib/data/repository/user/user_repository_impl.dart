import 'dart:async';

import 'package:boilerplate/domain/repository/user/user_repository.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/exceptions/network_exceptions.dart';

import '../../../domain/entity/user/user.dart';
import '../../../domain/entity/user/jwt_auth_response.dart';
import '../../../domain/usecase/user/login_usecase.dart';

class UserRepositoryImpl extends UserRepository {
  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;
  final RestClient _restClient;

  // constructor
  UserRepositoryImpl(this._sharedPrefsHelper, this._restClient);

  // login
  @override
  Future<User?> login(LoginParams params) async {
    try {
      // prepare form data for JWT login
      final Map<String, String> formData = {
        'username': params.username,
        'password': params.password,
      };

      // make API call
      final response = await _restClient.postFormData(
        Endpoints.jwtLogin,
        body: formData,
      );

      // check if response is valid
      if (response is Map<String, dynamic>) {
        // check required fields
        if (!response.containsKey('access_token')) {
          throw AuthException(
            message:
                'Invalid credentials. Please check your username and password.',
            statusCode: 401,
          );
        }

        // parse JWT response
        final jwtResponse = JwtAuthResponse.fromJson(response);

        // convert to user object
        final user = User.fromJwtAuthResponse(jwtResponse);

        // save user data to shared prefs
        await _saveUserData(user);

        return user;
      }

      throw AuthException(
        message: 'Invalid response from server',
        statusCode: 500,
      );
    } on AuthException catch (e) {
      // Convert API error messages to user-friendly message
      throw AuthException(
        message:
            'Invalid credentials. Please check your username and password.',
        statusCode: e.statusCode ?? 401,
      );
    } on NetworkException {
      // rethrow network exceptions
      rethrow;
    } catch (e) {
      print('Login error: $e');
      // generic auth exception for other errors
      throw AuthException(
        message:
            'Invalid credentials. Please check your username and password.',
        statusCode: 401,
      );
    }
  }

  // save user data
  Future<void> _saveUserData(User user) async {
    if (user.accessToken != null) {
      await _sharedPrefsHelper.saveAuthToken(user.accessToken!);
    }
    if (user.refreshToken != null) {
      await _sharedPrefsHelper.saveRefreshToken(user.refreshToken!);
    }
    if (user.userDisplayName != null) {
      await _sharedPrefsHelper.saveUserDisplayName(user.userDisplayName!);
    }
    if (user.userEmail != null) {
      await _sharedPrefsHelper.saveUserEmail(user.userEmail!);
    }
    if (user.userId != null) {
      await _sharedPrefsHelper.saveUserId(user.userId!);
    }
  }

  @override
  Future<void> saveIsLoggedIn(bool value) =>
      _sharedPrefsHelper.saveIsLoggedIn(value);

  @override
  Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;
}
