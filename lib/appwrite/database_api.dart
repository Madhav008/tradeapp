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


  var _searchipolist;
  DocumentList? get searchipolist => _searchipolist;

  var _openIpoList;
  DocumentList? get openIpoList => _openIpoList;

  var _closeIpoList;
  DocumentList? get closeIpoList => _closeIpoList;

  var _upcomingIpoList;
  DocumentList? get upcomingIpoList => _upcomingIpoList;

  var _ipodata;
  Map<String, dynamic> get ipodata => _ipodata;

  // Loading state
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  var _ipographdata;
  List<Document> get ipographdata => _ipographdata;

  // Constructor
  DatabaseAPI() {
    init();
    getMatchesList();
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

  void setUpcomingList() {
    DateTime today = DateTime.now();

    _upcomingIpoList = _ipolist;

    print(_upcomingIpoList);
    notifyListeners();
  }

  void setIpoData(Map<String, dynamic>? newData) {
    _ipodata = newData;
    getIPOGraph(newData?['id']);
    notifyListeners();
  }

  void getIPOGraph(int id) async {
    try {
      _isLoading = true; // Set loading state to true
      if (_ipographdata != null) {
        _ipographdata.clear();
      }
      notifyListeners();
      // Fetch data from the database
      var graphData = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_IPOGRAPH,
        queries: [
          Query.equal('ipoid', [id])
        ],
      );

      // Iterate through the fetched documents and transform the data
      _ipographdata = graphData.documents;
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  void searchIPO(String query) async {
    try {
      _isLoading = true; // Set loading state to true
      notifyListeners();
      _searchipolist = await databases.listDocuments(
          databaseId: APPWRITE_DATABASE_ID,
          collectionId: COLLECTION_IPO,
          queries: [Query.search('name', query)]);

      print(_searchipolist);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
