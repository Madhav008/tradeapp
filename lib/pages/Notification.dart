import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  static String routeName = "/notification";
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("1 day ago",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    )),
                Text("New",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text("Security Upadte!",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            Text(
                "this is the sample text message from the notification asdasd aswd asd d asd asd as da sd asd as da sd asd as da sd asd as",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blueGrey[900],
                  fontWeight: FontWeight.w300,
                )),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
