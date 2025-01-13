import 'package:flutter/material.dart';
import 'package:scanner/core/utils/theme.dart';
import 'package:scanner/features/home/screen/home_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doc scanner',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
