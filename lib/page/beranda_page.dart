import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:kampus/main.dart';
import 'package:kampus/page/profile_page.dart';
import 'package:simple_alert_dialog/simple_alert_dialog.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPage();
}

class _BerandaPage extends State<BerandaPage> {
  final List<Widget> _page = [BerandaPage(), ProfilePage()];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Pertemuan 4"),
      ),
      body: Center(
        child: Column(
          children: [
            // Submit
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                SimpleAlertDialog.show(
                  context,
                  assetImagepath: AnimatedImage.confirm,
                  buttonsColor: Colors.green,
                  title: AlertTitleText("Apakah kamu yakin?"),
                  content: AlertContentText(
                    "Apakah kamu ingin menambahkan data",
                  ),
                  onConfirmButtonPressed: (ctx) {
                    // Perbaikan di sini
                    CherryToast.success(
                      title: Text("Silahkan klik Summary Experience"),
                    ).show(context);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Hapus
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                SimpleAlertDialog.show(
                  context,
                  assetImagepath: AnimatedImage.warning,
                  buttonsColor: Colors.green,
                  title: AlertTitleText("Apakah kamu yakin?"),
                  content: AlertContentText("Apakah kamu ingin menghapus data"),
                  onConfirmButtonPressed: (ctx) {
                    CherryToast.success(
                      inheritThemeColors: true,
                      title: Text("Berhasil menghapus data!"),
                      borderRadius: 5,
                    ).show(context);
                    Navigator.pop(context);
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Delete",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Show Dialog
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Tutup"),
                      ),
                    ],
                    title: Text("AlertDialog"),
                    contentPadding: EdgeInsets.all(20),
                    content: Text("Ini AlertDialog"),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Show Dialog",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
