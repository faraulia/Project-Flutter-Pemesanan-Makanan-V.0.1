// encode decode JSON
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';

class StorageService {
  static const String _cartKey = 'cart_data';

  // load cart data dari shared preferences
  Future<List<CartItem>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartString = prefs.getString(_cartKey);

    if (cartString != null) {
      final List<dynamic> jsonList = json.decode(cartString);
      return jsonList.map((jsonItem) => CartItem.fromJson(jsonItem)).toList();
    }
    return [];
  }

  Future<void> saveCart(List<CartItem> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
        cartItems.map((item) => item.toJson()).toList();
    await prefs.setString(_cartKey, json.encode(jsonList));
  }
}