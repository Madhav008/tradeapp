// ignore_for_file: prefer_const_constructors

import 'package:fanxange/appwrite/auth_api.dart';
import 'package:fanxange/appwrite/wallet_provider.dart';
import 'package:fanxange/pages/Notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';

class WalletPage extends StatefulWidget {
  static String routeName = "/wallet";

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    context.read<WalletProvider>().getWallet(context.read<AuthAPI>().userid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Mock data for balances
    final walletApi = context.watch<WalletProvider>();

    final double totalBalance = walletApi.balance;

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
                    color: Color.fromARGB(207, 254, 152, 121)),
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
              child: Skeletonizer(
                enabled: walletApi.isTransactionLoading,
                child: ListView.builder(
                  itemCount: walletApi.transactions.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var walletdata =
                        walletApi.transactions.reversed.elementAt(index);
                    DateTime dateTime = DateTime.parse(walletdata.date);
                    String formattedDate =
                        DateFormat('dd MMM,yyyy hh:mm').format(dateTime);

                    return Column(
                      children: [
                        ListTile(
                          subtitle: Text('Id: ${walletdata.transactionId}'),
                          trailing: RichText(
                            text: TextSpan(
                              text: walletdata.type == 'debit' ? '- ₹' : '+ ₹',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: walletdata.type == 'debit'
                                    ? Colors
                                        .blue // Set the color for debit transactions
                                    : Colors
                                        .green, // Set the color for other transactions
                              ),
                              children: [
                                TextSpan(
                                  text: '${walletdata.amount}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: walletdata.type == 'debit'
                                        ? Colors
                                            .blue // Set the color for debit transactions
                                        : Colors
                                            .green, // Set the color for other transactions
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            '${formattedDate}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
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
        margin: EdgeInsets.only(top: 8, bottom: 8),
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
      child: GestureDetector(
        onTap: () {
          _showMoneyDialog(context, MoneyAction.add);
        },
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
      ),
    );
  }

  Widget _buildWithdrawButton() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _showMoneyDialog(context, MoneyAction.withdraw);
        },
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
      ),
    );
  }

  void _showMoneyDialog(BuildContext context, MoneyAction action) {
    TextEditingController amountController = new TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            final walletApi = context.watch<WalletProvider>();
            final isLoading = walletApi.walletLoading;
            if (isLoading) {
              return const Dialog(
                backgroundColor: Colors.transparent,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircularProgressIndicator(),
                    ]),
              );
            }
            return AlertDialog(
              title: Text(
                  action == MoneyAction.add ? 'Add Money' : 'Withdraw Money'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context)
                          .pop(); // Close the dialog before showing loading

                      // _loading(context); // Show loading indicator

                      try {
                        if (action == MoneyAction.add) {
                          await context
                              .read<WalletProvider>()
                              .addMoney(double.parse(amountController.text));
                        } else {
                          await context.read<WalletProvider>().withdrawMoney(
                              double.parse(amountController.text));
                        }
                        // Handle add/withdraw money logic here
                      } catch (e) {
                        print('Error: $e');
                      } finally {
                        Navigator.of(context)
                            .pop(); // Close the loading indicator
                      }
                    },
                    child: Text(action == MoneyAction.add ? 'Add' : 'Withdraw'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // void _loading(BuildContext ctx) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return const Dialog(
  //           backgroundColor: Colors.transparent,
  //           child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 CircularProgressIndicator(),
  //               ]),
  //         );
  //       });
  // }

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
        IconButton(
          icon: Icon(
            FontAwesomeIcons.signOut,
            color: Colors.grey[600],
          ),
          onPressed: () => context.read<AuthAPI>().logout(),
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

enum MoneyAction { add, withdraw }
