import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kampus/page/pertemuan 10/auth/auth_page.dart';
import 'package:kampus/page/pertemuan%2010/auth/auth_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ), // IconButton
        ],
      ), // AppBar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.blue.shade700,
              ), // Icon
            ), // CircleAvatar
            const SizedBox(height: 20),
            Text(
              'Welcome, ${user?.displayName ?? user?.email ?? "User"}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ), // TextStyle
              textAlign: TextAlign.center,
            ), // Text
            const SizedBox(height: 10),
            Text(
              'Email: ${user?.email ?? "No email"}',
              style: const TextStyle(fontSize: 16),
            ), // Text
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
              ), // BoxDecoration
              child: const Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 50),
                  SizedBox(height: 10),
                  Text(
                    'You have successfully logged in!',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ), // Text
                ],
              ), // Column
            ), // Container
          ],
        ), // Column
      ), // Center
    ); // Scaffold
  }
}
