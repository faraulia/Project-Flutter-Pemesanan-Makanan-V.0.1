import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ambil file dari folder lain
import '../models/menu.dart';
import '../providers/menu_provider.dart';
import '../providers/cart_provider.dart';
import 'cart_page.dart';

class MenuListPage extends ConsumerWidget {
  const MenuListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ambil daftar kategori menu
    final categories = ref.watch(categoryProvider);
    // ambil data keranjang untuk menampilkan badge jumlah item
    final cartItems = ref.watch(cartProvider);

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pemesanan Makanan V.O.1'),
          bottom: TabBar(
            isScrollable: true,
            tabs: categories.map((c) => Tab(text: c)).toList(),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                ),
                if (cartItems.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        cartItems.fold(0, (sum, item) => sum + item.quantity).toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
        body: TabBarView(
          children: categories.map((category) {
            return MenuCategoryView(category: category);
          }).toList(),
        ),
      ),
    );
  }
}

class MenuCategoryView extends ConsumerWidget {
  final String category;
  const MenuCategoryView({required this.category, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menus = ref.watch(sortedMenuByCategoryProvider(category));

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: menus.length,
      itemBuilder: (context, index) {
        final menu = menus[index];
        return MenuCard(menu: menu);
      },
    );
  }
}

class MenuCard extends ConsumerWidget {
  final Menu menu;
  const MenuCard({required this.menu, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // gambar (disimulasikan dengan icon soalnya ga sempet masukin gambar konfigurasikan ke firebase)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kategori: ${menu.category}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${menu.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // tombol tambah ke keranjang
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).addItemToCart(menu);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${menu.name} ditambahkan ke keranjang.'),
                        duration: const Duration(seconds: 1)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}