import 'package:flutter/material.dart';

//its a floating searchbar
class PosSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final double top;
  final double left;
  final double right;

  const PosSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.top = 10,
    this.left = 16,
    this.right = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: SearchBar(
        backgroundColor: WidgetStateProperty.all(Colors.blueGrey[50]),
        controller: controller,
        padding: const WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16.0),
        ),
        onChanged: onChanged,
        leading: const Icon(Icons.search),
      ),
    );
  }
}
