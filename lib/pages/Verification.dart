import 'dart:async';
import 'package:fanxange/appwrite/auth_api.dart';
import 'package:fanxange/pages/ChangePassPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  static String routeName = '/verification';
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late List<TextStyle?> otpTextStyles;
  late List<TextEditingController?> controls;
  int numberOfFields = 4;
  bool clearText = false;
  Timer? _timer;
  int _start = 300; // 5 minutes in seconds

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _onResendOTP() {
    final authapi = context.read<AuthAPI>();
    final email = authapi.forgetEmail;
    print(email);
    authapi.forgetPass(email);
    _start = 300; // Reset the timer to 10 seconds (adjust as needed)
    startTimer(); // Restart the timer
    setState(() {
      clearText = false; // Reset the clearText flag to false
    });
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _timer?.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final authapi = context.watch<AuthAPI>();

    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verification Code',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(flex: 2),
            Center(
              child: Text(
                "We texted you a code Please enter it below",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyText1,
              ),
            ),
            Spacer(flex: 1),
            OtpTextField(
              numberOfFields: numberOfFields,
              borderColor: Color(0xFF512DA8),

              clearText: clearText,
              showFieldAsBox: true,
              textStyle: theme.textTheme.titleMedium,
              onCodeChanged: (String value) {
                //Handle each value
              },
              handleControllers: (controllers) {
                //get all textFields controller, if needed
                controls = controllers;
              },
              onSubmit: (String verificationCode) {
                //set clear text to clear text from all fields
                setState(() {
                  clearText = true;
                });
                //navigate to different screen code goes here
                context.read<AuthAPI>().verify(verificationCode).then((_) {
                  if (context.read<AuthAPI>().isVerified!) {
                    Navigator.popAndPushNamed(
                        context, ChangePassPage.routeName);
                  } else {
                    // Handle if verification is not successful
                  }
                });
              }, // end onSubmit
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't get the code?",
                  style: theme.textTheme.subtitle1,
                ),
                SizedBox(
                  width: 10,
                ),
                _start == 0
                    ? TextButton(
                        onPressed: _onResendOTP, // Call _onResendOTP function
                        child: Text("Resend OTP"),
                      )
                    : Text(
                        "Resend in $timerText",
                        style: TextStyle(color: Colors.grey),
                      ),
              ],
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
