import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/root_tab_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Coding Assessment',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const RootTabScreen(),
    );
  }
}
