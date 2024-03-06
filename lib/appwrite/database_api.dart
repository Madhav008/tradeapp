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
  List<dynamic> _notStartedMatches = [];
  List<dynamic> _startedMatches = [];
  List<dynamic> _completedMatches = [];

  // Getters for the three lists
  List<dynamic> get notStartedMatches => _notStartedMatches;
  List<dynamic> get startedMatches => _startedMatches;
  List<dynamic> get completedMatches => _completedMatches;

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
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Constructor
  DatabaseAPI() {
    init();
    getMatchesList();
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

  getMatchesList() async {
    try {
      _isLoading = true;
      notifyListeners();

      _matchlist = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_Maches,
      );
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false; // Set loading state to false
      notifyListeners();
    }
  }

  void getPlayersData() async {
    try {
      _isLoading = true;
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
      _isLoading = false; // Set loading state to false
      notifyListeners();
    }
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

  void seprateMatchList() {
    if (_matchlist != null) {
      // Convert DocumentList to List
      List<Document>? matches = _matchlist?.documents;

      // Filter matches based on status
      _notStartedMatches = matches
              ?.where((match) => match.data['status'] == 'notstarted')
              .toList() ??
          <Document>[];

      _startedMatches = matches
              ?.where((match) => match.data['status'] == 'started')
              .toList() ??
          <Document>[];

      _completedMatches = matches
              ?.where((match) => match.data['status'] == 'completed')
              .toList() ??
          <Document>[];

      notifyListeners();
    }
  }

  void setMatchData(Map<String, dynamic>? newData) {
    _matchdata = newData;
    print(_matchdata['seriesname']);
    getPlayersData();
    notifyListeners();
  }
}

//   void searchIPO(String query) async {
//     try {
//       _isLoading = true; // Set loading state to true
//       notifyListeners();
//       _searchipolist = await databases.listDocuments(
//           databaseId: APPWRITE_DATABASE_ID,
//           collectionId: COLLECTION_IPO,
//           queries: [Query.search('name', query)]);

//       print(_searchipolist);
//     } catch (e) {
//       print(e);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
