import 'package:simple_alert_dialog/simple_alert_dialog.dart';
import 'package:cherry_toast/cherry_toast.dart';

import 'package:flutter/material.dart';
import 'package:kampus/page/profile_page.dart';
import 'package:kampus/page/beranda_page.dart';
import 'package:kampus/page/pertemuan%206/dashboard_page.dart';
import 'package:kampus/page/list_page/list_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// import 'package:kampus/column_widget.dart';
// import 'package:kampus/row_widget.dart';
// import 'package:kampus/ui/produk_detail.dart';
// import 'package:kampus/ui/produk_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Widget> _page = [
    BerandaPage(),
    ProfilePage(),
    ListPage(),
    DashboardPage(),
  ];

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
            // Beranda
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Beranda"),
              selectedColor: Colors.blue,
            ),
            // Profile
            SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
              selectedColor: Colors.blue,
            ),

            // List
            SalomonBottomBarItem(
              icon: Icon(Icons.list),
              title: Text("List"),
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

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,

//       title: "Menampilkan hello world",
//       home: ProdukForm(),
//     );
//   }
// }
