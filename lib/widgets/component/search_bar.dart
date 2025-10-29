
import 'package:flutter/material.dart';
class SearchBarWidget extends StatelessWidget {
  final String hintText ;
  final Function(String) onchanged ;
  const SearchBarWidget({
    super.key ,
    required this.hintText,
    required this.onchanged,
    });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onchanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(Icons.search),
        filled: true ,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(horizontal: 16 , vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none
        ),
      ),
    );
  }
}