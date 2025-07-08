import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_exchange/config/app_theme.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Dorado',
      theme: AppTheme.theme,
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
