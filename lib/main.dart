import 'package:flutter/material.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/pages/Dashboard.dart';
import 'package:fanxange/pages/ExcutionPage.dart';
import 'package:fanxange/pages/HomePage.dart';
import 'package:fanxange/pages/redundant/IpoDetail.dart';
import 'package:fanxange/pages/Notification.dart';
import 'package:fanxange/pages/redundant/Orders.dart';
import 'package:fanxange/pages/Search.dart';
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
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<AuthAPI>().status;
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
        Dashboard.routeName: (context) => const Dashboard(),
        NotificationPage.routeName: (context) => const NotificationPage(),
        SearchPage.routeName: (context) => const SearchPage(),
        OrdersPage.routeName: (context) => const OrdersPage(),
        IPODetailPage.routeName: (context) => IPODetailPage(),
        ExecutionPage.routeName: (context) => ExecutionPage(),
      },
      home: value == AuthStatus.authenticated ? MyHomePage() : const SignIn(),
    );
  }
}
