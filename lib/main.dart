import 'package:flutter/material.dart';
import 'package:kampus/column_widget.dart';
import 'package:kampus/row_widget.dart';
import 'package:kampus/ui/produk_detail.dart';
import 'package:kampus/ui/produk_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Menampilkan hello world",
      home: ProdukForm(),
    );
  }
}
