import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/pages/IpoDetail.dart';
import 'package:provider/provider.dart';

class IPOListTile extends StatelessWidget {
  const IPOListTile({
    super.key,
    required this.ipodata,
  });

  final Map<String, dynamic>? ipodata;

  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();

    String shortName = truncateName(
        ipodata?['name'] ?? '', 15); // Adjust the maxLength as needed

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          databaseAPI.setIpoData(ipodata);
          Navigator.pushNamed(context, IPODetailPage.routeName);
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  ipodata?['icon_url'] ?? '',
                  height: 40,
                  width: 40,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shortName, // Access the name property
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      (ipodata?['type'] == "EQ" ? "MAINBOARD" : "SME"),
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    width: 10,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹${ipodata?['premium']}", // Access the max_price property
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Text(
                    //   "${ipodata?['premium_percentage'].toStringAsFixed(2)}%", // Access the premium_percentage property
                    //   style: GoogleFonts.inter(
                    //     fontSize: 15,
                    //     color: Colors.red,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
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
