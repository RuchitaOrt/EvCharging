import 'dart:io';
import 'package:flutter/material.dart';

class KeyboardDoneWrapper extends StatelessWidget {
  final Widget child;

  const KeyboardDoneWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) return child;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40,
          color: Colors.grey.shade200,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: const Text(
              "Done",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}