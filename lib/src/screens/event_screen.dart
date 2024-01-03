import 'package:flutter/material.dart';
import 'package:raktadaan/src/helpers/localization.dart';
import 'package:raktadaan/src/models/event_model.dart';

class EventScreen extends StatelessWidget {
  final EventModel event;

  const EventScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      // event title at top
      // event datetime
      //and then event description text
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              event.image,
              // height: 150,
              width: screenWidth,
              // width: 200,
              fit: BoxFit.cover,
            ),
            Text(event.title,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Text(formatFirestoreTimestamp(event.date),
                style: const TextStyle(color: Colors.black54)),
            SelectableText(event.description),
          ],
        ),
      ),
    );
  }
}
