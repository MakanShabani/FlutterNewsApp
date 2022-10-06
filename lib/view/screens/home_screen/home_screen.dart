import 'package:flutter/material.dart';
import './widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = const [
    HomeSection(),
    Text(
      'Index 1: Search',
    ),
    Text(
      'Index 2: Bookmark',
    ),
    SettingsSection(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBottemNavBarItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
      _pageController.jumpToPage(_selectedPageIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedPageIndex,
          onTap: _onBottemNavBarItemTapped,
          items: bottomNavigationBarItems),
    );
  }
}
