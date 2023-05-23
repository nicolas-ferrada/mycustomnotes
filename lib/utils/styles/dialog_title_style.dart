import 'package:flutter/material.dart';

class DialogTitleStyle extends StatelessWidget {
  final String title;
  final double? fontSize;
  const DialogTitleStyle({
    super.key,
    required this.title,
    this.fontSize,
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
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize ?? 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
