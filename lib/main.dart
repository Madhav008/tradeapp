import 'package:fanxange/appwrite/wallet_provider.dart';
import 'package:fanxange/pages/PlayerOrdersPage.dart';
import 'package:fanxange/pages/PlayersPricePage.dart';
import 'package:fanxange/pages/WalletPage.dart';
import 'package:flutter/material.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/pages/HomePage.dart';
import 'package:fanxange/pages/Notification.dart';
import 'package:fanxange/pages/SignIn.dart';
import 'package:fanxange/pages/SignUp.dart';
import 'package:fanxange/pages/onboarding.dart';
import 'package:provider/provider.dart';
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
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<AuthAPI>();
    final status = value.status;
    final userid = AuthAPI.currentUser?.user.id;

    context.read<WalletProvider>().getWallet(userid);
    context.read<DatabaseAPI>().getUserOrder(userid);
    // context.read<DatabaseAPI>().seprateMatchList();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // primarySwatch: Colors.blue,
          // visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
      routes: {
        Onboarding.routeName: (context) => const Onboarding(),
        SignIn.routeName: (context) => const SignIn(),
        SignUp.routeName: (context) => const SignUp(),
        NotificationPage.routeName: (context) => const NotificationPage(),
        PlayerPrice.routeName: (context) => const PlayerPrice(),
        PlayersOrdersPage.routeName: (context) => const PlayersOrdersPage(),
        WalletPage.routeName: (context) => WalletPage(),
      },
      home: status == AuthStatus.uninitialized
          ? Scaffold(body: Center(child: CircularProgressIndicator()))
          : status == AuthStatus.authenticated
              ? MyHomePage()
              : const SignIn(),
    );
  }
}
