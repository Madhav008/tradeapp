// ignore_for_file: file_names, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Changed the import statement
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fanxange/pages/Notification.dart';
import 'package:fanxange/pages/Search.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  bool isActions; // Removed the default value

  MyAppBar({
    Key? key,
    this.isActions = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: isActions
          ? [
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.magnifyingGlass, // Corrected the icon usage
                  color: Colors.grey[600],
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, SearchPage.routeName),
              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.bell,
                  color: Colors.grey[600],
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, NotificationPage.routeName),
              )
            ]
          : null,
      title: Row(
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
      centerTitle: true,
    );
  }
}
