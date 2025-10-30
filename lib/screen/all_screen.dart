


import 'package:flutter/material.dart';
import 'package:store_keeper_app/models/store_models.dart';
import 'package:store_keeper_app/services/database_provider.dart' ;
import 'package:store_keeper_app/widgets/component/product_card.dart';

class AllScreen extends StatelessWidget {
  final String category;

  const AllScreen({super.key, this.category = 'all'}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          category == 'all' ? 'All Products' : '$category Products',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<List<Product>>(
          future: ProductServices().filterProduct(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error loading products: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No products found.'));
            }

            final products = snapshot.data!;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final Product product = products[index];
                return ProductCard(
                  image: product.image,
                  productName: product.productName,
                  price: product.price,
                  quantity: product.quantity,
                  productId: product.id.toString(),
                  isLast: index == products.length - 1,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
