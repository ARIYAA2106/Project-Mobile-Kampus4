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

  TextField _textboxkodeProduk() {
    return TextField(
      decoration: InputDecoration(labelText: "Kode Produk"),
      controller: _kodeProdukTextboxController,
    );
  }

  TextField _textboxnamaProduk() {
    return TextField(
      decoration: InputDecoration(labelText: "Nama Produk"),
      controller: _namaProdukTextboxController,
    );
  }

  TextField _textboxhargaProduk() {
    return TextField(
      decoration: InputDecoration(labelText: "Harga Produk"),
      controller: _hargaProdukTextboxController,
    );
  }

  ElevatedButton _tombolSimpan() {
    return ElevatedButton(
      child: Text("Simpan"),
      onPressed: () {
        String kodeProduk = _kodeProdukTextboxController.text;
        String namaProduk = _namaProdukTextboxController.text;
        int harga = int.parse(_hargaProdukTextboxController.text);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProdukDetail(
              kodeProduk: kodeProduk,
              namaProduk: namaProduk,
              hargaProduk: harga,
            ),
          ),
        );
      },
    );
  }
}
