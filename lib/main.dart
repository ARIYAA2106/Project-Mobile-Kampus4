import 'package:flutter/material.dart';
import 'package:kampus/page/profile_page.dart';
import 'package:kampus/page/pertemuan%206/dashboard_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:kampus/page/pertemuan 10/auth/auth_page.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_file.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http_parser/http_parser.dart';
import '../pertemuan%2012/model/Product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: AuthPage(),
      debugShowCheckedModeBanner: false,
    ); // MaterialApp
  }
}










// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   List<Widget> _page = [ProfilePage(), DashboardPage()];

//   int currentPage = 0;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: Scaffold(
//         body: _page[currentPage],
//         bottomNavigationBar: SalomonBottomBar(
//           currentIndex: currentPage,
//           onTap: (i) => setState(() => currentPage = i),
//           items: [
//             // Profile
//             SalomonBottomBarItem(
//               icon: Icon(Icons.person),
//               title: Text("Profile"),
//               selectedColor: Colors.blue,
//             ),

//             SalomonBottomBarItem(
//               icon: Icon(Icons.list),
//               title: Text("Dashboard"),
//               selectedColor: Colors.blue,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

