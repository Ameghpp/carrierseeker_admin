import 'package:flutter/material.dart';

import '../../common_widget/custom_button.dart';

class CustomUniversityCard extends StatelessWidget {
  final String logoUrl;
  final String coverImageUrl;
  final String name;
  final String address;
  final Function() onEdit, onDelete, onDetails;

  const CustomUniversityCard({
    super.key,
    required this.logoUrl,
    required this.coverImageUrl,
    required this.name,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onDetails,
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
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    coverImageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(logoUrl),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          address,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    onPressed: onDetails,
                    label: "Details",
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
