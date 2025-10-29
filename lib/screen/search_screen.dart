import 'package:flutter/material.dart';
import 'package:store_keeper_app/widgets/component/search_bar.dart';
import 'package:store_keeper_app/widgets/component/product_card.dart';
import 'package:store_keeper_app/data/products_data.dart';
import 'package:store_keeper_app/models/store_models.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filter products based on search query
    final filteredProducts = products.where((Product product) {
      return _searchQuery.isNotEmpty &&
          product.productName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
        'Search Products',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        )),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SearchBarWidget(
              hintText: 'Search Products...',
              onchanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 10),
            // Show products only when user types
            if (_searchQuery.isNotEmpty)
              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ProductCard(
                            imageUrl: product.imageUrl ?? '',
                            productName: product.productName,
                            price: product.price,
                            quantity: product.quantity,
                            productId: product.id,
                            isLast: index == filteredProducts.length - 1,
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
