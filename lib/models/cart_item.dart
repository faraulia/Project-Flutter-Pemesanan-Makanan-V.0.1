// ambil file menu.dart
import 'menu.dart';

class CartItem {
  final Menu menu;
  int quantity;
  final DateTime selectionTime; // urutan item mengikuti waktu pemilihan

  CartItem({
    required this.menu,
    required this.quantity,
    required this.selectionTime,
  });

  // penyimpanan lokal
  // karena data keranjang belanja disimpan ke penyimpanan lokal
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      menu: Menu.fromJson(json['menu']),
      quantity: json['quantity'],
      selectionTime: DateTime.parse(json['selectionTime']),
    );
  }

  // ubah objek CartItem ke format JSON
  Map<String, dynamic> toJson() {
    return {
      'menu': menu.toJson(),
      'quantity': quantity,
      'selectionTime': selectionTime.toIso8601String(),
    };
  }
}