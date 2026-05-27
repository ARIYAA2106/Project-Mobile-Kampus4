import 'package:flutter/material.dart';
import 'package:kampus/column_widget.dart';
import 'package:kampus/page/beranda_page.dart';
import 'package:kampus/page/list_page/list_page.dart';
import 'package:kampus/page/pertemuan 6/pertemuan6.dart';
import 'package:kampus/page/pertemuan%2010/home_page.dart';
import 'package:kampus/page/pertemuan%207/pertemuan7.dart';
import 'package:kampus/page/pertemuan%208/auto_complete.dart';
import 'package:kampus/page/pertemuan%209/pertemuan9.dart';
import 'package:kampus/row_widget.dart';
import 'package:kampus/ui/produk_form.dart';

class DashboardPage extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {
      "title": "Pertemuan 1",
      "icon": Icons.auto_stories,
      "color": Colors.blue,
      "page": ColumnWidget(),
    },
    {
      "title": "Pertemuan 2",
      "icon": Icons.auto_stories,
      "color": Colors.blue,
      "page": RowWidget(),
    },
    {
      "title": "Pertemuan 3",
      "icon": Icons.auto_stories,
      "color": Colors.blue,
      "page": ProdukForm(),
    },

    {
      "title": "Pertemuan 4",
      "icon": Icons.auto_stories,
      "color": Colors.blue,
      "page": BerandaPage(),
    },

    {
      "title": "Pertemuan 5",
      "icon": Icons.auto_stories,
      "color": Colors.blue,
      "page": ListPage(),
    },
    {
      "title": "Pertemuan 6",
      "icon": Icons.auto_stories,
      "color": Colors.green,
      "page": CheckboxPage(),
    },
    {
      "title": "Pertemuan 7",
      "icon": Icons.auto_stories,
      "color": Colors.orange,
      "page": RadiobuttonPage(),
    },
    {
      "title": "Pertemuan 8",
      "icon": Icons.auto_stories,
      "color": Colors.purple,
      "page": AutocompletespinPage(),
    },
    {
      "title": "Pertemuan 9",
      "icon": Icons.auto_stories,
      "color": Colors.purple,
      "page": Pertemuan9Page(),
    },
    {
      "title": "Pertemuan 10",
      "icon": Icons.auto_stories,
      "color": Colors.purple,
      "page": HomePage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        title: Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return _buildMenuCard(
              context,
              title: item['title'],
              icon: item['icon'],
              color: item['color'],
              onTap: () {
                // Action klik
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item['page']),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 5,
      shadowColor: Colors.black26,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon dengan background
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              SizedBox(height: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
