import 'package:flutter/material.dart';
import 'package:store_keeper_app/widgets/component/product_form.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show File, Platform;
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data'; 
import 'package:flutter/foundation.dart';
import 'dart:math'; 
import 'package:store_keeper_app/utils/route_generator.dart' ;
import 'package:store_keeper_app/models/store_models.dart' ;


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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();

    // Generate random product ID
    _productId = _generateRandomId();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  String _generateRandomId() {
    final random = Random();
    final number = random.nextInt(100000); // random number up to 99999
    return 'pre$number';
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

// Global list to store products (replace with DB later)
final List<Map<String, Object?>> products = [];

void _saveProduct() {
  if (_formKey.currentState!.validate()) {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

    final newProduct = {
      "id": _productId,
      "name": name,
      "price": price,
      "quantity": quantity,
      "image": _selectedImage ?? _selectedImageBytes, // can be null
    };

    _updateDatabase(newProduct);

    if (_selectedImage == null && _selectedImageBytes == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Please select a product image")),
  );
  return;
}


    // Navigate to Product Screen using the product ID and prevent back navigation
    Navigator.of(context, rootNavigator: true).pushReplacementNamed(
      RouteGenerator.product,
      arguments: _productId,
    );
  }
}

void _updateDatabase(Map<String, Object?> data) {
  // Add to the in-memory product list
  products.add(data);
  debugPrint("Product created: $data");
  debugPrint("All products: $products");
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
