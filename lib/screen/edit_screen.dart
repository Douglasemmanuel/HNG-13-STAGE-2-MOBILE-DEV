import 'package:flutter/material.dart';

class EditScreen extends StatelessWidget {
  final  String productId ;
  const EditScreen({super.key , required this.productId});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Text(' Edit Product'),
        ),
      ),
    );
  }
}