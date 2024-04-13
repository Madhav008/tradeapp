// ignore_for_file: prefer_const_constructors

import 'package:fanxange/components/qr_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fanxange/appwrite/wallet_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';

class PaymentPage extends StatefulWidget {
  static String routeName = "/payment";

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController upiController = TextEditingController();
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/images/PayTut.mp4', // Replace with your video asset or network path
    )..initialize().then((_) {
        setState(() {});
        _controller?.setLooping(true); // Enable looping
        _controller?.setPlaybackSpeed(1.3); // Set playback speed to 1.5x
        _controller?.play();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter your amount ',
                      style: GoogleFonts.inter(
                        fontSize: 16.0,
                        color: const Color(0xFF15224F),
                      ),
                    ),
                    amountTextField(size),
                    SizedBox(height: 20),
                    Text(
                      'Enter your UPI Id  ',
                      style: GoogleFonts.inter(
                        fontSize: 16.0,
                        color: const Color(0xFF15224F),
                      ),
                    ),
                    upiTextField(size),
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
                    /* SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 0.1626),
                      child: Text(
                        "HOW TO ADD FUND",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          height: 22.0 / 16.0,
                          letterSpacing: 0.33,
                          color: Color(0xFF838391),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_controller?.value.isInitialized ??
                        false) // Check if the controller is initialized
                      FittedBox(
                        fit: BoxFit
                            .contain, // This will cover the entire space of the container, potentially cropping the video
                        child: SizedBox(
                          width: _controller!.value.size.width,
                          height: _controller!.value.size.height,
                          child: VideoPlayer(
                              _controller!), // Your VideoPlayer widget without the 'fit' parameter
                        ),
                      ), */
                  ],
                ),
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
    // await walletApi.addMoney(parsedAmount, upiController.text);
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

  Widget upiTextField(Size size) {
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
        controller: upiController,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
          labelText: 'Enter UPI ',
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
