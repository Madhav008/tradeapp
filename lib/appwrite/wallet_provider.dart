import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fanxange/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import FlutterToast

class WalletProvider with ChangeNotifier {
  double _balance = 0.00;
  late String? _walletId;
  late String? _userid;
  bool _isLoading = false;
  List<Transactions> _transactions = [];
  List<Transactions> get transactions => _transactions;
  bool _isTransactionLoading = true;
  bool get isTransactionLoading => _isTransactionLoading;
  bool get walletLoading => _isLoading;
  double get balance => _balance;

  getStringFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myString = prefs.getString('token');
    return myString;
  }

  Future<void> getWallet(String? userid) async {
    final _token = await getStringFromSharedPreferences();

    try {
      if (userid == null) {
        print("Error: User ID is null in getWallet");
        // Handle the case where userid is null
        return;
      }
      final wallet = await Dio().get(
        GET_WALLET_ENDPOINT + '/${userid}', // Replace with your API endpoint
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_token}',
        }),
      );
      // print(wallet.data);
      _balance = jsonDecode(jsonEncode(wallet.data))['balance'].toDouble();
      _walletId = jsonDecode(jsonEncode(wallet.data))['wallet']['_id'];
      _userid = userid;
      await getTrasactions();
      notifyListeners();
    } catch (e) {
      print('Error fetching wallet: $e');
      Fluttertoast.showToast(
          msg: 'Error fetching wallet: $e', toastLength: Toast.LENGTH_SHORT);
    }
  }

  Future<void> addMoney(double amount) async {
    final _token = await getStringFromSharedPreferences();

    try {
      _isLoading = true;
      notifyListeners();

      await Dio().post(DEPOSIT_ENDPOINT, // Replace with your API endpoint
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_token}',
          }),
          data: {"userid": _userid, "amount": amount});
      await getWallet(_userid);
      _isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(
          msg: 'Money added successfully', toastLength: Toast.LENGTH_SHORT);
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      print('Error adding money: $e');
      Fluttertoast.showToast(
          msg: 'Error adding money: $e', toastLength: Toast.LENGTH_SHORT);
    }
  }

  Future<void> withdrawMoney(double amount) async {
    final _token = await getStringFromSharedPreferences();

    try {
      _isLoading = true;
      notifyListeners();

      await Dio().post(WITHDRAW_ENDPOINT, // Replace with your API endpoint
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_token}',
          }),
          data: {"userid": _userid, "amount": amount});
      await getWallet(_userid);

      _isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(
          msg: 'Money withdrawn successfully', toastLength: Toast.LENGTH_SHORT);
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      print('Error withdrawing money: $e');
      Fluttertoast.showToast(
          msg: 'Error withdrawing money: $e', toastLength: Toast.LENGTH_SHORT);
    }
  }

  getTrasactions() async {
    final _token = await getStringFromSharedPreferences();

    try {
      _isTransactionLoading = true;
      notifyListeners();

      final res = await Dio().get(
        TRANSACTION_ENDPOINT +
            '/${_walletId}', // Replace with your API endpoint
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_token}',
        }),
      );

      final List<dynamic> transData = res.data['userTransactions'];

      final List<Transactions> transactions = List<Transactions>.from(
        transData.map((json) => Transactions.fromJson(json)),
      );

      _transactions = transactions;
      _isTransactionLoading = false;
      notifyListeners();
    } catch (e) {
      _isTransactionLoading = false;
      notifyListeners();

      print('Error getting transactions: $e');
      Fluttertoast.showToast(
        msg: 'Error getting transactions: $e',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }
}

class Transactions {
  final String transactionId;
  final double amount;
  final String type;
  final String date;

  Transactions({
    required this.transactionId,
    required this.amount,
    required this.type,
    required this.date,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      transactionId: json['transactionId'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      date: json['createdAt'],
    );
  }
}
