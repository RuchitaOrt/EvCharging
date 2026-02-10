import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  final String text;

  // Constructor to receive the text
  const OrDivider({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 10, right: 10, top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(
              color: Colors.black, // Color of the divider
              thickness: 0.1, // Thickness of the divider line
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Space around the text
            child: Text(
              text, // Dynamic text from parameter
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 14, // You can customize this as needed
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.black, // Color of the divider
              thickness: 0.1, // Thickness of the divider line
            ),
          ),
        ],
      ),
    );
  }
}
