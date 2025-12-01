import 'package:flutter/material.dart';

class Tab_Web_RootScreen extends StatelessWidget {
  const Tab_Web_RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tab B: Web Page"),
        backgroundColor: Colors.green.shade100,
      ),
      body: Center(child: Text("Web")),
    );
  }
}
