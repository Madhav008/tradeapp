import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:fanxange/appwrite/auth_api.dart';
import 'package:fanxange/constants/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DatabaseAPI with ChangeNotifier {
  Client client = Client();
  late final Account account;
  late final Databases databases;
  final AuthAPI authApi = AuthAPI();

  // Getter
  DocumentList? _matchlist;
  DocumentList? get matchlist => _matchlist;

  // Declare three lists globally
  DocumentList? _notStartedMatches;
  DocumentList? _startedMatches;
  DocumentList? _completedMatches;

  // Getters for the three lists
  DocumentList? get notStartedMatches => _notStartedMatches;
  DocumentList? get startedMatches => _startedMatches;
  DocumentList? get completedMatches => _completedMatches;

  var _matchdata;
  Map<String, dynamic> get matchdata => _matchdata;

  var _playersdata;
  DocumentList? get playersdata => _playersdata;

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

  late String _orderType;
  String get orderType => _orderType;

  // Private constructor
  DatabaseAPI._internal() {
    init();
    seprateMatchList();
    getPlatformFees();
  }

  // Public factory constructor
  factory DatabaseAPI() {
    _instance ??= DatabaseAPI._internal();
    return _instance!;
  }

  init() {
    try {
      client
          .setEndpoint(APPWRITE_URL)
          .setProject(APPWRITE_PROJECT_ID)
          .setSelfSigned();
      account = Account(client);
      databases = Databases(client);
    } catch (e) {
      print("Error initializing database: $e");
      Fluttertoast.showToast(
        msg: "Failed to initialize database. Please try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
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
      );

      await databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_orders,
        documentId: ID.unique(),
        data: myOrder.toJson(),
      );

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

  setPlayerPrice(int price) {
    _playerPrice = price;
    notifyListeners();
  }

  setUserId(String? id) {
    _userid = id;
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

  Future<void> getPlatformFees() async {
    try {
      DocumentList _data = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_Fees,
      );
      _platformFees = _data.documents.first.data['fees'];
      print(platformFees);
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

  void getPlayersData() async {
    try {
      _isPlayerLoading = true;
      notifyListeners();

      _playersdata = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_Players,
        queries: [
          Query.equal('matchkey', [_matchdata['matchkey']]),
        ],
      );
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
      _isPlayerLoading = false; // Set loading state to false
      notifyListeners();
    }

    sepratePlayerList();
  }

  void sepratePlayerList() {
    // Clear existing lists before updating
    _teamAPlayers.clear();
    _teamBPlayers.clear();

    if (_playersdata != null) {
      // Convert DocumentList to List
      List<Document>? players = _playersdata!.documents;

      // Separate players into Team A and Team B

      _teamAPlayers =
          players?.where((player) => player.data['team'] == 'team1').toList() ??
              <Document>[];

      _teamBPlayers =
          players?.where((player) => player.data['team'] == 'team2').toList() ??
              <Document>[];

      print('Team A Players: $_teamAPlayers');
      print('Team B Players: $_teamBPlayers');

      notifyListeners();
    }
  }

  void seprateMatchList() async {
    try {
      // Check if _matchlist is not null
      _isMatchLoading = true;
      notifyListeners();

      print("Seprate Matches List Called");
      // Filter matches based on status
      _notStartedMatches = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_Maches,
        queries: [
          Query.equal('status', ["notstarted"]),
        ],
      );

      _startedMatches = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_Maches,
        queries: [
          Query.equal('status', ["started"]),
        ],
      );

      _completedMatches = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_Maches,
        queries: [
          Query.equal('status', ["completed"]),
        ],
      );
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

  //

  void setMatchData(Map<String, dynamic>? newData) {
    _matchdata = newData;
    print(_matchdata['seriesname']);
    getPlayersData();
    notifyListeners();
  }
}

class Order implements Model {
  final int player_price;
  final String order_type;
  final int shares;
  final double total_amount;
  final String? userid;
  final double platformFees;

  // Default constructor
  Order({
    required this.player_price,
    required this.order_type,
    required this.shares,
    required this.total_amount,
    required this.userid,
    required this.platformFees,
  });
  // Setter methods

  // toJson method to convert the object to a Map
  Map<String, dynamic> toJson() {
    return {
      'player_price': player_price,
      'order_type': order_type,
      'shares': shares,
      'total_amount': total_amount,
      'platformFees': platformFees,
      'userid': userid,
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'player_price': player_price,
      'order_type': order_type,
      'shares': shares,
      'total_amount': total_amount,
      'platformFees': platformFees,
      'userid': userid,
    };
  }
}
