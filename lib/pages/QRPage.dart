// ignore_for_file: prefer_const_constructors

import 'package:fanxange/components/qr_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fanxange/appwrite/wallet_provider.dart';

class QRPage extends StatefulWidget {
  static String routeName = "/qrcode";

  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  @override
  Widget build(BuildContext context) {
    final walletApi = context.watch<WalletProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QR CODE",
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
                    QRViewer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
