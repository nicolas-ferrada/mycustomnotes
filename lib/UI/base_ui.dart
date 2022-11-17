import 'package:flutter/material.dart';
import 'package:mycustomnotes/UI/pages/main_page.dart';

class BaseUI extends StatelessWidget {
  const BaseUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My custom notes title',
      theme: ThemeData.dark(),
      home: const MainPage(),
    );
  }
}
