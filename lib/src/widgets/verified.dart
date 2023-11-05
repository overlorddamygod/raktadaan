import 'package:flutter/material.dart';

class Verified extends StatelessWidget {
  final bool verified;
  const Verified({super.key, required this.verified});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.verified_user,
          color: verified ? Colors.green : Colors.red,
          size: 15,
        ),
        Text(
          verified ? 'Verified' : 'Not Verified',
          style: TextStyle(
            fontSize: 15,
            color: verified ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
