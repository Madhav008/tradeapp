import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.elasticIn,
            child: Container(
              height: height / 2,
              width: width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/cricket.gif",
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),
          // Adding Text with a sporty font using Google Fonts

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
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF21899C),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Trade, Play, Win: Elevate Your Fantasy Cricket Experience',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          //Trade, Play, Win: Elevate Your Fantasy Cricket Experience
          // Adding CircularProgressIndicator with custom color
        ],
      ),
    );
  }
}
