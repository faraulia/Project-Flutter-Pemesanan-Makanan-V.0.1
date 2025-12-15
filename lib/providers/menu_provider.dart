import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/menu.dart';

// data statis mensimulasikan data dari Cloud Storage
// jika mau dari cloud kan bisa pakai firebase, tapi saat konfigurasi masih error jadi saya masih simpan seperti ini
final List<Menu> _initialMenuData = [
  Menu(id: 'M001', name: 'Nasi Goreng Spesial', imageUrl: 'url_1', price: 25000.0, category: 'Makanan Utama', displayOrder: 1),
  Menu(id: 'M002', name: 'Mie Ayam Original', imageUrl: 'url_2', price: 22000.0, category: 'Makanan Utama', displayOrder: 2),
  Menu(id: 'M003', name: 'Sate Ayam', imageUrl: 'url_3', price: 30000.0, category: 'Makanan Utama', displayOrder: 3),
  Menu(id: 'S001', name: 'Kentang Goreng', imageUrl: 'url_4', price: 15000.0, category: 'Snack', displayOrder: 1),
  Menu(id: 'S002', name: 'Tahu Isi', imageUrl: 'url_5', price: 10000.0, category: 'Snack', displayOrder: 2),
  Menu(id: 'D001', name: 'Es Teh Manis', imageUrl: 'url_6', price: 5000.0, category: 'Minuman', displayOrder: 1),
  Menu(id: 'D002', name: 'Es Jeruk Nipis', imageUrl: 'url_7', price: 8000.0, category: 'Minuman', displayOrder: 2),
  Menu(id: 'D003', name: 'Kopi Susu Panas', imageUrl: 'url_8', price: 12000.0, category: 'Minuman', displayOrder: 3),
];

// data menu
final menuProvider = StateProvider<List<Menu>>((ref) {
  // pencegahan Duplikasi (sudah dijamin unik oleh ID di data statis ini)
  // jika sumber data nyata, lakukan cek unik di sini
  return _initialMenuData;
});

// daftar kategori unik
final categoryProvider = Provider<List<String>>((ref) {
  final menus = ref.watch(menuProvider);
  return menus.map((m) => m.category).toSet().toList();
});

// mendapatkan menu yang sudah diurutkan per kategori
final sortedMenuByCategoryProvider =
    Provider.family<List<Menu>, String>((ref, category) {
  final allMenus = ref.watch(menuProvider);
  return allMenus
      .where((menu) => menu.category == category)
      .toList()
    ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
});