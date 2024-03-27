import 'package:flutter/material.dart';
import 'package:sarafy/ui/screens/profile.dart';
import 'package:sarafy/ui/screens/home_screen.dart';
import 'package:sarafy/ui/screens/market_view.dart';
import 'package:sarafy/ui/screens/watch_list.dart';
import 'package:sarafy/ui/ui_helper/bottom_nav.dart';

class mainWrapper extends StatefulWidget {
  const mainWrapper({super.key});

  @override
  State<mainWrapper> createState() => _mainWrapperState();
}

class _mainWrapperState extends State<mainWrapper> {
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).primaryColorLight,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        onPressed: () {},
        child: const Icon(
          Icons.compare_arrows_outlined,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNav(controller: pageController),
      body: PageView(
        controller: pageController,
        children: const [
          HomeScreen(),
          MarketViewPage(),
          ProfileScreen(),
          WatchList(),
        ],
      ),
    );
  }
}
