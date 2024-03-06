import 'package:flutter/material.dart';
import 'package:fanxange/pages/SignIn.dart';

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
      "image": "assets/images/onboarding_1.png",
      "title": "Proven specialist",
      "subtitle": "We check each specialist before he starts to work"
    },
    {
      "image": "assets/images/onboarding_2.png",
      "title": "Honest ratings",
      "subtitle": "We carefully check each specialist and put honest ratings"
    },
    {
      "image": "assets/images/onboarding_3.png",
      "title": "Insured orders",
      "subtitle": "We sure each order for the amount of \$500"
    },
    {
      "image": "assets/images/onboarding_4.png",
      "title": "Create order",
      "subtitle": "It's easy, just click on the plus"
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

  void goSignIn(context) {
    Navigator.pushNamed(context, SignIn.routeName);
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    double paddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
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
                      fontSize: 40,
                      height: 46.0 / 40.0,
                      color: Color(0xFF525464)),
                ),
              ),
              SizedBox(
                height: screen.height * 0.0837,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screen.width * 0.1813),
                child: Image(
                  image: AssetImage(data[index]['image']),
                  width: screen.width * 0.6346,
                  height: screen.height * 0.3510,
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
                        child: Container(
                          height: 82.0,
                          width: 82.0,
                          // radius: 90.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            color: const Color(0xFF20C3AF),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 40.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
