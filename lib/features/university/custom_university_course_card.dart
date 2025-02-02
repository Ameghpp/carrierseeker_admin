import 'package:flutter/material.dart';

import '../../common_widget/custom_button.dart';

class CustomUniversityCourseCard extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final Function() onEdit, onDelete, onDetail;

  const CustomUniversityCourseCard({
    super.key,
    required this.name,
    required this.description,
    required this.image,
    required this.onEdit,
    required this.onDelete,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 4,
      child: SizedBox(
        width: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.orange,
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                  CustomButton(
                    onPressed: onDetail,
                    label: 'Details',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
