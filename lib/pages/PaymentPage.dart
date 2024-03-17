// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fanxange/appwrite/wallet_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PaymentPage extends StatefulWidget {
  static String routeName = "/payment";

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final walletApi = context.watch<WalletProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Funds",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
      ),
      body: AbsorbPointer(
        absorbing: walletApi
            .isPaymentLoading, // Disable background interaction if button is disabled or loading
        child: Stack(
          children: [
            Padding(
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
                    onTap: walletApi.isPaymentLoading
                        ? null
                        : _handleAddFunds, // Disable button when disabled
                    child: Container(
                      alignment: Alignment.center,
                      height: size.height / 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: walletApi.isPaymentLoading
                            ? Colors.grey
                            : const Color(0xFF21899C),
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
                    ),
                  ),
                ],
              ),
            ),
            if (walletApi
                .isPaymentLoading) // Show circular progress indicator if loading
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  void _handleAddFunds() async {
    final walletApi = context.read<WalletProvider>();
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

    // Convert amount to double
    double parsedAmount = double.tryParse(amount) ?? 0;

    // Check if amount is greater than 5000
    if (parsedAmount > 5000) {
      // Show Flutter toast indicating amount exceeds limit
      Fluttertoast.showToast(
        msg: "Amount should not exceed ₹5,000",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return; // Exit the function if amount exceeds limit
    }

    // Initiate payment
    await walletApi.initPayment(parsedAmount, context);
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
          border: InputBorder.none,
        ),
      ),
    );
  }
}
