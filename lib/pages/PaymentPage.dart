// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fanxange/components/CustomExpansionTile.dart';
import 'package:fanxange/pages/PaymentPage.dart';
import 'package:flutter/material.dart';
import 'package:fanxange/appwrite/auth_api.dart';
import 'package:fanxange/appwrite/wallet_provider.dart';
import 'package:fanxange/pages/Notification.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  static String routeName = "/payment";

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    context.read<WalletProvider>().getWallet(context.read<AuthAPI>().userid);
    super.initState();
  }

  TextEditingController amountController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Mock data for balances
    final walletApi = context.watch<WalletProvider>();

    final double totalBalance = walletApi.balance;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Funds",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Enter your amount ',
              style: GoogleFonts.inter(
                fontSize: 16.0,
                color: const Color(0xFF15224F),
              ),
            ),
            SizedBox(height: 20),
            amountTextField(size),
            SizedBox(height: 20),
            GestureDetector(
                onTap: () async {
                  String amount = amountController.text;

                  // Check if the amount is empty
                  if (amount.isEmpty) {
                    // Show Flutter toast indicating amount is required
                    Fluttertoast.showToast(
                      msg: "Amount is required",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                    return; // Exit the function early if amount is empty
                  }

                  final walletApi = context.read<WalletProvider>();

                  // Show loading dialog if payment is loading

                  await walletApi.initPayment(double.parse(amount));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: size.height / 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: const Color(0xFF21899C),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4C2E84).withOpacity(0.2),
                        offset: const Offset(0, 15.0),
                        blurRadius: 60.0,
                      ),
                    ],
                  ),
                  child: Text(
                    'Add Funds',
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget amountTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 15,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: const Color(0xFFEFEFEF),
        ),
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: amountController,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'Enter amount',
            labelStyle: GoogleFonts.inter(
              fontSize: 12.0,
              color: const Color(0xFF969AA8),
            ),
            border: InputBorder.none),
      ),
    );
  }
}
