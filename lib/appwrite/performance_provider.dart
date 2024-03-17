import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fanxange/Model/MatchPeformanceModel.dart';
import 'package:fanxange/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerformanceProvider with ChangeNotifier {
  late MatchPerformance _matchPerformance;

  MatchPerformance get matchPerformance => _matchPerformance;

  bool _isMatchPerformanceLoading = false;

  bool get isMatchPerformanceLoading => _isMatchPerformanceLoading;

  getStringFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myString = prefs.getString('token');
    return myString;
  }

  getMatchPerformance(String matchkey) async {
    final _token = await getStringFromSharedPreferences();
    _isMatchPerformanceLoading = true;
    notifyListeners();

    try {
      final res = await Dio().get(
        GET_MATCH_STATS_ENDPOINT + '/${matchkey}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_token}',
          },
        ),
      );
      _matchPerformance = matchPerformanceFromJson(jsonEncode(res.data));

      _isMatchPerformanceLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _isMatchPerformanceLoading = false;
      notifyListeners();
    }
  }
}

