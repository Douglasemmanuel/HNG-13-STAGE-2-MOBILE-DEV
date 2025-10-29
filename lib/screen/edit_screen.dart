import 'package:flutter/material.dart';
import 'package:store_keeper_app/widgets/component/product_form.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:store_keeper_app/data/products_data.dart';
import 'package:store_keeper_app/models/store_models.dart' ;
import 'package:store_keeper_app/utils/route_generator.dart' ;


class EditScreen extends StatefulWidget {
  final String productId;

  const EditScreen({super.key, required this.productId});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  File? _selectedImage;
  Uint8List? _selectedImageBytes;
  String? _networkImageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    // Simulate fetching data from database using widget.productId
    // Replace with actual DB/API call
    final productData = await _fetchProductById(widget.productId);

    setState(() {
      _nameController.text = productData['name'] ?? '';
      _priceController.text = productData['price']?.toString() ?? '';
      _quantityController.text = productData['quantity']?.toString() ?? '';
      _networkImageUrl = productData['imageUrl']; // e.g., network image URL
    });
  }
Future<Map<String, dynamic>> _fetchProductById(String id) async {
  await Future.delayed(const Duration(milliseconds: 200)); // optional: simulate delay

  final product = products.firstWhere(
    (p) => p.id == id,
    orElse: () => Product(
      id: '',
      productName: '',
      price: 0,
      quantity: 0,
      imageUrl: '',
    ),
  );

  return {
    'name': product.productName,
    'price': product.price,
    'quantity': product.quantity,
    'imageUrl': product.imageUrl, // this is an asset path
  };
}


  Future<void> _pickImage({required bool fromCamera}) async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedImageBytes = result.files.first.bytes;
          _selectedImage = null;
          _networkImageUrl = null;
        });
      }
    } else {
      final XFile? picked = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
          _selectedImageBytes = null;
          _networkImageUrl = null;
        });
      }
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
      final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

      if (_selectedImage == null && _selectedImageBytes == null && _networkImageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a product image")),
        );
        return;
      }

      final productData = {
        "name": name,
        "price": price,
        "quantity": quantity,
        "image": _selectedImage ?? _selectedImageBytes ?? _networkImageUrl,
      };

      debugPrint("Updated product: $productData");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product updated successfully!")),
      );
      Navigator.of(context, rootNavigator: true).pushNamed(
      RouteGenerator.product, 
      arguments: widget.productId, 
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edit Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: ProductForm(
          formKey: _formKey,
          nameController: _nameController,
          priceController: _priceController,
          quantityController: _quantityController,
          onSave: _saveProduct,
          saveButtonLabel: "Edit Product",
          saveButtonIcon: Icons.edit,
          selectedImage: _selectedImage,
          networkImageUrl: _networkImageUrl,
          selectedImageBytes: _selectedImageBytes,
          onPickCamera: () => _pickImage(fromCamera: true),
          onPickGallery: () => _pickImage(fromCamera: false),
          // Pass network image URL to displayImage inside ProductForm
        ),
      ),
    );
  }
}
