// ignore: file_names
import 'package:fanxange/appwrite/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/pages/Notification.dart';
import 'package:fanxange/components/MatchListTile.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MatchListPage extends StatelessWidget {
  const MatchListPage({Key? key});
  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();
    // databaseAPI.seprateMatchList();
    // context.read<DatabaseAPI>().seprateMatchList();
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: _appBar(context),
        body: TabBarView(
          children: [
            _upcomingMatchList(databaseAPI),
            _openMatchList(databaseAPI),
            _closedMatchList(databaseAPI), // Adjust as needed
          ],
        ),
      ),
    );
  }

  Widget _upcomingMatchList(DatabaseAPI databaseAPI) {
    return RefreshIndicator(
      onRefresh: () async {
        databaseAPI.seprateMatchList();
      },
      child: databaseAPI.notStartedMatches == null ||
              databaseAPI.notStartedMatches?.matches.length == 0
          ? const Center(
              child: Text("No Upcoming Matches"),
            )
          : Skeletonizer(
              enabled: databaseAPI.isMatchLoading,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: databaseAPI.notStartedMatches?.matches.length ?? 0,
                itemBuilder: (context, index) {
                  var matchdata = databaseAPI
                      .notStartedMatches?.matches.reversed
                      .elementAt(index);
                  return MatchListTile(matchdata: matchdata);
                },
              ),
            ),
    );
  }

  RefreshIndicator _openMatchList(DatabaseAPI databaseAPI) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration(seconds: 1), () {
          databaseAPI.seprateMatchList();
        });
      },
      child: databaseAPI.startedMatches == null ||
              databaseAPI.startedMatches?.matches.length == 0
          ? const Center(
              child: Text("No Live Matches"),
            )
          : Skeletonizer(
              enabled: databaseAPI.isMatchLoading,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: databaseAPI.startedMatches?.matches.length ?? 0,
                  itemBuilder: (context, index) {
                    var matchdata = databaseAPI.startedMatches?.matches.reversed
                        .elementAt(index);
                    return MatchListTile(matchdata: matchdata);
                  }),
            ),
    );
  }

  RefreshIndicator _closedMatchList(DatabaseAPI databaseAPI) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration(seconds: 1), () {
          databaseAPI.seprateMatchList();
        });
      },
      child: databaseAPI.completedMatches == null ||
              databaseAPI.completedMatches?.matches.length == 0
          ? const Center(
              child: Text("No Completed Matches"),
            )
          : Skeletonizer(
              enabled: databaseAPI.isMatchLoading,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: databaseAPI.completedMatches?.matches.length ?? 0,
                  itemBuilder: (context, index) {
                    var matchdata = databaseAPI
                        .completedMatches?.matches.reversed
                        .elementAt(index);
                    return MatchListTile(matchdata: matchdata);
                  }),
            ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: Icon(
            FontAwesomeIcons.bell,
            color: Colors.grey[600],
          ),
          onPressed: () =>
              Navigator.pushNamed(context, NotificationPage.routeName),
        ),
        IconButton(
            icon: Icon(
              FontAwesomeIcons.signOut,
              color: Colors.grey[600],
            ),
            onPressed: () => context.read<AuthAPI>().logout())
      ],
      title: Padding(
        padding: const EdgeInsets.only(left: 80.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/logo2.svg',
              height: 20,
              width: 20,
            ),
            const SizedBox(
              width: 5,
            ),
            Text.rich(
              TextSpan(
                children: const [
                  TextSpan(
                    text: 'Fan',
                  ),
                  TextSpan(
                    text: 'Xange ',
                    style: TextStyle(
                      color: Color(0xFFFE9879),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF21899C),
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: const TabBar(
        tabs: [
          Tab(text: 'Upcoming'),
          Tab(text: 'Live'),
          Tab(text: 'Results'),
        ],
      ),
    );
  }
}
