// lib/widgets/search_bar.dart
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final ValueChanged<String>? onFieldSubmitted;

  CustomSearchBar({
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: onSubmitted,
              ),
            ],
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
