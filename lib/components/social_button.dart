import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fanxange/appwrite/auth_api.dart';
import 'package:provider/provider.dart';

class SignInSocialButton extends StatelessWidget {
  final String iconPath;
  final String text;

  const SignInSocialButton(
      {Key? key, required this.iconPath, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    signInProvider() async {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite.signInWithProvider(provider: 'google');
    }

    return GestureDetector(
      onTap: () {
        signInProvider();
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          border: Border.all(
            width: 1.0,
            color: const Color(0xFF134140),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: SvgPicture.asset(iconPath),
            ),
            Expanded(
              flex: 2,
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 16.0,
                  color: const Color(0xFF134140),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
