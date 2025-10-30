


import 'package:flutter/material.dart';
import 'package:store_keeper_app/models/store_models.dart';
import 'package:store_keeper_app/utils/route_generator.dart';
import 'package:store_keeper_app/services/database_provider.dart' ;
import 'dart:convert';
import 'dart:io' show File;
import 'package:flutter/foundation.dart';

class ProductScreen extends StatefulWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Product? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() => isLoading = true);
    try {
      final fetchedProduct =
          await ProductServices().getSingleProduct(widget.productId);
      setState(() {
        product = fetchedProduct;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product not found")),
      );
    }
  }

  Future<void> _deleteProduct() async {
    if (product == null) return;

    await ProductServices().deleteProduct(product!.id.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product!.productName} deleted")),
    );

    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      RouteGenerator.initial,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text("Product not found")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          product!.productName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              RouteGenerator.initial,
              (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (product?.image != null && product!.image!.isNotEmpty)
      ? Image.file(
          File(product!.image!),
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        )
      : Container(
          width: 300,
          height: 300,
          color: Colors.grey[300],
          child: const Icon(Icons.image, color: Colors.white, size: 50),
        ),
                    const SizedBox(height: 12),
                    Text(
                      product!.productName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₦${product!.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Quantity: ${product!.quantity}",
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Edit Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      RouteGenerator.editproduct,
                      arguments: widget.productId,
                    );
                  },
                  icon: const Icon(
                    Icons.edit, color: Colors.white ,
                    size: 24.0,
                    ),
                  label: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: const Color(0xFF1E3A8A),
                  ),
                ),
              
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text(
                          "Confirm Delete" ,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                          ),
                          ),
                        content: Text(
                          "Are you sure you want to delete ${product!.productName}?",
                           style: TextStyle(
                            fontSize: 16.0,
                            
                          ),
                          ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              _deleteProduct();
                            },
                            child: const Text(
                              "Yes, Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete, 
                    color: Colors.white ,
                     size: 24.0,
                    ),
                  label: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  

}
