class Product {
  final String id;
  final String productName; // in the app
  final int quantity;
  final double price;
  final String? image; 
  final DateTime createdAt;

  Product({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.image,
    required this.id,
    required this.createdAt,
  });

  // Convert Product to Map (for sqflite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': productName, // ✅ match DB column
      'quantity': quantity,
      'price': price,
      'image': image  ?? '',
      'createdAt': createdAt.toIso8601String(), // store DateTime as String
      // 'category' can be added here if you expand your model
    };
  }

  // Create Product from Map (from sqflite)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      productName: map['name'] ?? '', // ✅ match DB column
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      image: map['image'],  // nullable
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  // Copy with method
  Product copyWith({
    String? productName,
    int? quantity,
    double? price,
    String? image,
    String? id,
    DateTime? createdAt,
  }) {
    return Product(
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      image: image ?? this.image,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
