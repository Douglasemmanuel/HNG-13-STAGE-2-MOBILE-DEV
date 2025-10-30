

import 'package:flutter/material.dart';
import 'package:store_keeper_app/widgets/component/search_bar.dart';
import 'package:store_keeper_app/widgets/component/product_card.dart';
import 'package:store_keeper_app/models/store_models.dart';
import 'package:store_keeper_app/services/database_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ProductServices _productServices = ProductServices();
  List<Product> _searchResults = [];
  String _searchQuery = '';
  bool _isLoading = false;
  bool _hasSearched = false;

  Future<void> _searchProducts(String query) async {
    if (query == _searchQuery && _hasSearched) return;

    setState(() {
      _isLoading = true;
      _searchQuery = query;
      _hasSearched = true;
    });

    
    final results = query.isNotEmpty
        ? await _productServices.searchProduct(query)
        : <Product>[];

   
    if (mounted) {
      setState(() {
        _isLoading = false;
        _searchResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showNoResults =
        !_isLoading && _hasSearched && _searchResults.isEmpty;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Search Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SearchBarWidget(
              hintText: 'Search Products...',
              onchanged: (value) {
                _searchProducts(value.trim());
              },
            ),
            const SizedBox(height: 10),
            if (_isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (showNoResults)
              const Expanded(
                child: Center(
                  child: Text(
                    'No products found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else if (!_hasSearched)
              const Expanded(
                child: Center(
                  child: Text(
                    'Type to search products',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final product = _searchResults[index];
                    return ProductCard(
                      image: product.image,
                      productName: product.productName,
                      price: product.price,
                      quantity: product.quantity,
                      productId: product.id,
                      isLast: index == _searchResults.length - 1,
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
