class Product {
  final String id ;
  final String productName;
  final int quantity;
  final double price;
  final String? imageUrl; // Optional image field

  Product({
    required this.productName,
    required this.quantity,
    required this.price,
    this.imageUrl,
    required this.id
  });

  // Convert a Product into a Map for JSON or database storage
  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
      'id':id
    };
  }

  // Create a Product from a Map (e.g. from Firestore or local DB)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'],
      id : map['id'] ,
    );
  }

  // Optional: JSON serialization
  String toJson() => toMap().toString();

  // Optional: CopyWith method to modify specific fields
  Product copyWith({
    String? productName,
    int? quantity,
    double? price,
    String? imageUrl,
    String ? id,
  }) {
    return Product(
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      id : id ?? this.id ,
    );
  }
}
