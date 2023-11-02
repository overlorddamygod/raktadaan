import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class Unknown extends StatelessWidget {
  const Unknown({super.key});

  static const routeName = '/404';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('404 Not found'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
