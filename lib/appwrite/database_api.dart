import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fanxange/Model/UserOrderModel.dart';
import 'package:fanxange/appwrite/auth_api.dart';
import 'package:fanxange/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:fanxange/Model/MatchesModel.dart';
import 'package:fanxange/Model/PlayerModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseAPI with ChangeNotifier {
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
  bool get isMatchLoading => _isMatchLoading;

  bool _isPlayerLoading = true;
  bool get isPlayerLoading => _isPlayerLoading;

  bool _isPortfolio = false;
  bool get isPortfolio => _isPortfolio;

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

  late double _playerPrice;
  double get playerPrice => _playerPrice;

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

  bool _isUserOrderLoading = true;
  bool get isUserOrderLoading => _isUserOrderLoading;

  List<MatchElement> _userMatches = [];
  List<MatchElement>? get userMatches => _userMatches;

  List<MatchElement> _userCompletedMatches = [];
  List<MatchElement>? get userCompletedMatches => _userCompletedMatches;

  List<Player> _userPlayers = [];
  List<Player>? get userPlayers => _userPlayers;

  List<Order> _userOrdersList = [];
  List<Order>? get userOrdersList => _userOrdersList;

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

  getStringFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myString = prefs.getString('token');
    return myString;
  }

  // Modify this function to use Dio for fetching matches
  void seprateMatchList() async {
    final _token = await getStringFromSharedPreferences();
    try {
      _isMatchLoading = true;
      notifyListeners();

      // Fetch upcoming matches
      Response<dynamic> upcomingResponse = await dio.get(
        MATCH_UPCOMING, // Replace with your API endpoint
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_token}',
        }),
      );
      _notStartedMatches = Match.fromJson(upcomingResponse.data);

      // Fetch live matches
      Response<dynamic> liveResponse = await dio.get(
        MATCH_LIVE, // Replace with your API endpoint
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_token}',
        }),
      );

      _startedMatches = Match.fromJson(liveResponse.data);

      // Fetch completed matches
      Response<dynamic> completedResponse = await dio.get(
        MATCH_RESULT, // Replace with your API endpoint
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_token}',
        }),
      );
      _completedMatches = Match.fromJson(completedResponse.data);
      notifyListeners();

      // print("upcoming Matches: ${notStartedMatches?.matches.length}");
      // print("live Matches: ${startedMatches?.matches.length}");
      // print("completed Matches: ${completedMatches?.matches.length}");
    } catch (e) {
      print("Error in separateMatchList: $e");
      Fluttertoast.showToast(
        msg: "Failed to fetch match list. Please try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      // print("Made the match data loading false");
      // print("upcoming Matches: $_notStartedMatches");
      // print("live Matches: $_startedMatches");
      // print("completed Matches: $_completedMatches");
      _isMatchLoading = false;
      notifyListeners();
    }
  }

  // Modify this function to use Dio for fetching player data
  void getPlayersData() async {
    final _token = await getStringFromSharedPreferences();

    try {
      _isPlayerLoading = true;
      notifyListeners();
      print(_isPortfolio);
      if (_isPortfolio == false) {
        Response<dynamic> playersResponse =
            await dio.post(PLAYER_ENDPOINT, // Replace with your API endpoint
                options: Options(headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${_token}',
                }),
                data: {
              "matchkey": matchdata.matchkey,
            });
        List<Player> playersList =
            playerFromJson(jsonEncode(playersResponse.data));
        _playersdata = playersList;
      } else {
        _playersdata = _userPlayers
            .where((e) => e.matchkey == matchdata.matchkey)
            .toList();
        notifyListeners();
      }
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
    final _token = await getStringFromSharedPreferences();

    try {
      // Make a Dio request
      final response = await Dio().get(
        FEES_ENDPOINT,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_token}',
        }),
      );
      if (response.statusCode == 200) {
        _platformFees = response.data['fees'];
        // print(_platformFees);
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

  setPlayerPrice(double price) {
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
          timestamp: DateTime.now().toString(),
          total_amount: _totalAmount,
          userid: userid,
          platformFees: _fees,
          matchid: matchdata.matchkey,
          playerid: _playerid,
          teamid: _teamid,
          profit: 0.00,
          player_point: 0,
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
    await getUserOrder(userid);
  }

  createOrderHelper(Order order) async {
    final _token = await getStringFromSharedPreferences();

    try {
      final res = await dio.post(CREATE_ORDER_ENDPOINT,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_token}',
          }),
          data: order.toJson());
      print(res.data);
    } catch (e) {
      print(e);
    }
  }

  getUserOrder(String? userid) async {
    final _token = await getStringFromSharedPreferences();

    try {
      _isUserOrderLoading = true;
      notifyListeners();

      if (userid == null) {
        print("Error: User ID is null in GetUserOrder");
        // Handle the case where userid is null
        return;
      }

      final response = await Dio().get(
        '$GETUSERR_ORDER_ENDPOINT/$userid',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_token}',
        }),
      );
      print('$GETUSERR_ORDER_ENDPOINT/$userid');

      if (response.data is List) {
        List<dynamic> userOrders = response.data;
        List<MatchElement> luserMatches = [];
        List<Player> luserPlayers = [];
        List<Order> luserOrdersList = [];

        for (var userOrder in userOrders) {
          if (userOrder['match'] != null && userOrder['players'] != null) {
            var userOrderInstance = UserOrder.fromJson(userOrder);

            // Add user match to the array
            luserMatches.add(userOrderInstance.match);

            for (var playerOrder in userOrderInstance.playerOrders) {
              // Add user player to the array
              luserPlayers.add(playerOrder.player);

              for (var order in playerOrder.orders) {
                // Add user order to the array
                luserOrdersList.add(order);

                // Add your logic to process the order information here
              }
            }
          }
        }

        _userMatches =
            luserMatches.where((e) => e.status == 'notstarted').toList();
        _userCompletedMatches =
            luserMatches.where((e) => e.status != 'notstarted').toList();
        _userPlayers = luserPlayers;
        _userOrdersList = luserOrdersList;

        // print("User Matches: $userMatches");
        // print("User Players: $userPlayers");
        // print("User Orders: $userOrdersList");

        _isUserOrderLoading = false;
        notifyListeners();
      } else {
        print("Error: Unexpected response format");
      }
    } catch (e) {
      print("Unexpected Error: $e");
    } finally {
      _isUserOrderLoading = false;
      notifyListeners();
    }
  }

  setIsPortfolio(bool portfolio) {
    _isPortfolio = portfolio;
    print(portfolio);
    notifyListeners();
  }
}

class Order {
  final double player_price;
  final String order_type;
  final int shares;
  final String timestamp;
  final double total_amount;
  final double profit;
  final String? userid;
  final double platformFees;
  final String? playerid;
  final String? matchid;
  final String? teamid;
  final String? walletId;
  final int player_point;

  // Updated constructor to include all fields
  Order({
    required this.player_price,
    required this.order_type,
    required this.shares,
    required this.timestamp,
    required this.total_amount,
    required this.profit,
    required this.userid,
    required this.platformFees,
    required this.playerid,
    required this.matchid,
    required this.teamid,
    required this.walletId,
    required this.player_point,
  });

  // Factory constructor to create an Order instance from a Map
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      player_price: (json['price'] as num).toDouble(), // Convert to double
      total_amount: (json['amount'] as num).toDouble(), // Convert to double
      profit: (json['profit'] as num).toDouble(),
      shares: json['qty'] ?? 0,
      userid: json['user'] ?? '',
      order_type: json['orderType'] ?? '',
      playerid: json['playerId'] ?? '',
      matchid: json['matchId'] ?? '',
      teamid: json['teamId'] ?? '',
      timestamp: json['timestamp'] ?? '',
      player_point: json['player_point'] ?? '',
      platformFees: 0.00,
      walletId: '',
    );
  }

  // toJson method to convert the object to a Map
  Map<String, dynamic> toJson() {
    return {
      'price': player_price,
      'orderType': order_type,
      'qty': shares,
      'timestamp': timestamp,
      'amount': total_amount,
      'profit': profit,
      'user': userid,
      'platformFees': platformFees,
      'playerId': playerid,
      'matchId': matchid,
      'teamId': teamid,
      'walletId': walletId,
      'player_point': player_point
    };
  }
}
