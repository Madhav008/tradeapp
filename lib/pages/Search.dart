import 'package:appwrite/models.dart';
import 'package:fanxange/pages/PlayersPricePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:provider/provider.dart';

class MatchListTile extends StatelessWidget {
  const MatchListTile({
    super.key,
    required this.ipodata,
  });

  final Document? ipodata;

  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          databaseAPI.setMatchData(ipodata?.data);
          Navigator.pushNamed(context, PlayerPrice.routeName);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.network(
                  ipodata?.data['team1logo'] ?? '',
                  height: 60,
                  width: 60,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        (ipodata?.data['seriesname']),
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (ipodata?.data['team1display']),
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
                            (ipodata?.data['team2display']),
                            style: GoogleFonts.inter(
                                fontSize: 15,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //Design a container in which timer is going hh:mm:ss
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ipodata?.data['status'] == "notstarted"
                            ? CountdownTimer(
                                endTime: DateTime.parse(
                                        ipodata?.data?['start_date'] ?? '')
                                    .millisecondsSinceEpoch,
                                textStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                ipodata?.data['status'] == "completed"
                                    ? "Completed"
                                    : "Pending",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ],
                  ),
                ),
                Image.network(
                  ipodata?.data['team2logo'] ?? '',
                  height: 60,
                  width: 60,
                ),
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
