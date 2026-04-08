import 'package:flutter/material.dart';
import 'package:kampus/ui/produk_detail.dart';

class ProdukForm extends StatefulWidget {
  const ProdukForm({super.key});

  @override
  _Produkformstate createState() => _Produkformstate();
}

class _Produkformstate extends State<ProdukForm> {
  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form Produk")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _textboxkodeProduk(),
            _textboxnamaProduk(),
            _textboxhargaProduk(),
            _tombolSimpan(),
          ],
        ),
      ),
    );
  }

  _textboxkodeProduk() {
    return TextField(
      decoration: InputDecoration(labelText: "Kode Produk"),
      controller: _kodeProdukTextboxController,
    );
  }

  _textboxnamaProduk() {
    return TextField(
      decoration: InputDecoration(labelText: "Nama Produk"),
      controller: _namaProdukTextboxController,
    );
  }

  _textboxhargaProduk() {
    return TextField(
      decoration: InputDecoration(labelText: "Harga Produk"),
      controller: _hargaProdukTextboxController,
    );
  }

  _tombolSimpan() {
    return ElevatedButton(
      child: Text("Simpan"),
      onPressed: () {
        String kode_produk = _kodeProdukTextboxController.text;
        String nama_produk = _namaProdukTextboxController.text;
        int harga = int.parse(_hargaProdukTextboxController.text);

        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (context) => ProdukDetail(
              kodeProduk: kode_produk,
              namaProduk: nama_produk,
              hargaProduk: harga,
            ),
          ),
        );
      },
    );
  }
}
