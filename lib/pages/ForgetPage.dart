// ignore_for_file: prefer_const_constructors

import 'package:fanxange/pages/Verification.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordPage extends StatefulWidget {
  static String routeName = '/forgetPass';

  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forget Password",
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
              'Enter your email address to reset your password',
              style: GoogleFonts.inter(
                fontSize: 16.0,
                color: const Color(0xFF15224F),
              ),
            ),
            SizedBox(height: 20),
            emailTextField(size),
            SizedBox(height: 20),
            GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, VerificationScreen.routeName),
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
                    'Reset Password',
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

  Widget emailTextField(Size size) {
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
        controller: emailController,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'Enter Email',
            labelStyle: GoogleFonts.inter(
              fontSize: 12.0,
              color: const Color(0xFF969AA8),
            ),
            border: InputBorder.none),
      ),
    );
  }
}
