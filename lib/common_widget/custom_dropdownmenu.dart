import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatelessWidget {
  final TextEditingController? controller;
  final Function(dynamic selected) onSelected;
  final String hintText;
  final double width;
  final List<DropdownMenuEntry<dynamic>> dropdownMenuEntries;
  const CustomDropDownMenu({
    super.key,
    required this.hintText,
    required this.dropdownMenuEntries,
    this.width = 360,
    required this.onSelected,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      onSelected: onSelected,
      controller: controller,
      width: width,
      hintText: hintText,
      textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
      inputDecorationTheme: const InputDecorationTheme(filled: true),
      dropdownMenuEntries: dropdownMenuEntries,
    );
  }
}
