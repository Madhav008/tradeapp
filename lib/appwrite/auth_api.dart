import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fanxange/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:fanxange/Model/UsersModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
}

class AuthAPI extends ChangeNotifier {
  static final AuthAPI _authAPI = AuthAPI._internal();

  factory AuthAPI() {
    return _authAPI;
  }

  AuthAPI._internal() {
    init();
  }

  final Dio _dio = Dio();
  AuthStatus _status = AuthStatus.uninitialized;
  static User? _currentUser;
  late SharedPreferences _prefs;

  AuthStatus get status => _status;
  static User? get currentUser => _currentUser;
  String? get username => _currentUser?.user.displayName;
  String? get email => _currentUser?.user.email;
  String? get userid => _currentUser?.user.id;

  String? _forgetEmail;
  String? get forgetEmail => _forgetEmail;

  String? _otp;
  String? get otp => _otp;

  bool? _isVerified = false;
  bool? get isVerified => _isVerified;

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
      _currentUser = user;
      _status = AuthStatus.authenticated;

      await _prefs.setString('token', user.token);
      // Save token to SharedPreferences
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

  forgetPass(email) async {
    try {
      final response = await _dio.post(
        FORGET_ENDPOINT,
        data: {
          'email': email,
        },
      );
      _forgetEmail = email;
      notifyListeners();
      final message = jsonDecode(jsonEncode(response.data))['message'];
      Fluttertoast.showToast(msg: message);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Retry Limit exceeded. Please try again after some time.");
    }
  }

  verify(otp) async {
    try {
      final response = await _dio.post(
        VERIFY_ENDPOINT,
        data: {
          'email': _forgetEmail,
          'otp': otp,
        },
      );
      final message = jsonDecode(jsonEncode(response.data))['message'];
      Fluttertoast.showToast(msg: message);
      _otp = otp;
      if (response.statusCode == 200) {
        _isVerified = true;
      } else {
        _isVerified = false;
      }
      notifyListeners();
    } catch (e) {
      print(e);
      _isVerified =
          false; // Ensure isVerified is set to false if OTP verification fails
      notifyListeners();
      Fluttertoast.showToast(msg: "OTP Expired or Invalid");
    }
  }

  changePassword(password) async {
    print({'email': _forgetEmail, 'otp': _otp, 'newPassword ': password});
    try {
      final response = await _dio.post(
        RESET_ENDPOINT,
        data: {
          'email': _forgetEmail,
          'otp': _otp.toString(),
          'newPassword': password.toString()
        },
      );
      final message = jsonDecode(jsonEncode(response.data))['message'];
      Fluttertoast.showToast(msg: message);
      notifyListeners();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Session Expired");
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
