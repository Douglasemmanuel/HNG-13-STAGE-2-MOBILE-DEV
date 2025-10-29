import 'package:flutter/material.dart';
import 'package:store_keeper_app/utils/route_generator.dart' ;

class SingleProductCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final double price;
  final int quantity;
  final String productId;
  final bool isLast;
  final VoidCallback? onTap;

  const SingleProductCard({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.productId,
    this.isLast = false,
    this.onTap,
  });

  @override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () => _products(context, productId), // navigate on tap
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImage(context),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildContent(context),
          ),
        ],
      ),
    ),
  );
}


Widget _buildImage(BuildContext context) {
  return ClipRRect(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    child: Image.asset(
      imageUrl,
      height: 150, 
      width: double.infinity, 
      fit: BoxFit.cover, 
    ),
  );
}

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoChip(
              label:'₦${price.toStringAsFixed(2)}',
              color: Colors.blue,
            ),
            const SizedBox(width: 8),
            _buildInfoChip(
              icon: Icons.inventory_2,
              label: quantity.toString(),
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }
Widget _buildInfoChip({
  IconData? icon, // now optional
  required String label,
  required Color color,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (icon != null) ...[
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
      ],
      Text(
        label,
        style: TextStyle(
          fontSize: 20,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}



}
void _products(BuildContext context, String id) {
  Navigator.of(context, rootNavigator: true).pushNamed(
          RouteGenerator.product, 
          arguments: id 
                    );
}