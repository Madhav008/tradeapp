import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/components/PlayerListTile.dart';
import 'package:fanxange/pages/Notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlayerPrice extends StatelessWidget {
  static String routeName = "/players";

  const PlayerPrice({Key? key});

  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();
    // databaseAPI.setUpcomingList();
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: ExtendedAppBar(),
        body: TabBarView(
          children: [
            _allPlayers(databaseAPI),
            _teamA(databaseAPI),
            _teamB(databaseAPI), // Adjust as needed
          ],
        ),
      ),
    );
  }

  Skeletonizer _allPlayers(DatabaseAPI databaseAPI) {
    return Skeletonizer(
      enabled: databaseAPI.isPlayerLoading,
      child: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () {
            databaseAPI.getPlayersData();
          });
        },
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          // shrinkWrap: true,
          itemCount: databaseAPI.playersdata?.documents.length,
          itemBuilder: (context, index) {
            var ipodata = databaseAPI.playersdata?.documents[index];
            return PlayerListTile(playersdata: ipodata);
          },
        ),
      ),
    );
  }

  GridView _teamA(DatabaseAPI databaseAPI) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      // shrinkWrap: true,
      itemCount: databaseAPI.teamAPlayers.length,
      itemBuilder: (context, index) {
        var ipodata = databaseAPI.teamAPlayers[index];
        return PlayerListTile(playersdata: ipodata);
      },
    );
  }

  GridView _teamB(DatabaseAPI databaseAPI) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      // shrinkWrap: true,
      itemCount: databaseAPI.teamBPlayers.length,
      itemBuilder: (context, index) {
        var ipodata = databaseAPI.teamBPlayers[index];
        return PlayerListTile(playersdata: ipodata);
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
          Tab(text: ipodata['team1display']),
          Tab(text: ipodata['team2display']),
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
                      ipodata['team1logo'] ?? '',
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
                                (ipodata['team1display']),
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
                                (ipodata['team2display']),
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
                            child: ipodata['status'] == "notstarted"
                                ? CountdownTimer(
                                    endTime: DateTime.parse(
                                            ipodata['start_date'] ?? '')
                                        .millisecondsSinceEpoch,
                                    textStyle: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    ipodata['status'] == "completed"
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
                      ipodata['team2logo'] ?? '',
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
      Size.fromHeight(200.0); // Set your desired height here
}
