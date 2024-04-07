import 'package:fanxange/appwrite/performance_provider.dart';
import 'package:fanxange/appwrite/wallet_provider.dart';
import 'package:fanxange/components/qr_code.dart';
import 'package:fanxange/pages/ChangePassPage.dart';
import 'package:fanxange/pages/ForgetPage.dart';
import 'package:fanxange/pages/PaymentPage.dart';
import 'package:fanxange/pages/PlayerOrdersPage.dart';
import 'package:fanxange/pages/PlayersPricePage.dart';
import 'package:fanxange/pages/ScorecardPage.dart';
import 'package:fanxange/pages/SplashScreen.dart';
import 'package:fanxange/pages/Verification.dart';
import 'package:fanxange/pages/WalletPage.dart';
import 'package:flutter/material.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/pages/HomePage.dart';
import 'package:fanxange/pages/Notification.dart';
import 'package:fanxange/pages/SignIn.dart';
import 'package:fanxange/pages/SignUp.dart';
import 'package:fanxange/pages/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appwrite/auth_api.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: ((context) => AuthAPI()),
      ),
      ChangeNotifierProvider(
        create: ((context) => DatabaseAPI()),
      ),
      ChangeNotifierProvider(
        create: ((context) => WalletProvider()),
      ),
      ChangeNotifierProvider(
        create: ((context) => PerformanceProvider()),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Future<String?> _getPref() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('firstTime');
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        Onboarding.routeName: (context) => const Onboarding(),
        SignIn.routeName: (context) => const SignIn(),
        ForgetPasswordPage.routeName: (context) => const ForgetPasswordPage(),
        VerificationScreen.routeName: (context) => VerificationScreen(),
        ChangePassPage.routeName: (context) => const ChangePassPage(),
        SignUp.routeName: (context) => const SignUp(),
        NotificationPage.routeName: (context) => const NotificationPage(),
        PlayerPrice.routeName: (context) => const PlayerPrice(),
        PlayersOrdersPage.routeName: (context) => const PlayersOrdersPage(),
        WalletPage.routeName: (context) => WalletPage(),
        Scorecard.routeName: (context) => const Scorecard(),
        MyHomePage.routeName: (context) => MyHomePage(),
        PaymentPage.routeName: (context) => PaymentPage(),
        QRViewer.routeName: (context) => QRViewer()
      },
      builder: (context, child) {
        // Applying MediaQuery modification here affects all routes
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      home: FutureBuilder<String?>(
        future: _getPref(),
        builder: (context, snapshot) {
          final authStatus = context.watch<AuthAPI>().status;
          if (snapshot.connectionState == ConnectionState.waiting ||
              authStatus == AuthStatus.uninitialized) {
            return const SplashScreen(); // Show SplashScreen while waiting for SharedPreferences
          } else {
            if (authStatus == AuthStatus.authenticated) {
              return MyHomePage(); // Show HomePage if authenticated
            } else {
              return const SignIn(); // Show SignIn page if unauthenticated
            }
          }
        },
      ),
    );
  }
}
