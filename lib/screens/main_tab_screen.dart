import 'package:dancemate_app/provider/main_tap_provider.dart';
import 'package:dancemate_app/screens/calendar_screen.dart';
import 'package:dancemate_app/screens/home_screen.dart';
import 'package:dancemate_app/screens/profile_screen.dart';
import 'package:dancemate_app/screens/search_screen.dart';
import 'package:dancemate_app/widgets/nav_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selectedIndex = ref.watch(mainTapProvider);

    void onTap(int index) {
      ref.read(mainTapProvider.notifier).update((state) => index);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Offstage(
            offstage: selectedIndex != 0,
            child: const HomeScreen(),
          ),
          Offstage(
            offstage: selectedIndex != 1,
            child: const SearchScreen(),
          ),
          Offstage(
            offstage: selectedIndex != 2,
            child: const CalendarScreen(),
          ),
          Offstage(
            offstage: selectedIndex != 3,
            child: const Scaffold(),
          ),
          Offstage(
            offstage: selectedIndex != 4,
            child: const ProfileScreen(),
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
              isSelected: selectedIndex == 0,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_outlined,
              onTap: () => onTap(0),
              selectedIndex: selectedIndex,
            ),
            NavTab(
              text: '검색',
              isSelected: selectedIndex == 1,
              icon: Icons.search_outlined,
              selectedIcon: Icons.search,
              onTap: () => onTap(1),
              selectedIndex: selectedIndex,
            ),
            NavTab(
              text: '달력',
              isSelected: selectedIndex == 2,
              icon: Icons.calendar_month_outlined,
              selectedIcon: Icons.calendar_month,
              onTap: () => onTap(2),
              selectedIndex: selectedIndex,
            ),
            NavTab(
              text: '커뮤니티',
              isSelected: selectedIndex == 3,
              icon: Icons.forum_outlined,
              selectedIcon: Icons.forum,
              onTap: () => onTap(3),
              selectedIndex: selectedIndex,
            ),
            NavTab(
              text: '프로필',
              isSelected: selectedIndex == 4,
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              onTap: () => onTap(4),
              selectedIndex: selectedIndex,
            ),
          ],
        ),
      ),
    );
  }
}
