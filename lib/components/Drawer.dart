import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFFE9879),
            ),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFFE9879),
              ),
              accountName: Text(
                "Madhav Jindal",
                style: TextStyle(fontSize: 15),
              ),
              accountEmail: Text("madhavj211@gmail.com"),
              currentAccountPictureSize: Size.square(45),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 243, 218, 210),
                child: Text(
                  "M",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Color(0xFF21899C),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(' My Profile '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.peopleRoof),
            title: const Text(' Add Clients '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text(' Go Premium '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_label),
            title: const Text(' Saved Videos '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text(' Edit Profile '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
