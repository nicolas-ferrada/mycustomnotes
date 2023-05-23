import 'package:flutter/material.dart';

class DialogSubtitleStyle extends StatelessWidget {
  final String subtitle;
  const DialogSubtitleStyle({
    super.key,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.7),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Text(
        subtitle,
        textAlign: TextAlign.center,
        style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
      ),
    );
  }
}
