import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/screens/profile.dart';
import 'package:recipe_app/widgets/search_delegade.dart';
import 'screens/categories.dart';
import 'screens/home_page.dart';
import 'screens/bookmarks.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _HomeState();
}

class _HomeState extends State<Screens> {
  List<IconData> iconList = [
    Icons.home,
    Icons.category_outlined,
    Icons.bookmark_outline_rounded,
    Icons.person,
  ];

  int page = 0;

  int pageView = 0;

  final PageController _pageController = PageController(initialPage: 0);

  Widget pageViewSection() {
    return PageView(
      controller: _pageController,
      onPageChanged: (value) {
        setState(() {
          page = value;
        });
      },
      children: [
        const HomePage(),
        const Categories(),
        Bookmarks(),
        const Profile()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, //icon background
      backgroundColor: Colors.white,
      body: pageViewSection(),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: Colors.cyan,
        onPressed: () {
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(),
          );
        },
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Colors.white,
        gapLocation: GapLocation.center,
        //gapWidth: 50,
        activeColor: Colors.cyan,
        inactiveColor: Colors.grey,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.smoothEdge,
        //notchMargin: 0,
        icons: iconList,
        activeIndex: page,
        onTap: (p0) {
          pageView = p0;
          _pageController.animateToPage(p0,
              curve: Curves.linear,
              duration: const Duration(milliseconds: 300));
        },
      ),
    );
  }
}
