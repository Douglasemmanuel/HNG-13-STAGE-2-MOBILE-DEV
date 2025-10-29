import 'package:flutter/material.dart';
import 'package:store_keeper_app/data/products_data.dart';
import 'package:store_keeper_app/models/store_models.dart';
import 'package:store_keeper_app/widgets/component/product_card.dart';

class AllScreen extends StatelessWidget {
  const AllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          
          'All Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final Product product = products[index];
            return ProductCard(
              imageUrl: product.imageUrl ?? '',
              productName: product.productName,
              price: product.price,
              quantity: product.quantity,
              productId: product.id,
              isLast: index == products.length - 1,
            );
          },
        ),
      ),
    );
  }
}
