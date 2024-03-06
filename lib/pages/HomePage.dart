// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fanxange/pages/Dashboard.dart';
import 'package:fanxange/pages/IPOListPage.dart';
import 'package:fanxange/pages/Orders.dart'; // Import the correct Dashboard page

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    IPOListPage(),
    OrdersPage(),
    Dashboard(),
    Dashboard(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color(0xFF21899C),
        elevation: 15.0,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.arrowTrendUp),
            label: 'IPO',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.book),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.suitcase),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFFE9879),
        onTap: _onItemTapped,
      ),
      body: Container(
        color: Color(0xFFEEEEEE),
        child: Column(
          children: <Widget>[
            Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
          ],
        ),
      ),
    );
  }
}
