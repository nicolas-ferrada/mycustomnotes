import 'package:flutter/material.dart';

class DialogTitleStyle extends StatelessWidget {
  final String title;
  const DialogTitleStyle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade800.withOpacity(0.8),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          textAlign: TextAlign.center,
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
