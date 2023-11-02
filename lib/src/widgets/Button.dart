import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Button extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onPressed;
  const Button({super.key, required this.buttonTitle, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(
              vertical: 16.0,
            ), // Adjust the vertical padding as needed
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class MediumButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  const MediumButton({
    super.key,
    required this.buttonTitle,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // width: double.infinity,
      // margin: const EdgeInsets.symmetric(
      //   vertical: 10.0,
      // ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: backgroundColor != null
              ? MaterialStateProperty.all<Color>(backgroundColor!)
              : MaterialStateProperty.all<Color>(Get.theme.colorScheme.primary),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(
              vertical: 16.0,
            ), // Adjust the vertical padding as needed
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
