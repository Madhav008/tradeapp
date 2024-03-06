// ignore_for_file: file_names, ignore_for_file: file_names, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/components/Drawer.dart';
import 'package:fanxange/components/IpoListWidget.dart';
import 'package:fanxange/components/MyAppBar.dart';
import 'package:fanxange/pages/redundant/IpoDetail.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  static String routeName = "/home";

  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myText("TOTAL BALANCE", Color.fromARGB(255, 90, 119, 125), 15.0,
                FontWeight.bold),
            SizedBox(
              height: 5,
            ),
            Text(
              "₹24,456.00",
              style: GoogleFonts.inter(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Most Bought IPO",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      child: Text("Indian OIL"),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      child: Text("Indian OIL"),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      databaseAPI.setFilter(true);
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "SME",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      databaseAPI.setFilter(false);
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "Mainboard",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "Recent IPO",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500),
            ),
            IPOListWidget()
          ],
        ),
      ),
    );
  }

  Text myText(text, color, size, weight) {
    return Text(
      text,
      style:
          GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color),
    );
  }
}
