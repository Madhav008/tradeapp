// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_final_fields

import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/appwrite/wallet_provider.dart';
import 'package:fanxange/pages/PortfolioPage.dart';
import 'package:fanxange/pages/WalletPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fanxange/pages/MatchListPage.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    MatchListPage(),
    PortfolioPage(),
    WalletPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex == 0) {
        context.read<DatabaseAPI>().setIsPortfolio(true);
        context.read<DatabaseAPI>().getUserOrder();
      }

      if (_selectedIndex == 1) {
        context.read<DatabaseAPI>().setIsPortfolio(false);
      }
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
            icon: Icon(FontAwesomeIcons.suitcase),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.wallet),
            label: 'Wallet',
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
