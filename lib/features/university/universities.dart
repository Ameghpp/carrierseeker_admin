import 'package:flutter/material.dart';
import 'package:flutter_application_1/common_widget/custom_button.dart';

import 'custom_university_card.dart';

class Universities extends StatelessWidget {
  const Universities({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1320),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Universities",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
                CustomButton(
                  label: "Add University",
                  iconData: Icons.add,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: List.generate(
                  10,
                  (index) => CustomUniversityCard(
                    logoUrl:
                        'https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg',
                    coverImageUrl:
                        'https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg',
                    name: "Collage",
                    address: "address",
                    onEdit: () {},
                    onDelete: () {},
                    onDetails: () {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
