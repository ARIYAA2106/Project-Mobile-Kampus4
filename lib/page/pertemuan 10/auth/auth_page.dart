import 'package:flutter/material.dart';
import 'package:kampus/page/pertemuan 10/auth/login_page.dart';
import 'package:kampus/page/pertemuan 10/auth/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ), // LinearGradient
        ), // BoxDecoration
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ), // BoxShadow
                    ],
                  ), // BoxDecoration
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: isLogin ? LoginPage() : RegisterPage(),
                  ), // ClipRRect
                ), // Container
              ), // Expanded
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLogin
                          ? "Don't have an account? "
                          : "Already have an account? ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ), // TextStyle
                    ), // Text
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin ? "Register" : "Login",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ), // TextStyle
                      ), // Text
                    ), // GestureDetector
                  ],
                ), // Row
              ), // Padding
            ],
          ), // Column
        ), // SafeArea
      ), // Container
    ); // Scaffold
  }
}
