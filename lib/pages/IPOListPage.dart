import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/pages/Notification.dart';
import 'package:fanxange/pages/Search.dart';
import 'package:provider/provider.dart';

class IPOListPage extends StatelessWidget {
  const IPOListPage({Key? key});
  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();
    // databaseAPI.setUpcomingList();
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: _appBar(context),
        body: TabBarView(
          children: [
            _upcomingIpoList(databaseAPI),
            _openIpoList(databaseAPI),
            _closedIpoList(databaseAPI), // Adjust as needed
          ],
        ),
      ),
    );
  }

  ListView _upcomingIpoList(DatabaseAPI databaseAPI) {
    databaseAPI.setUpcomingList();
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: databaseAPI.upcomingIpoList?.documents.length ?? 0,
        itemBuilder: (context, index) {
          if (databaseAPI.isLoading) {
            // Loading indicator when data is being fetched
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var ipodata = databaseAPI.upcomingIpoList?.documents[index].data;
            return IPOListTile(ipodata: ipodata);
          }
        });
  }

  ListView _openIpoList(DatabaseAPI databaseAPI) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: databaseAPI.openIpoList?.documents.length ?? 0,
        itemBuilder: (context, index) {
          if (databaseAPI.isLoading) {
            // Loading indicator when data is being fetched
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var ipodata = databaseAPI.openIpoList?.documents[index].data;
            return IPOListTile(ipodata: ipodata);
          }
        });
  }

  ListView _closedIpoList(DatabaseAPI databaseAPI) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: databaseAPI.closeIpoList?.documents.length ?? 0,
        itemBuilder: (context, index) {
          if (databaseAPI.isLoading) {
            // Loading indicator when data is being fetched
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var ipodata = databaseAPI.closeIpoList?.documents[index].data;
            return IPOListTile(ipodata: ipodata);
          }
        });
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: Icon(
            FontAwesomeIcons.magnifyingGlass, // Corrected the icon usage
            color: Colors.grey[600],
          ),
          onPressed: () => Navigator.pushNamed(context, SearchPage.routeName),
        ),
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
                    text: 'IPO ',
                  ),
                  TextSpan(
                    text: 'Premium ',
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
          Tab(text: 'Open'),
          Tab(text: 'Closed'),
        ],
      ),
    );
  }
}
