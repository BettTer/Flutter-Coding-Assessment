import 'package:flutter/material.dart';
import 'tab_main_screen.dart';
import 'tab_web_screen.dart';

class RootTabScreen extends StatefulWidget {
  const RootTabScreen({super.key});

  @override
  State<RootTabScreen> createState() => _RootTabScreenState();
}

class _RootTabScreenState extends State<RootTabScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Tab_Main_RootScreen(),
    const Tab_Web_RootScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Main Tab",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.web), label: "Web Tab"),
        ],
      ),
    );
  }
}
