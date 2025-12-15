import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ambil file dari folder lain
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ambil data keranjang dari cartProvider
    final cartItems = ref.watch(cartProvider);

    // mengambil hasil perhitungan subtotal, service charge, dan PB1
    final totalData = ref.watch(totalCalculationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Keranjang Anda kosong.'))
          : Column(
              children: [
                Expanded(
                  // daftar item diurutkan berdasarkan selectionTime (ada di CartNotifier)
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartItemTile(item: item);
                    },
                  ),
                ),
                // rincian pembayaran
                _buildPaymentSummary(context, totalData),
              ],
            ),
    );
  }

  Widget _buildPaymentSummary(
      BuildContext context, Map<String, double> totalData) {
    
    // format mata uang
    String formatCurrency(double amount) {
      return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
        (Match m) => '${m[1]}.',
      )}';
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, offset: Offset(0, -2), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // rincian biaya
          _buildDetailRow('Subtotal Harga Menu', totalData['subtotal']!, formatCurrency),
          _buildDetailRow('Service Charge (7.5%)', totalData['serviceCharge']!, formatCurrency),
          _buildDetailRow('PB1 (10% dari total setelah service)', totalData['pb1']!, formatCurrency),
          const Divider(),
          // total
          _buildDetailRow('TOTAL PEMBAYARAN', totalData['grandTotal']!, formatCurrency, isTotal: true),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // ke tahap pemesanan berikutnya tp kan belum
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lanjut ke Tahap Pemesanan... (Belum diimplementasikan)')));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Lanjut Pemesanan'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      String title, double amount, String Function(double) formatter,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            formatter(amount),
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemTile extends ConsumerWidget {
  final CartItem item;
  const CartItemTile({required this.item, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.local_cafe, color: Colors.blueGrey),
        ),
        title: Text(item.menu.name),
        subtitle: Text(
            'Rp ${item.menu.price.toStringAsFixed(0)} x ${item.quantity}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                ref.read(cartProvider.notifier).updateQuantity(item, item.quantity - 1);
              },
            ),
            Text(item.quantity.toString()),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                ref.read(cartProvider.notifier).updateQuantity(item, item.quantity + 1);
              },
            ),
          ],
        ),
      ),
    );
  }
}