import 'dart:io';

import 'package:circle/core/theme/constants.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../features/emergency/emergency.dart';
import '../features/home/home.dart';
import '../features/meds/meds.dart';
import '../features/profile/profile.dart';
import '../features/water/water.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  static const String id = "nav_bar";
  const BottomNavBar({super.key});

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final List<Widget> pages = [
    const HomeScreen(
      key: PageStorageKey(HomeScreen.id),
    ),
    const WaterScreen(
      key: PageStorageKey(WaterScreen.id),
    ),
    const EmergencyScreen(
      key: PageStorageKey(EmergencyScreen.id),
    ),
    const MedsScreen(
      key: PageStorageKey(MedsScreen.id),
    ),
    const ProfileScreen(
      key: PageStorageKey(ProfileScreen.id),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  Widget _bottomNavBar(
      {required int selectedIndex, required Color selectedItemColor}) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        NavigationBar(
          indicatorColor: Platform.isIOS
              ? Theme.of(context).scaffoldBackgroundColor.withValues(alpha:0)
              : Theme.of(context).colorScheme.primaryContainer,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          elevation: 0,
          selectedIndex: selectedIndex,
          destinations: [
            NavigationDestination(
                label: "Home",
                icon: SvgPicture.asset(
                  "assets/svg/home-alt.svg",
                  colorFilter: const ColorFilter.mode(
                      AppColours.neutral50, BlendMode.srcIn),
                ),
                selectedIcon: SvgPicture.asset(
                  "assets/svg/home-alt-filled.svg",
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).iconTheme.color!, BlendMode.srcIn),
                )),
            NavigationDestination(
              label: "Water",
              icon: SvgPicture.asset(
                "assets/svg/droplet-alt.svg",
                colorFilter: const ColorFilter.mode(
                    AppColours.neutral50, BlendMode.srcIn),
              ),
              selectedIcon: SvgPicture.asset(
                "assets/svg/droplet-alt-filled.svg",
                colorFilter: ColorFilter.mode(
                    Theme.of(context).iconTheme.color!, BlendMode.srcIn),
              ),
            ),
            NavigationDestination(
                label: "Emergency",
                icon: SvgPicture.asset(
                  "assets/svg/emergency-alt.svg",
                  colorFilter: const ColorFilter.mode(
                      AppColours.neutral50, BlendMode.srcIn),
                ),
                selectedIcon: SvgPicture.asset(
                  "assets/svg/emergency-alt-filled.svg",
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).iconTheme.color!, BlendMode.srcIn),
                )),
            NavigationDestination(
              label: "Meds",
              icon: const Icon(FluentIcons.pill_24_regular,
                  color: AppColours.neutral50),
              selectedIcon: Icon(FluentIcons.pill_24_filled,
                  color: Theme.of(context).iconTheme.color),
            ),
            NavigationDestination(
              label: "Profile",
              icon: const Icon(FluentIcons.person_24_regular,
                  color: AppColours.neutral50),
              selectedIcon: Icon(FluentIcons.person_24_filled,
                  color: Theme.of(context).iconTheme.color),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: _bottomNavBar(
          selectedIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Theme.of(context).primaryColor),
      body: PageStorage(
        bucket: bucket,
        child: pages[_selectedIndex],
      ),
    );
  }
}
