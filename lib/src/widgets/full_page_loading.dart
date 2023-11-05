import 'package:flutter/material.dart';

class FullPageLoading extends StatefulWidget {
  final Widget Function(void Function(bool)) builder;
  const FullPageLoading({super.key, required this.builder});

  @override
  State<FullPageLoading> createState() => _FullPageLoadingState();
}

class _FullPageLoadingState extends State<FullPageLoading> {
  bool isLoading = false;

  setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.builder(setLoading),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black
                  .withOpacity(0.7), // Background color with opacity
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
