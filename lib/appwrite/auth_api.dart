import 'package:dio/dio.dart';
import 'package:fanxange/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:fanxange/Model/UsersModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
}

class AuthAPI extends ChangeNotifier {
  final Dio _dio = Dio();
  AuthStatus _status = AuthStatus.uninitialized;
  static User? _currentUser;
  late SharedPreferences _prefs;

  AuthStatus get status => _status;
  static User? get currentUser => _currentUser;
  String? get username => _currentUser?.user.displayName;
  String? get email => _currentUser?.user.email;
  String? get userid => _currentUser?.user.id;

  AuthAPI() {
    init();
  }

  init() async {
    _prefs = await SharedPreferences.getInstance();
    loadUser();
  }

  loadUser() async {
    try {
      final token = _prefs.getString('token');

      if (token != null) {
        final response = await _dio.get(
          USER_PROFILE_ENDPOINT,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }),
        );
        if (response.statusCode == 200) {
          _status = AuthStatus.authenticated;
          _currentUser = User.fromJson(response.data);
          notifyListeners();
          // await WalletProvider().getWallet(_currentUser?.user?.id);
          // await DatabaseAPI().getUserOrder(_currentUser?.user?.id);
        } else {
          _status = AuthStatus.unauthenticated;
          notifyListeners();
        }
      } else {
        _status = AuthStatus.unauthenticated;
        notifyListeners();
      }
    } catch (e) {
      print("Error in loadUser: $e"); // Add this line
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } finally {
      notifyListeners();
    }
  }

  createUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _dio.post(
        REGISTER_ENDPOINT,
        data: {
          'email': email,
          'password': password,
          'username': name,
        },
      );
      final user = User.fromJson(response.data);
      // print(response.data);
      _currentUser = user;
      _status = AuthStatus.authenticated;
      notifyListeners();

      // Save token to SharedPreferences
      await _prefs.setString('token', user.token);
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        LOGIN_ENDPOINT,
        data: {
          'email': email,
          'password': password,
        },
      );
      final user = User.fromJson(response.data);
      _currentUser = user;
      _status = AuthStatus.authenticated;
      await _prefs.setString('token', user.token);
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      print(e);
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _prefs.remove('token');
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}
