import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final double width;
  final double height;
  final double radius;
  final Widget child;
  final String text;

  const CustomButton(
      {super.key, required this.onTap,
      required this.width,
      required this.height,
      required this.radius,
      required this.child,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: width,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: const Color(0xFF20C3AF),
              borderRadius: BorderRadius.circular(radius)),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
