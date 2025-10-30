


import 'package:flutter/material.dart';
import 'package:store_keeper_app/widgets/component/product_form.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show File, Platform;
import 'package:file_picker/file_picker.dart';
import 'dart:convert'; 
import 'package:flutter/foundation.dart';
import 'package:store_keeper_app/utils/route_generator.dart';
import 'package:store_keeper_app/models/store_models.dart';
import 'package:store_keeper_app/services/database_provider.dart'; 
import 'package:uuid/uuid.dart'; 

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  File? _selectedImage; // mobile
  Uint8List? _selectedImageBytes; // web

  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  late String _productId;

  final ProductServices _productServices = ProductServices(); // <-- use sqflite service
  final Uuid _uuid = const Uuid(); // <-- UUID generator

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    _productId = _uuid.v4(); // Generate UUID
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
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
        });
      }
    }
  }

  Future<void> _saveProduct() async {
  if (!_formKey.currentState!.validate()) return;

  final name = _nameController.text.trim();
  final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
  final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

  // 🚫 No base64 conversion
  String? imagePath;
  Uint8List? imageBytes;

  if (_selectedImage != null) {
    imagePath = _selectedImage!.path; // store path (mobile)
  } else if (_selectedImageBytes != null) {
    imageBytes = _selectedImageBytes; // keep bytes (web)
  }

  setState(() => _isLoading = true);

  try {
    final product = Product(
      id: _productId,
      productName: name,
      price: price,
      quantity: quantity,
      image: imagePath ?? '', // ✅ store path, not base64
      createdAt: DateTime.now(),
      // If your model supports bytes, you can add another field for web here.
    );

    await _productServices.addProduct(product);

    // Reset form
    _nameController.clear();
    _priceController.clear();
    _quantityController.clear();

    setState(() {
      _selectedImage = null;
      _selectedImageBytes = null;
      _productId = _uuid.v4();
      _isLoading = false;
    });

    Navigator.of(context, rootNavigator: true).pushReplacementNamed(
      RouteGenerator.product,
      arguments: product.id,
    );
  } catch (e) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to save product: $e")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Create Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: ProductForm(
                formKey: _formKey,
                nameController: _nameController,
                priceController: _priceController,
                quantityController: _quantityController,
                onSave: _saveProduct,
                saveButtonLabel: "Create Product",
                saveButtonIcon: Icons.add,
                selectedImage: _selectedImage,
                selectedImageBytes: _selectedImageBytes,
                onPickCamera: () => _pickImage(fromCamera: true),
                onPickGallery: () => _pickImage(fromCamera: false),
              ),
            ),
    );
  }
}
