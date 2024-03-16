import 'package:fanxange/pages/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fanxange/appwrite/auth_api.dart';

class ChangePassPage extends StatefulWidget {
  static String routeName = '/changepass';

  const ChangePassPage({Key? key}) : super(key: key);

  @override
  State<ChangePassPage> createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
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
              'Enter your New Password',
              style: GoogleFonts.inter(
                fontSize: 16.0,
                color: const Color(0xFF15224F),
              ),
            ),
            SizedBox(height: 20),
            passwordTextField(size, 'Password'),
            SizedBox(height: 20),
            confirmPasswordTextField(size, 'Confirm Password'),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Check if both passwords match
                if (passwordController.text != confirmPasswordController.text) {
                  Fluttertoast.showToast(
                    msg: "Passwords do not match",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return; // Exit the function if passwords don't match
                }

                String password = passwordController.text;

                // Check if the password is empty
                if (password.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Password is required",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return; // Exit the function if password is empty
                }

                // Proceed with password change process
                context.read<AuthAPI>().changePassword(password);
                Navigator.pushNamed(context, SignIn.routeName);
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
                  'Change Password',
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
    );
  }

  Widget passwordTextField(Size size, String labelText) {
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
        controller: passwordController,
        obscureText: true,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.inter(
            fontSize: 12.0,
            color: const Color(0xFF969AA8),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget confirmPasswordTextField(Size size, String labelText) {
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
        controller: confirmPasswordController,
        obscureText: true,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
          labelText: labelText,
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
