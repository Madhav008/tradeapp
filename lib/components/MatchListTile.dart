import 'package:fanxange/Model/MatchesModel.dart';
import 'package:fanxange/pages/PlayerOrdersPage.dart';
import 'package:fanxange/pages/PlayersPricePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:provider/provider.dart';

class MatchListTile extends StatelessWidget {
  const MatchListTile({
    super.key,
    required this.matchdata,
  });

  final MatchElement? matchdata;

  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          databaseAPI.setMatchData(matchdata);
          if (databaseAPI.isPortfolio) {
            Navigator.pushNamed(context, PlayersOrdersPage.routeName);
          } else {
            Navigator.pushNamed(context, PlayerPrice.routeName);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                matchdata?.team1Logo != null
                    ? Image.network(
                        matchdata?.team1Logo ?? '',
                        height: 60,
                        width: 50,
                      )
                    : Image.asset('assets/images/avtar1.png'),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      (matchdata!.seriesname),
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (matchdata!.team1Display),
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
                          (matchdata!.team2Display),
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
                      child: matchdata?.status == "notstarted"
                          ? CountdownTimer(
                              endTime: DateTime.parse(
                                      matchdata!.startDate.toString() ?? '')
                                  .millisecondsSinceEpoch,
                              textStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              matchdata?.status == "completed"
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
                matchdata?.team1Logo != null
                    ? Image.network(
                        matchdata?.team2Logo ?? '',
                        height: 60,
                        width: 50,
                      )
                    : Image.asset('assets/images/avtar1.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String truncateName(String name, int maxLength) {
    if (name.length <= maxLength) {
      return name;
    } else {
      return name.substring(0, maxLength) + '...';
    }
  }
}
