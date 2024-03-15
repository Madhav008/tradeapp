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

class PortfolioPage extends StatelessWidget {
  PortfolioPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: _appBar(context),
        body: databaseAPI.isUserOrderLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : TabBarView(
                children: [
                  _upcomingMatchList(databaseAPI),
                  _completedMatchList(databaseAPI),
                ],
              ),
      ),
    );
  }

  Widget _upcomingMatchList(DatabaseAPI databaseAPI) {
    return RefreshIndicator(
      onRefresh: () async {
        // Add logic to fetch updated data
        databaseAPI.getUserOrder(databaseAPI.userid);
      },
      child: Skeletonizer(
        enabled: databaseAPI.isMatchLoading,
        child: databaseAPI.userMatches?.length == 0
            ? const Center(
                child: Text("No Orders Present"),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: databaseAPI.userMatches?.length ?? 0,
                itemBuilder: (context, index) {
                  var matchdata = databaseAPI.userMatches?[index];
                  return MatchListTile(matchdata: matchdata);
                },
              ),
      ),
    );
  }

  Widget _completedMatchList(DatabaseAPI databaseAPI) {
    return RefreshIndicator(
      onRefresh: () async {
        // Add logic to fetch updated data
        databaseAPI.getUserOrder(databaseAPI.userid);
      },
      child: Skeletonizer(
        enabled: databaseAPI.isMatchLoading,
        child: databaseAPI.userCompletedMatches?.length == 0
            ? const Center(
                child: Text("No Completed Orders Present"),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: databaseAPI.userCompletedMatches?.length ?? 0,
                itemBuilder: (context, index) {
                  var matchdata = databaseAPI.userCompletedMatches?[index];
                  return MatchListTile(matchdata: matchdata);
                },
              ),
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
          onPressed: () => context.read<AuthAPI>().logout(),
        ),
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
      // Add the headline "Portfolio" to the AppBar
      bottom: const TabBar(
        tabs: [
          Tab(text: 'Current Orders'),
          Tab(text: 'Previous Orders'),
        ],
      ),
    );
  }
}
