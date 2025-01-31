import 'package:flutter/material.dart';

import '../../common_widget/custom_button.dart';

class Collages extends StatelessWidget {
  const Collages({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCollageCard(
          coverImageUrl:
              'https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg',
          name: "Collage",
          address: "address",
        ),
      ],
    );
  }
}

class CustomCollageCard extends StatelessWidget {
  final String coverImageUrl;
  final String name;
  final String address;

  const CustomCollageCard({
    super.key,
    required this.coverImageUrl,
    required this.name,
    required this.address,
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
                coverImageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
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
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    onPressed: () {},
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
