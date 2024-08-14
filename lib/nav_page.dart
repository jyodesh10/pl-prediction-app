import 'package:flutter/material.dart';
import 'package:pl_prediction/banter_page.dart';
import 'package:pl_prediction/friends_page.dart';
import 'package:pl_prediction/home_page.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedIndex == 0
        ? const HomePage()
        : selectedIndex == 1
          ? const FriendsPage()
          : const BanterPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.border_all_rounded),
            label: "Predict"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group), 
            label: "Friends"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat), 
            label: "Banter"
          ),
        ]
      ),
    );
  }
}