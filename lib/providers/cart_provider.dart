import 'package:flutter_riverpod/flutter_riverpod.dart';

// ambil file dari folder lain
import '../models/menu.dart';
import '../models/cart_item.dart';
import '../services/storage_service.dart';

// provider penyimpanan lokal
final storageServiceProvider = Provider((ref) => StorageService());

// provider untuk keranjang belanja
final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier(ref);
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  final Ref _ref;

  CartNotifier(this._ref) : super([]) {
    _loadInitialCart();
  }

  Future<void> _loadInitialCart() async {
    final storedItems = await _ref.read(storageServiceProvider).loadCart();
    // mengurutkan item saat dimuat berdasarkan selectionTime (FIFO)
    storedItems.sort((a, b) => a.selectionTime.compareTo(b.selectionTime));
    state = storedItems;
  }

  void _saveCart() {
    _ref.read(storageServiceProvider).saveCart(state);
  }

  void addItemToCart(Menu menu) {
    bool found = false;
    final List<CartItem> updatedCart = state.map((item) {
      if (item.menu.id == menu.id) {
        item.quantity++;
        found = true;
      }
      return item;
    }).toList();

    if (!found) {
      final newItem = CartItem(
        menu: menu,
        quantity: 1,
        selectionTime: DateTime.now(),
      );
      updatedCart.add(newItem);
    }
    
    // pastikan urutan item mengikuti waktu pemilihan
    updatedCart.sort((a, b) => a.selectionTime.compareTo(b.selectionTime));
    state = updatedCart;
    _saveCart();
  }

  void updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(item);
      return;
    }
    state = state.map((i) {
      if (i.menu.id == item.menu.id) {
        i.quantity = newQuantity;
      }
      return i;
    }).toList();
    _saveCart();
  }

  void removeItem(CartItem item) {
    state = state.where((i) => i.menu.id != item.menu.id).toList();
    _saveCart();
  }
  
  // PERHITUNGAN
  // total = subtotal + service charge + pb1
  Map<String, double> calculateTotal() {
    const double serviceChargeRate = 0.075; // 7.5%
    const double pb1Rate = 0.10; // 10%

    // 1. hitung subtotal harga menu
    final subtotal = state.fold(
        0.0, (sum, item) => sum + (item.menu.price * item.quantity));
    
    // 2. hitung service charge
    final serviceCharge = subtotal * serviceChargeRate;
    
    // 3. hitung total setelah service charge
    final totalAfterServiceCharge = subtotal + serviceCharge;
    
    // 4. hitung PB1 (dihitung dari total setelah service charge)
    final pb1 = totalAfterServiceCharge * pb1Rate;
    
    // 5. hitung grand total
    final grandTotal = totalAfterServiceCharge + pb1;

    return {
      'subtotal': subtotal,
      'serviceCharge': serviceCharge,
      'pb1': pb1,
      'grandTotal': grandTotal,
    };
  }
}

// provider untuk mendapatkan hasil perhitungan total
final totalCalculationProvider = Provider<Map<String, double>>((ref) {
  final cartNotifier = ref.watch(cartProvider.notifier);
  return cartNotifier.calculateTotal();
});