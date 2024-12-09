import 'package:dancemate_app/screens/home.dart';
import 'package:dancemate_app/widgets/nav_tab.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPostVideoButtonTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Record video'),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const HomeScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const Scaffold(),
          ),
          Offstage(
            offstage: _selectedIndex != 2,
            child: const Scaffold(),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const Scaffold(),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: const Scaffold(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavTab(
              text: '홈',
              isSelected: _selectedIndex == 0,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_outlined,
              onTap: () => _onTap(0),
              selectedIndex: _selectedIndex,
            ),
            NavTab(
              text: '검색',
              isSelected: _selectedIndex == 1,
              icon: Icons.search_outlined,
              selectedIcon: Icons.search,
              onTap: () => _onTap(1),
              selectedIndex: _selectedIndex,
            ),
            NavTab(
              text: '달력',
              isSelected: _selectedIndex == 2,
              icon: Icons.calendar_month_outlined,
              selectedIcon: Icons.calendar_month,
              onTap: () => _onTap(2),
              selectedIndex: _selectedIndex,
            ),
            NavTab(
              text: '커뮤니티',
              isSelected: _selectedIndex == 3,
              icon: Icons.forum_outlined,
              selectedIcon: Icons.forum,
              onTap: () => _onTap(3),
              selectedIndex: _selectedIndex,
            ),
            NavTab(
              text: '프로필',
              isSelected: _selectedIndex == 4,
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              onTap: () => _onTap(4),
              selectedIndex: _selectedIndex,
            ),
          ],
        ),
      ),
    );
  }
}
