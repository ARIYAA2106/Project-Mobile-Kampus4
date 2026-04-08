import 'package:flutter/material.dart';

class RowWidget extends StatelessWidget {
  const RowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Widget Column")),
      body: Row(children: [Text("Kolom 1"), Text("Kolom 2"), Text("Kolom 3")]),
    );
  }
}
