// ignore_for_file: file_names
import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/appwrite/performance_provider.dart';
import 'package:fanxange/components/PlayerOrderTile.dart';
import 'package:fanxange/pages/Notification.dart';
import 'package:fanxange/pages/ScorecardPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlayersOrdersPage extends StatelessWidget {
  static String routeName = "/playerOrders";

  const PlayersOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();
    final matchkey = databaseAPI.matchdata.matchkey;
    context.read<PerformanceProvider>().getMatchPerformance(matchkey);
    // databaseAPI.setUpcomingList();
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: ExtendedAppBar(),
        body: TabBarView(
          children: [
            _allPlayers(databaseAPI, context),
            _teamA(databaseAPI),
            _teamB(databaseAPI), // Adjust as needed
          ],
        ),
      ),
    );
  }

  Skeletonizer _allPlayers(DatabaseAPI databaseAPI, context) {
    final status = databaseAPI.matchdata.status;
    final matchOrders = databaseAPI.userOrdersList
        ?.where((element) => element.matchid == databaseAPI.matchdata.matchkey)
        .toList();

    final totalInvested = matchOrders
        ?.map((element) => element.total_amount)
        .reduce((value, element) => (value ?? 0) + (element ?? 0));

    final totalWinning = matchOrders
        ?.map((e) => e.profit)
        .reduce((val, e) => (val ?? 0) + (e ?? 0));

    final netProfit = totalWinning! - totalInvested!;
    return Skeletonizer(
      enabled: databaseAPI.isPlayerLoading,
      child: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () {
            databaseAPI.getPlayersData();
          });
        },
        child: status == 'completed'
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Scorecard.routeName);
                      },
                      child: Container(
                        height: 20,
                        width: double.infinity,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                "All Players Stats ",
                                style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Icon(Icons.arrow_right)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildListItem(
                            Icons.circle,
                            Colors.red,
                            "Total Investment:",
                            totalInvested.toStringAsFixed(2)),
                        _buildListItem(Icons.circle, Colors.blue,
                            "Total Winning: ", totalWinning.toStringAsFixed(2)),
                        _buildListItem(Icons.circle, Colors.green,
                            "Net Profit: ", netProfit.toStringAsFixed(2)),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                    thickness: 0.15,
                    height: 2,
                  ),
                  Expanded(
                    child: ListView.builder(
                      // shrinkWrap: true,
                      itemCount: databaseAPI.playersdata?.length,
                      itemBuilder: (context, index) {
                        var ipodata = databaseAPI.playersdata?[index];
                        return PlayerOrderTile(playersdata: ipodata);
                      },
                    ),
                  ),
                ],
              )
            : ListView.builder(
                // shrinkWrap: true,
                itemCount: databaseAPI.playersdata?.length,
                itemBuilder: (context, index) {
                  var ipodata = databaseAPI.playersdata?[index];
                  return PlayerOrderTile(playersdata: ipodata);
                },
              ),
      ),
    );
  }

  ListView _teamA(DatabaseAPI databaseAPI) {
    return ListView.builder(
      // shrinkWrap: true,
      itemCount: databaseAPI.teamAPlayers.length,
      itemBuilder: (context, index) {
        var ipodata = databaseAPI.teamAPlayers[index];
        return PlayerOrderTile(playersdata: ipodata);
      },
    );
  }

  ListView _teamB(DatabaseAPI databaseAPI) {
    return ListView.builder(
      // shrinkWrap: true,
      itemCount: databaseAPI.teamBPlayers.length,
      itemBuilder: (context, index) {
        var ipodata = databaseAPI.teamBPlayers[index];
        return PlayerOrderTile(playersdata: ipodata);
      },
    );
  }
}

class ExtendedAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();
    final ipodata = databaseAPI.matchdata;

    return AppBar(
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.grey[600],
          ),
          onPressed: () =>
              Navigator.pushNamed(context, NotificationPage.routeName),
        ),
      ],
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
      bottom: TabBar(
        tabs: [
          const Tab(text: 'All'),
          Tab(text: ipodata.team1Display),
          Tab(text: ipodata.team2Display),
        ],
      ),
      flexibleSpace: Column(
        children: [
          const SizedBox(
            height: 35,
          ),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Buy',
                ),
                TextSpan(
                  text: '/Sell ',
                  style: TextStyle(
                    color: Color(0xFFFE9879),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF21899C),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.network(
                      ipodata.team1Logo ?? '',
                      height: 60,
                      width: 60,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (ipodata.team1Display),
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                (" vs "),
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                (ipodata.team2Display),
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //Design a container in which timer is going hh:mm:ss
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ipodata.status == "notstarted"
                                ? CountdownTimer(
                                    endTime: DateTime.parse(ipodata.startDate
                                                .toIso8601String() ??
                                            '')
                                        .millisecondsSinceEpoch,
                                    textStyle: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    ipodata.status == "completed"
                                        ? "Completed"
                                        : "Pending",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Image.network(
                      ipodata.team2Logo ?? '',
                      height: 60,
                      width: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(180.0); // Set your desired height here
}

Widget _buildListItem(IconData icon, Color color, String text, String amount) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 12, color: color),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(fontSize: 14.5),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          amount,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}
