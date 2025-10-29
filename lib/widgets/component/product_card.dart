import 'package:flutter/material.dart';
import 'package:store_keeper_app/utils/route_generator.dart' ;
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final double price;
  final int quantity;
  final String productId;
  final bool isLast;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.productId,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast ?
          BorderSide.none
          :
          BorderSide(
            color: Colors.grey, // Color of the bottom border
            width: 1, // Thickness of the bottom border
          ),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "₦${price.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                quantity.toString(),
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      RouteGenerator.product, 
                      arguments: productId   
                    );
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),

             
            ],
          ),
        ],
      ),
    );
  }
}
