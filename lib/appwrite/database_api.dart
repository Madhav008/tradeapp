import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fanxange/appwrite/auth_api.dart';
import 'package:fanxange/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:fanxange/Model/MatchesModel.dart';
import 'package:fanxange/Model/PlayerModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DatabaseAPI with ChangeNotifier {
  final AuthAPI authApi = AuthAPI();

  // Getter
  MatchElement? _matchlist;
  MatchElement? get matchlist => _matchlist;

  // Declare three lists globally
  Match? _notStartedMatches;
  Match? _startedMatches;
  Match? _completedMatches;

  // Getters for the three lists
  Match? get notStartedMatches => _notStartedMatches;
  Match? get startedMatches => _startedMatches;
  Match? get completedMatches => _completedMatches;

  var _matchdata;
  MatchElement get matchdata => _matchdata;

  var _playersdata;
  List<Player>? get playersdata => _playersdata;

  // Declare two lists for Team A and Team B players
  List<dynamic> _teamAPlayers = [];
  List<dynamic> _teamBPlayers = [];

  // Getters for the two lists
  List<dynamic> get teamAPlayers => _teamAPlayers;
  List<dynamic> get teamBPlayers => _teamBPlayers;

  // Loading state
  bool _isMatchLoading = true;
  bool _isPlayerLoading = true;

  bool get isMatchLoading => _isMatchLoading;
  bool get isPlayerLoading => _isPlayerLoading;

  int _platformFees = 0;
  int get platformFees => _platformFees;

  AuthAPI authAPI = AuthAPI();
  static DatabaseAPI? _instance;

  int _shares = 1;
  int get shares => _shares;

  late double _fees;
  double get fees => _fees;

  late double _totalAmount;
  double get totalAmount => _totalAmount;

  late int _playerPrice;
  int get playerPrice => _playerPrice;

  String? _userid;
  String? get userid => _userid;

  String? _matchid;
  String? get matchid => _matchid;

  String? _playerid;
  String? get playerid => _playerid;

  String? _teamid;
  String? get teamid => _teamid;

  late String _orderType;
  String get orderType => _orderType;

  final Dio dio = Dio();

  // Private constructor
  DatabaseAPI._internal() {
    init();
  }

  // Public factory constructor
  factory DatabaseAPI() {
    _instance ??= DatabaseAPI._internal();
    return _instance!;
  }

  init() {
    seprateMatchList();
    getPlatformFees();
  }

  // Modify this function to use Dio for fetching matches
  void seprateMatchList() async {
    try {
      _isMatchLoading = true;
      notifyListeners();

      // Fetch upcoming matches
      Response<dynamic> upcomingResponse = await dio.get(
        MATCH_UPCOMING, // Replace with your API endpoint
        options: Options(headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${authApi.currentUser.token}',
        }),
      );
      _notStartedMatches = Match.fromJson(upcomingResponse.data);
      notifyListeners();

      // Fetch live matches
      Response<dynamic> liveResponse = await dio.get(
        MATCH_LIVE, // Replace with your API endpoint
        options: Options(headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${authApi.currentUser.token}',
        }),
      );

      _startedMatches = Match.fromJson(liveResponse.data);
      notifyListeners();

      // Fetch completed matches
      Response<dynamic> completedResponse = await dio.get(
        MATCH_RESULT, // Replace with your API endpoint
        options: Options(headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${authApi.currentUser.token}',
        }),
      );

      _completedMatches = Match.fromJson(completedResponse.data);
      notifyListeners();
    } catch (e) {
      print("Error in seprateMatchList: $e");
      Fluttertoast.showToast(
        msg: "Failed to fetch match list. Please try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      _isMatchLoading = false;
      notifyListeners();
    }
  }

  // Modify this function to use Dio for fetching player data
  void getPlayersData() async {
    try {
      _isPlayerLoading = true;
      notifyListeners();

      Response<dynamic> playersResponse =
          await dio.post(PLAYER_ENDPOINT, // Replace with your API endpoint
              options: Options(headers: {
                'Content-Type': 'application/json',
                // 'Authorization': 'Bearer ${authApi.currentUser.token}',
              }),
              data: {
            "matchkey": matchdata.matchkey,
          });
      List<Player> playersList =
          playerFromJson(jsonEncode(playersResponse.data));
      _playersdata = playersList;
    } catch (e) {
      print("Error fetching players data: $e");
      Fluttertoast.showToast(
        msg: "Failed to fetch players data. Please try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      _isPlayerLoading = false;
      notifyListeners();
    }
    sepratePlayerList();
  }

  void sepratePlayerList() {
    // Clear existing lists before updating
    _teamAPlayers.clear();
    _teamBPlayers.clear();

    if (_playersdata != null) {
      // Convert Player list
      List<Player> players = _playersdata!;

      // Separate players into Team A and Team B
      _teamAPlayers =
          players.where((player) => player.team == 'team1').toList();

      _teamBPlayers =
          players.where((player) => player.team == 'team2').toList();

      print('Team A Players: $_teamAPlayers');
      print('Team B Players: $_teamBPlayers');

      notifyListeners();
    }
  }

  void setMatchData(MatchElement? newData) {
    _matchdata = newData;
    // print(newData?.seriesname);
    getPlayersData();
    notifyListeners();
  }

  Future<void> getPlatformFees() async {
    try {
      // Make a Dio request
      final response = await Dio().get(FEES_ENDPOINT);
      if (response.statusCode == 200) {
        _platformFees = response.data['fees'];
        print(_platformFees);
      } else {
        print(
            'Failed to fetch platform fees. Status code: ${response.statusCode}');
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching platform fees: $e");
      Fluttertoast.showToast(
        msg: "Failed to fetch platform fees. Please try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }



  getWallet(String? userid) async {
    final wallet = await Dio().get(GET_WALLET_ENDPOINT + '/${userid}');
    try {
      print(wallet.data);
    } catch (e) {
      print(e);
    }
  }

  setPlayerPrice(int price) {
    _playerPrice = price;
    notifyListeners();
  }

  setUserId(String? id) {
    _userid = id;
    notifyListeners();
  }

  setMatchId(String? id) {
    _matchid = id;
    notifyListeners();
  }

  setPlayerId(String? id) {
    _playerid = id;
    notifyListeners();
  }

  setTeamId(String? id) {
    _teamid = id;
    notifyListeners();
  }

  clearOrder() {
    _shares = 1;
    double myplatformFees = (playerPrice * _platformFees * 0.01) * _shares;
    double mytotalAmount = (playerPrice * _shares) + myplatformFees;

    // Fixing to 2 decimal places
    _fees = double.parse(myplatformFees.toStringAsFixed(2));
    _totalAmount = double.parse(mytotalAmount.toStringAsFixed(2));

    print("fees " + _fees.toString());

    notifyListeners();
  }

  setOrderType(String type) {
    _orderType = type;
    notifyListeners();
  }

  updateQty(int qty) {
    _shares = qty;

    double myplatformFees = (playerPrice * _platformFees * 0.01) * _shares;
    double mytotalAmount = (playerPrice * _shares) + myplatformFees;

    // Fixing to 2 decimal places
    _fees = double.parse(myplatformFees.toStringAsFixed(2));
    _totalAmount = double.parse(mytotalAmount.toStringAsFixed(2));

    print("fees " + _fees.toString());
    notifyListeners();
  }

  Future<void> createOrder() async {
    try {
      Order myOrder = Order(
          player_price: _playerPrice,
          order_type: orderType,
          shares: _shares,
          total_amount: _totalAmount,
          userid: userid,
          platformFees: _fees,
          matchid: _matchid,
          playerid: _playerid,
          teamid: _teamid,
          walletId: userid);

      await createOrderHelper(myOrder);
      clearOrder();
      Fluttertoast.showToast(
        msg: "Order Created Successfully.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      notifyListeners();
    } catch (e) {
      // Handle the exception
      print("Error creating order: $e");

      // Show a toast message
      Fluttertoast.showToast(
        msg: "Failed to create order. Please try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  createOrderHelper(Order order) async {
    try {
      final res = await dio.post(CREATE_ORDER_ENDPOINT, data: order.toJson());
      print(res.data);
    } catch (e) {
      print(e);
    }
  }
}

class Order {
  final int player_price;
  final String order_type;
  final int shares;
  final double total_amount;
  final String? userid;
  final double platformFees;
  final String? playerid;
  final String? matchid;
  final String? teamid;
  final String? walletId;

  // Updated constructor to include all fields
  Order(
      {required this.player_price,
      required this.order_type,
      required this.shares,
      required this.total_amount,
      required this.userid,
      required this.platformFees,
      required this.playerid,
      required this.matchid,
      required this.teamid,
      required this.walletId});

  // Factory constructor to create an Order instance from a Map
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        player_price: json['player_price'],
        order_type: json['order_type'],
        shares: json['shares'],
        total_amount: json['total_amount'],
        userid: json['userid'],
        platformFees: json['platformFees'],
        playerid: json['playerid'],
        matchid: json['matchid'],
        teamid: json['teamid'],
        walletId: json['walletId']);
  }

  // toJson method to convert the object to a Map
  Map<String, dynamic> toJson() {
    return {
      'price': player_price,
      'orderType': order_type,
      'qty': shares,
      'amount': total_amount,
      'user': userid,
      'platformFees': platformFees,
      'playerId': playerid,
      'matchid': matchid,
      'teamid': teamid,
      'walletId': walletId
    };
  }
}
