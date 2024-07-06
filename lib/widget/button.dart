import 'package:flutter/material.dart';

class CustomAppButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback buttonTapped;
  final bool isScientificMode;

  const CustomAppButton({
    Key? key,
    required this.color,
    required this.textColor,
    required this.text,
    required this.buttonTapped,
    this.isScientificMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonSize = isScientificMode ? 16.0 : 20.0;

    return GestureDetector(
      onTap: buttonTapped,
      child: Container(
        margin: const EdgeInsets.all(4), // Adjusted margin to reduce space
        padding: EdgeInsets.all(isScientificMode ? 8 : 12), // Adjust padding for smaller buttons
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: buttonSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
