import 'package:flutter/material.dart';
import 'package:kampus/page/pertemuan%2010/home_page.dart';
import 'package:kampus/page/pertemuan%206/dashboard_page.dart';
import 'package:kampus/page/profile_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HalamanUtama extends StatefulWidget {
  HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _MyAppState();
}

class _MyAppState extends State<HalamanUtama> {
  List<Widget> _page = [HomePage(), ProfilePage(), DashboardPage()];

  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: _page[currentPage],
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: currentPage,
          onTap: (i) => setState(() => currentPage = i),
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Home"),
              selectedColor: Colors.blue,
            ),
            // Profile
            SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
              selectedColor: Colors.blue,
            ),

            SalomonBottomBarItem(
              icon: Icon(Icons.list),
              title: Text("Dashboard"),
              selectedColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
