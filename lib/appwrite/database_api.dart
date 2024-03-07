import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:fanxange/appwrite/auth_api.dart';
import 'package:fanxange/constants/constants.dart';

class DatabaseAPI with ChangeNotifier {
  Client client = Client();
  late final Account account;
  late final Databases databases;
  final AuthAPI auth = AuthAPI();

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

  // Constructor
  DatabaseAPI() {
    init();
    seprateMatchList();
  }

  init() {
    client
        .setEndpoint(APPWRITE_URL)
        .setProject(APPWRITE_PROJECT_ID)
        .setSelfSigned();
    account = Account(client);
    databases = Databases(client);
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
      print(e);
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
      // notifyListeners();

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
