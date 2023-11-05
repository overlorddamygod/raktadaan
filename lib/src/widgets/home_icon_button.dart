import 'package:flutter/material.dart';

class RHomeIconButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Widget icon;
  final Color? color;

  const RHomeIconButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.icon,
      this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 80,
        width: 80,
        // padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color ?? Colors.red,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
