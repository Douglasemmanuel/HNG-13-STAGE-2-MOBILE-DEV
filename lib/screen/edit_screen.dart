
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:store_keeper_app/widgets/component/product_form.dart';
import 'package:store_keeper_app/services/database_provider.dart';
import 'package:store_keeper_app/utils/route_generator.dart';
import 'package:store_keeper_app/models/store_models.dart';

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
  String? _networkImageUrl;
  Uint8List? _selectedImageBytes; 

  final ImagePicker _picker = ImagePicker();
  final ProductServices _productServices = ProductServices();

  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _loadProductData(); 
    await Future.delayed(const Duration(seconds: 1)); 
    setState(() {
      _isLoading = false; 
    });
  }

  Future<void> _loadProductData() async {
    final product = await _productServices.getSingleProduct(widget.productId);
    if (product != null) {
      setState(() {
        _nameController.text = product.productName;
        _priceController.text = product.price.toString();
        _quantityController.text = product.quantity.toString();
        _networkImageUrl = product.image;
        _selectedImage = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product not found")),
      );
    }
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
  void _updateProduct() async {
    final imageString = _networkImageUrl ?? '';

    final product = Product(
      id: widget.productId,
      productName: _nameController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      quantity: int.tryParse(_quantityController.text.trim()) ?? 0,
      image: imageString,
      createdAt: DateTime.now(), 
    );

    await _productServices.updateProduct(product);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Product updated successfully!")),
    );

    Navigator.of(context, rootNavigator: true).pushNamed(
      RouteGenerator.product,
      arguments: widget.productId,
    );
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: ProductForm(
                formKey: _formKey,
                nameController: _nameController,
                priceController: _priceController,
                quantityController: _quantityController,
                onSave: _updateProduct,
                saveButtonLabel: "Edit Product",
                saveButtonIcon: Icons.edit,
                selectedImage: _selectedImage,
                networkImageUrl: _networkImageUrl,
                onPickCamera: () => _pickImage(fromCamera: true),
                onPickGallery: () => _pickImage(fromCamera: false),
              ),
            ),
    );
  }
}
