import 'package:flutter/material.dart';

class DialogSubtitleStyle extends StatelessWidget {
  final String? subtitle;
  final double? fontSize;
  final Widget? widget;
  const DialogSubtitleStyle({
    super.key,
    this.subtitle,
    this.fontSize,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.7),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: (widget != null && subtitle == null)
          ? widget
          : Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: fontSize ?? 14,
              ),
            ),
    );
  }
}
