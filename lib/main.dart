// ini import emang udah ada di awal file
import 'package:flutter/material.dart';

// Import Riverpod sebagai state management
// Riverpod digunakan untuk mengelola state aplikasi seperti:
// - data menu dari cloud
// - data keranjang belanja yang tersimpan secara lokal
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ini import file lain
import 'pages/menu_list_page.dart';

void main() {
  // pastikan inisialisasi flutter sudah selesai
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // ProviderScope merupakan root container dari Riverpod
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pemesanan Makanan V.O.1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MenuListPage(), // ini halaman awal
    );
  }
}