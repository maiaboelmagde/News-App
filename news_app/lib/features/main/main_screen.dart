import 'package:flutter/material.dart';
import 'package:news_app/core/widgets/custom_svg_picture.dart';
import 'package:news_app/features/bookmark/bookmark_screen.dart';
import 'package:news_app/features/home/home_screen.dart';
import 'package:news_app/features/profile/profile_screen.dart';
import 'package:news_app/features/search/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentScreenIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
     SearchScreen(),
    const BookmarkScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentScreenIndex = index;
          });
        },
        currentIndex: _currentScreenIndex,
        items: [
          BottomNavigationBarItem(icon :CustomSvgPicture(path: 'assets/images/icons/home.svg'), label: 'Home' ),
          BottomNavigationBarItem(icon: CustomSvgPicture(path: 'assets/images/icons/search.svg'), label: 'Search'),
          BottomNavigationBarItem(icon: CustomSvgPicture(path: 'assets/images/icons/bookmark.svg'), label: 'Bookmark'),
          BottomNavigationBarItem(icon: CustomSvgPicture(path: 'assets/images/icons/profile.svg'), label: 'Profile'),
        ],
      ),
      body: _screens[_currentScreenIndex],
    );
  }
}
