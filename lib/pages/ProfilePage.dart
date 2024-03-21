import 'package:fanxange/appwrite/auth_api.dart';
import 'package:fanxange/components/ProfileMenuWidget.dart';
import 'package:fanxange/components/UpdateProfile.dart';
import 'package:fanxange/pages/Notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authApi = context.watch<AuthAPI>();
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                        image: AssetImage('assets/images/avtar1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xFF21899C),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.pencil,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(authApi.username.toString(),
                  style: Theme.of(context).textTheme.headline4),

              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => UpdateProfileScreen())),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF21899C),
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text('Edit Profile',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                  title: "Settings",
                  icon: FontAwesomeIcons.cog,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Billing Details",
                  icon: FontAwesomeIcons.wallet,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "User Management",
                  icon: FontAwesomeIcons.userCheck,
                  onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "Information",
                  icon: FontAwesomeIcons.info,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: FontAwesomeIcons.signOutAlt,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("LOGOUT"),
                          content:
                              const Text("Are you sure, you want to Logout?"),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                authApi.logout();
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 231, 194, 182),
                              ),
                              child: const Text(
                                "Yes",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("No"),
                            ),
                          ],
                        );
                      },
                    );
                  }),
            ],
          ),
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
    );
  }
}
