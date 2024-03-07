import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/pages/Notification.dart';
import 'package:fanxange/pages/Search.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MatchListPage extends StatelessWidget {
  const MatchListPage({Key? key});
  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();
    // databaseAPI.seprateMatchList();
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

  Skeletonizer _upcomingMatchList(DatabaseAPI databaseAPI) {
    // databaseAPI.seprateMatchList();
    return Skeletonizer(
      enabled: databaseAPI.isMatchLoading,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: databaseAPI.notStartedMatches?.documents.length ?? 0,
          itemBuilder: (context, index) {
            var ipodata = databaseAPI.notStartedMatches?.documents[index];
            return MatchListTile(ipodata: ipodata);
          }),
    );
  }

  Skeletonizer _openMatchList(DatabaseAPI databaseAPI) {
    return Skeletonizer(
      enabled: databaseAPI.isMatchLoading,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: databaseAPI.startedMatches?.documents.length ?? 0,
          itemBuilder: (context, index) {
            var ipodata = databaseAPI.startedMatches?.documents[index];
            return MatchListTile(ipodata: ipodata);
          }),
    );
  }

  Skeletonizer _closedMatchList(DatabaseAPI databaseAPI) {
    return Skeletonizer(
      enabled: databaseAPI.isMatchLoading,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: databaseAPI.completedMatches?.documents.length ?? 0,
          itemBuilder: (context, index) {
            var ipodata = databaseAPI.completedMatches?.documents[index];
            return MatchListTile(ipodata: ipodata);
          }),
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
        )
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
                children: [
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
      bottom: TabBar(
        tabs: [
          Tab(text: 'Upcoming'),
          Tab(text: 'Live'),
          Tab(text: 'Results'),
        ],
      ),
    );
  }
}
