import 'package:flutter/material.dart';
import 'tab_main_chat_screen.dart';

class Tab_Main_RootScreen extends StatelessWidget {
  const Tab_Main_RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tab A: Title Page"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.message), // Replace with your desired icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Welcome! \nTap right message button of navigation bar to enter chat page",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
