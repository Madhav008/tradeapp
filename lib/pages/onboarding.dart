import 'package:flutter/material.dart';
import 'package:fanxange/pages/SignIn.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  static String routeName = "/onboarding";

  const Onboarding({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int index = 0;
  List data = [
    {
      "image": "assets/svg/Cricket-bro.svg",
      "title": "Your Expertise Matters",
      "subtitle": "Leverage your knowledge and experience to excel in Cricket."
    },
    {
      "image": "assets/svg/Highfive-amico.svg",
      "title": "Stay Informed",
      "subtitle": "Access real-time market data to stay ahead of the game."
    },
    {
      "image": "assets/svg/Money income-bro.svg",
      "title": "Secure Transactions",
      "subtitle":
          "Trade with confidence - your transactions are securely encrypted."
    },
    {
      "image": "assets/svg/Fans-cuate.svg",
      "title": "Start Trading",
      "subtitle": "Begin your trading journey with just a few clicks."
    }
  ];

  void nextPage() {
    setState(() {
      if (index + 1 < 4) {
        setState(() {
          index += 1;
        });
      }
    });
  }

  _firstTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("firstTime", "true");
  }

  void goSignIn(context) {
    Navigator.pushReplacementNamed(context, SignIn.routeName);
  }

  @override
  void initState() {
    _firstTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    double paddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: screen.width,
          height: screen.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screen.height * 0.074 - paddingTop,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screen.width * 0.1333),
                padding:
                    EdgeInsets.symmetric(horizontal: screen.width * 0.0933),
                child: Text(
                  data[index]['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      height: 46.0 / 40.0,
                      color: Color(0xFF525464)),
                ),
              ),
              Spacer(),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screen.width * 0.1813),
                child: SvgPicture.asset(
                  data[index]['image'],
                  height: screen.height * 0.3510,
                  width: screen.width * 0.6346,
                ),
              ),
              SizedBox(
                height: screen.height * 0.0820,
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: screen.width * 0.1626),
                child: Text(
                  data[index]['subtitle'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    height: 22.0 / 16.0,
                    letterSpacing: 0.33,
                    color: Color(0xFF838391),
                  ),
                ),
              ),
              SizedBox(
                height: screen.height * 0.0579,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 8.0,
                    width: (index == 0) ? 17.0 : 8.0,
                    decoration: BoxDecoration(
                        color: (index == 0)
                            ? const Color(0xFFB5C3C7)
                            : const Color(0xFFCBD3D5),
                        borderRadius: BorderRadius.circular(90.0)),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    height: 8.0,
                    width: (index == 1) ? 17.0 : 8.0,
                    decoration: BoxDecoration(
                        color: (index == 1)
                            ? const Color(0xFFB5C3C7)
                            : const Color(0xFFCBD3D5),
                        borderRadius: BorderRadius.circular(90.0)),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    height: 8.0,
                    width: (index == 2) ? 17.0 : 8.0,
                    decoration: BoxDecoration(
                        color: (index == 2)
                            ? const Color(0xFFB5C3C7)
                            : const Color(0xFFCBD3D5),
                        borderRadius: BorderRadius.circular(90.0)),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    height: 8.0,
                    width: (index == 3) ? 17.0 : 8.0,
                    decoration: BoxDecoration(
                        color: (index == 3)
                            ? const Color(0xFFB5C3C7)
                            : const Color(0xFFCBD3D5),
                        borderRadius: BorderRadius.circular(90.0)),
                  ),
                ],
              ),
              SizedBox(
                height: screen.height * 0.0381,
              ),
              (index != 3)
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: screen.width * 0.08),
                      child: GestureDetector(
                        onTap: nextPage,
                        child: SizedBox(
                          width: double.infinity,
                          child: Container(
                            height: 60.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: const Color(0xFF20C3AF),
                                borderRadius: BorderRadius.circular(8)),
                            child: const Center(
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  height: 19.0 / 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // child: CustomButton(
                      //   onTap: nextPage,
                      // ),
                    )
                  : Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: screen.width * 0.08),
                      child: GestureDetector(
                        onTap: () => goSignIn(context),
                        child: SizedBox(
                          width: double.infinity,
                          child: Container(
                            height: 60.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: const Color(0xFF20C3AF),
                                borderRadius: BorderRadius.circular(8)),
                            child: const Center(
                              child: Text(
                                'Get Started',
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  height: 19.0 / 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // child: CustomButton(
                      //   onTap: nextPage,
                      // ),
                    ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
