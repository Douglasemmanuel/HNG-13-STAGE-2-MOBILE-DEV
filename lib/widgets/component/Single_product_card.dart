import 'package:flutter/material.dart';
import 'package:store_keeper_app/utils/route_generator.dart';

class SingleProductCard extends StatelessWidget {
  final String productName;
  final double price;
  final int quantity;
  final String productId;
  final bool isLast;
  final VoidCallback? onTap;
  final String? image; // ✅ changed from Uint8List? to String?

  const SingleProductCard({
    super.key,
    required this.image,
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
      onTap: () => _openProduct(context, productId),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImage(context, image),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Handle image as a String (file path or URL)
  Widget _buildImage(BuildContext context, String? imagePath) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: imagePath != null && imagePath.isNotEmpty
          ? _loadImage(imagePath)
          : Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[200],
              child: const Icon(Icons.image, size: 50),
            ),
    );
  }

  /// ✅ Decide whether to load from network or file path
  Widget _loadImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      // Network image
      return Image.network(
        imagePath,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    } else {
      // Local file image (e.g. /storage/emulated/0/Download/pic.jpg)
      return Image.asset(
        imagePath,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
  }

  Widget _placeholder() {
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, size: 50),
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
              label: '₦${price.toStringAsFixed(2)}',
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
    IconData? icon,
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

  void _openProduct(BuildContext context, String id) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      RouteGenerator.product,
      arguments: id,
    );
  }
}
