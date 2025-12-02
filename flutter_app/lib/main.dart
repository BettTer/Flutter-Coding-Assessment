import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/message_model.dart';
import 'screens/root_tab_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(SingleMessageAdapter());
  await Hive.openBox<SingleMessage>('chat_history');

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
