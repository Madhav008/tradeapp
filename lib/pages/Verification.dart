// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

const Color primaryColor = Color(0xFF121212);
const Color accentPurpleColor = Color(0xFF6A53A1);
const Color accentPinkColor = Color(0xFFF99BBD);
const Color accentDarkGreenColor = Color(0xFF21899C);
const Color accentYellowColor = Color(0xFFFFB612);
const Color accentOrangeColor = Color(0xFFEA7A3B);

class VerificationScreen extends StatefulWidget {
  static String routeName = '/verification';
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late List<TextStyle?> otpTextStyles;
  late List<TextEditingController?> controls;
  int numberOfFields = 5;
  bool clearText = false;

  @override
  Widget build(BuildContext context) {
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
              focusedBorderColor: primaryColor,
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
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Verification Code"),
                      content: Text('Code entered is $verificationCode'),
                    );
                  },
                );
              }, // end onSubmit
            ),
            Spacer(),
            Center(
              child: Text(
                "Didn't get code?",
                style: theme.textTheme.subtitle1,
              ),
            ),
            Spacer(flex: 3),
            CustomButton(
              onPressed: () {},
              title: "Confirm",
              color: accentDarkGreenColor,
              textStyle: theme.textTheme.subtitle1?.copyWith(
                color: Colors.white,
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  CustomButton({
    required this.title,
    this.onPressed,
    this.height = 60,
    this.elevation = 1,
    this.color = primaryColor,
    this.textStyle,
  });

  final VoidCallback? onPressed;
  final double height;
  final double elevation;
  final String title;
  final Color color;

  // final BorderSide borderSide;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          topLeft: const Radius.circular(30.0),
          bottomLeft: const Radius.circular(30.0),
        ),
      ),
      height: height,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: textStyle,
          )
        ],
      ),
    );
  }
}
