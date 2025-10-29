import 'package:flutter/material.dart';
import 'package:store_keeper_app/models/store_models.dart' ;
import 'package:store_keeper_app/data/products_data.dart' ;
import 'package:store_keeper_app/utils/route_generator.dart';
import 'package:store_keeper_app/providers/store_provider.dart';
class ProductScreen extends StatelessWidget {
   final  String productId ;
  const ProductScreen({super.key , required this.productId});
  Product getProductById(String id) {
    return products.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Product not found!'),
    );
  }
  @override
  Widget build(BuildContext context) {
     final product = getProductById(productId);
     return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
        product.productName ,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        )),
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
  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
  child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.imageUrl != null)
          Image.asset(
            product.imageUrl!,
            width: 250,   // Increased width
            height: 150,  // Increased height
            fit: BoxFit.cover,
          )
        else
          Container(
            width: 150,
            height: 150,
            color: Colors.grey[300],
            child: const Icon(Icons.image, color: Colors.white, size: 50),
          ),
        const SizedBox(height: 12),
        Text(
          product.productName,
          style: const TextStyle(
            fontSize: 18,
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
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\₦${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Quantity: ${product.quantity}",
                      style:
                          const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            
            ElevatedButton.icon(
              onPressed: () {
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Edit ${product.productName}")),
                );
                 Navigator.of(context, rootNavigator: true).pushNamed(
                      RouteGenerator.editproduct, 
                      arguments: productId     
                    );
              },
              // icon: const Icon(Icons.edit),
              label: Text(
                "Edit ${product.productName}" ,
                style: TextStyle(
                  color: Colors.white,
                ),
                ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
                backgroundColor: Color(0xFF1E3A8A),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}