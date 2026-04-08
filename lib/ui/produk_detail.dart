import 'package:flutter/material.dart';

class ProdukDetail extends StatefulWidget {
  final String kodeProduk;
  final String namaProduk;
  final int hargaProduk;

  ProdukDetail({
    required this.kodeProduk,
    required this.namaProduk,
    required this.hargaProduk,
  });

  @override
  _produkDetailState createState() => _produkDetailState();
}

class _produkDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Produk")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text("Kode Produk  : ${widget.kodeProduk}"),
          Text("Nama Produk  : ${widget.namaProduk}"),
          Text("Harga Produk  : ${widget.hargaProduk.toString()}"),

          Divider(),
        ],
      ),
    );
  }
}
