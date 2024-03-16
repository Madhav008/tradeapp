import 'package:fanxange/appwrite/auth_api.dart';
import 'package:fanxange/pages/HomePage.dart';
import 'package:fanxange/pages/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  static String routeName = "/signup";

  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool passwordVisible = true;
  bool confirmpasswordVisible = true;

  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    confirmpasswordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/logo.svg',
                    height: size.height / 8,
                    width: size.height / 8,
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Text.rich(
                    TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        color: const Color(0xFF21899C),
                        letterSpacing: 3,
                        height: 1.03,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Fan',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: 'Xange ',
                          style: TextStyle(
                            color: Color(0xFFFE9879),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  nameTextField(size),
                  if (nameError != null)
                    Text(
                      nameError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  emailTextField(size),
                  if (emailError != null)
                    Text(
                      emailError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  passwordTextField(size),
                  if (passwordError != null)
                    Text(
                      passwordError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  confirmPasswordTextField(size),
                  if (confirmPasswordError != null)
                    Text(
                      confirmPasswordError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  InkWell(
                    onTap: createAccount,
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
                        'Sign Up',
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
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Divider()),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        'Or Sign in with',
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          color: const Color(0xFF969AA8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  footerText(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget nameTextField(Size size) {
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
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        controller: nameController,
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
          labelText: 'Full Name ',
          labelStyle: GoogleFonts.inter(
            fontSize: 12.0,
            color: const Color(0xFF969AA8),
          ),
          border: InputBorder.none,
        ),
        onChanged: (_) {
          setState(() {
            nameError = null;
          });
        },
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
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        controller: emailController,
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
          labelText: 'Email/ Phone number',
          labelStyle: GoogleFonts.inter(
            fontSize: 12.0,
            color: const Color(0xFF969AA8),
          ),
          border: InputBorder.none,
        ),
        onChanged: (_) {
          setState(() {
            emailError = null;
          });
        },
      ),
    );
  }

  Widget passwordTextField(Size size) {
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
        obscureText: passwordVisible,
        controller: passwordController,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        maxLines: 1,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          ),
          labelText: 'Password',
          labelStyle: GoogleFonts.inter(
            fontSize: 12.0,
            color: const Color(0xFF969AA8),
          ),
          border: InputBorder.none,
        ),
        onChanged: (_) {
          setState(() {
            passwordError = null;
          });
        },
      ),
    );
  }

  Widget confirmPasswordTextField(Size size) {
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
        obscureText: confirmpasswordVisible,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        maxLines: 1,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              confirmpasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                confirmpasswordVisible = !confirmpasswordVisible;
              });
            },
          ),
          labelText: 'Confirm Password',
          labelStyle: GoogleFonts.inter(
            fontSize: 12.0,
            color: const Color(0xFF969AA8),
          ),
          border: InputBorder.none,
        ),
        onChanged: (_) {
          setState(() {
            confirmPasswordError = null;
          });
        },
      ),
    );
  }

  showAlert({required String title, required String text}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  createAccount() async {
    // Validate name
    final String name = nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        nameError = 'Please enter your name.';
      });
      return;
    }

    // Validate email format
    final String email = emailController.text.trim();
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        emailError = 'Please enter a valid email address.';
      });
      return;
    }

    // Validate password strength
    final String password = passwordController.text;
    final RegExp passwordRegex =
        RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>])(?=.*[a-zA-Z])(?=.*\d).{6,}$');
    if (!passwordRegex.hasMatch(password)) {
      setState(() {
        passwordError =
            'Password must be at least 6 characters long and contain at least one special character.';
      });
      return;
    }

    // Validate password and confirm password match
    final String confirmPassword = confirmPasswordController.text;
    if (password != confirmPassword) {
      setState(() {
        confirmPasswordError = 'Passwords do not match.';
      });
      return;
    }

    // Perform account creation if all validations pass
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite
          .createUser(
        email: email,
        password: password,
        name: name,
      )
          .then((_) {
        print("Before navigation");
        Navigator.popAndPushNamed(context, MyHomePage.routeName);
        print("After navigation");
      });
      // Navigator.pop(context); // Close the dialog
      // const snackbar = SnackBar(content: Text('Account created!'));
      // ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } on Exception catch (e) {
      Navigator.pop(context);
      showAlert(
        title: 'Account creation failed',
        text: e.toString(),
      );
    }
  }

  Widget footerText(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.popAndPushNamed(context, SignIn.routeName);
      },
      child: Text.rich(
        TextSpan(
          style: GoogleFonts.inter(
            fontSize: 12.0,
            color: const Color(0xFF3B4C68),
          ),
          children: const [
            TextSpan(
              text: 'Already have an account ?',
            ),
            TextSpan(
              text: ' ',
              style: TextStyle(
                color: Color(0xFF21899C),
              ),
            ),
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: Color(0xFF21899C),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
