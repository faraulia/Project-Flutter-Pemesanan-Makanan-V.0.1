// buat menu
class Menu {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String category; // Makanan, Minuman, dll.
  final int displayOrder; // urutan muncul dalam kategori

  Menu({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.displayOrder,
  });

  // untuk penyimpanan lokal (semisal perlu)
  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      category: json['category'],
      displayOrder: json['displayOrder'],
    );
  }
  
  // konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'category': category,
      'displayOrder': displayOrder,
    };
  }
}