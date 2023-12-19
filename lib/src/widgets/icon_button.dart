import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RIconButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback? onPressed;
  final Color color;

  const RIconButton(
      {super.key,
      required this.text,
      required this.icon,
      required this.color,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          border: Border.all(color: color, width: 1.0),
          color: color,
        ),
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 8.0),
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

Widget callButton(String number, text) {
  return RIconButton(
    onPressed: () async {
      final url = 'tel:${number}';
      print(url);
      try {
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          print("ERROR");
          // Handle the case where the user's device doesn't support phone calls.
          // You can display an error message or take appropriate action.
        }
      } catch (err) {
        print(err);
      }
    },
    icon: const Icon(
      Icons.call,
      color: Colors.white,
    ),
    color: Colors.green,
    text: text,
  );
}
