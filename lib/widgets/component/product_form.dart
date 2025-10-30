
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'dart:io' show File, Platform; // only safe if not on web
// for web image bytes

class ProductForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final VoidCallback onSave;
  final String saveButtonLabel;
  final IconData saveButtonIcon;
  final String? networkImageUrl;


  final File? selectedImage; // mobile
  final Uint8List? selectedImageBytes; // web
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;

  const ProductForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.priceController,
    required this.quantityController,
    required this.onSave,
    required this.saveButtonLabel,
    required this.saveButtonIcon,
    this.selectedImage,
    this.selectedImageBytes,
    required this.onPickCamera,
    required this.onPickGallery,
      this.networkImageUrl,
  });

  @override
  Widget build(BuildContext context) {


Widget displayImage() {
  if (selectedImage != null) {
    return Image.file(selectedImage!, fit: BoxFit.cover);
  } else if (selectedImageBytes != null) {
    return Image.memory(selectedImageBytes!, fit: BoxFit.cover);
  } else if (networkImageUrl != null && networkImageUrl!.isNotEmpty) {
    return Image.asset(networkImageUrl!, fit: BoxFit.cover);
  } else {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.image, size: 60, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            "No Image Selected",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}



    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(child: displayImage()),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Row(
                      children: [
                        FloatingActionButton(
                          mini: true,
                          heroTag: 'camera_or_file',
                          onPressed: onPickCamera,
                          child: Icon(
                            kIsWeb || !(Platform.isAndroid || Platform.isIOS)
                                ? Icons.attach_file
                                : Icons.camera_alt,
                          ),
                        ),
                        const SizedBox(width: 8),
                        FloatingActionButton(
                          mini: true,
                          heroTag: 'gallery',
                          onPressed: onPickGallery,
                          child: const Icon(Icons.photo_library),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Product Name
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Product Name",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter product name';
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Price
          TextFormField(
            controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: "Price",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter price';
              final number = double.tryParse(value);
              if (number == null || number <= 0) return 'Enter a valid price';
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Quantity
          TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Quantity",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter quantity';
              final number = int.tryParse(value);
              if (number == null || number < 0) return 'Enter a valid quantity';
              return null;
            },
          ),
          const SizedBox(height: 24),
          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onSave,
              icon: Icon(saveButtonIcon, color: Colors.white),
              label: Text(
                saveButtonLabel,
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
                backgroundColor: const Color(0xFF1E3A8A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



