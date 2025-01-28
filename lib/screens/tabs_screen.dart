import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../routes/routes_names.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _irProfile() {
    Get.toNamed(profileScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Olympus'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu), // Ícono a la derecha
            onPressed: () {
              _irProfile();
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: const <Widget>[
          Text('Uno'),
          Text('Dos'),
        ],
      ),
      bottomNavigationBar: StylishBottomBar(
        option: BubbleBarOptions(
          opacity: 0.3,
          padding: const EdgeInsets.all(8),
          barStyle: BubbleBarStyle.vertical,
        ),
        items: <BottomBarItem>[
          BottomBarItem(
            icon: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            backgroundColor: Theme.of(context).primaryColor,
            selectedIcon: const Icon(Icons.home_sharp),
          ),
          BottomBarItem(
            icon: const Icon(Icons.price_check_sharp),
            title: const Text('Ventas'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
        elevation: 12,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(
            () {
              _currentIndex = index;
              _pageController.jumpToPage(index);
            },
          );
        },
      ),
    );
  }
}
