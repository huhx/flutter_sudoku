import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/category/category_screen.dart';
import 'package:flutter_sudoku/business/home/home_screen.dart';
import 'package:flutter_sudoku/business/profile/profile_screen.dart';
import 'package:flutter_sudoku/component/custom_navigation_bar_item.dart';
import 'package:flutter_sudoku/theme/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var pageIndex = 0;
  final screens = [const HomeScreen(), const CategoryScreen(), const ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 11,
        selectedFontSize: 12,
        selectedItemColor: themeColor,
        type: BottomNavigationBarType.fixed,
        onTap: (value) => setState(() => pageIndex = value),
        currentIndex: pageIndex,
        items: [
          CustomNavigationBarItem(iconName: 'main_home', text: '首页'),
          CustomNavigationBarItem(iconName: 'main_category', text: '数独'),
          CustomNavigationBarItem(iconName: 'main_profile', text: '我的'),
        ],
      ),
    );
  }
}
