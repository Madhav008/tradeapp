// ignore_for_file: prefer_const_constructors

import 'package:fanxange/pages/Notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  // Mock data for balances
  final double totalBalance = 1000.00;
  final double utilizedBalance = 500.00;
  final double winningBalance = 300.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildBalanceContainer('Total Balance', totalBalance,
                    color: Colors.blueGrey),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAddButton(),
                SizedBox(
                  width: 10,
                ),
                _buildWithdrawButton(),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Transaction History:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        subtitle: Text('Balance $index'),
                        trailing: Text(
                          '+₹10.00',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.green),
                        ),
                        title: Text(
                          '2024-03-10',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceContainer(String title, double balance, {Color? color}) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '₹${balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.green),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.plus,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Add Funds',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawButton() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.blue),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.moneyBills,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Withdraw',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoneyDialog(BuildContext context, MoneyAction action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(action == MoneyAction.add ? 'Add Money' : 'Withdraw Money'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle add/withdraw money logic here
                  Navigator.of(context).pop();
                },
                child: Text(action == MoneyAction.add ? 'Add' : 'Withdraw'),
              ),
            ],
          ),
        );
      },
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
        )
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

enum MoneyAction { add, withdraw }
