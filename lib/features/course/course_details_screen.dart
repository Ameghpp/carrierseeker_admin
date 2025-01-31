import 'package:flutter/material.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/custom_chip.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1000,
          ),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.network(
                'https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg',
                height: 400,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Collage Name',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Address",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Interests",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ),
                  CustomButton(
                    label: "Add Interest",
                    iconData: Icons.add,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                children: [
                  CustomChip(
                    onTap: () {},
                    name: 'Data',
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Streams",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ),
                  CustomButton(
                    label: "Add Stream",
                    iconData: Icons.add,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                children: [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
