import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BloodDonationCard extends StatefulWidget {
  @override
  _BloodDonationCardState createState() => _BloodDonationCardState();
}

class _BloodDonationCardState extends State<BloodDonationCard> {
  final List<String> benefits = [
    // 'Helps save lives',
    // 'Reduces the risk of certain diseases',
    // 'Burns calories',
    // 'Boosts your mood',
    // 'Stimulates blood cell production',
  ];

  final List<String> facts = [
    'Blood makes up about 7-8% of your total body weight.',
    'There are four main blood types: A, B, AB, and O.',
    'Blood donors are heroes!',
    'The average adult has about 10 pints of blood in their body.',
    'Blood is essential for transporting nutrients and oxygen throughout the body.',
  ];

  String displayText = '';

  @override
  void initState() {
    super.initState();
    _updateDisplayText();
  }

  void _updateDisplayText() {
    final Random random = Random();
    final bool showBenefits = random.nextBool();
    final List<String> sourceList = showBenefits ? benefits : facts;

    final int index = random.nextInt(sourceList.length);
    setState(() {
      displayText = sourceList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;

    return Container(
      width: width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.pink[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${'Did You Know'.tr}?',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            displayText,
            style: const TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          // const SizedBox(height: 20),
          // FlatButton(
          //   onPressed: () {
          //     _updateDisplayText();
          //   },
          //   color: Colors.pink,
          //   textColor: Colors.white,
          //   child: Text('Show Another'),
          // ),
        ],
      ),
    );
  }
}
