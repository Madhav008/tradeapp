import 'package:appwrite/models.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PlayerListTile extends StatelessWidget {
  const PlayerListTile({
    Key? key,
    required this.playersdata,
  }) : super(key: key);

  final Document? playersdata;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                  playersdata?.data['image'] ?? '',
                  height: 60,
                  width: 60,
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playersdata?.data['name'] ?? '',
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        softWrap: true,
                      ),
                      Text(
                        playersdata?.data['role'] ?? '',
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Container(
                        width: 70,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Color(0xFFFE9879),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            playersdata?.data['teamname'] ?? '',
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Bought 0",
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFE9879),
                  fontSize: 14,
                ),
              ),
              Text(
                "Sold 0",
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF21899C),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                      254, 152, 121, 0.8), // Adjusted opacity for Buy button
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "Buy: ₹${playersdata?.data['buy_rate'].toString() ?? ''}",
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors
                      .transparent, // Transparent background for Sell button
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: const Color(
                          0xFF21899C)), // Optional border for visibility
                ),
                child: Text(
                  "Sell: ₹${playersdata?.data['sell_rate'].toString() ?? ''}",
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF21899C),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
