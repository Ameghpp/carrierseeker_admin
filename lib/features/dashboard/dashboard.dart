import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: 20,
      runSpacing: 20,
      children: [
        DashboardItem(
          iconData: Icons.apartment,
          label: "Total Collage",
          value: '4468',
        ),
        DashboardItem(
          iconData: Icons.apartment,
          label: "Total Collage",
          value: '4468',
        ),
        DashboardItem(
          iconData: Icons.apartment,
          label: "Total Collage",
          value: '4468',
        ),
        DashboardItem(
          iconData: Icons.apartment,
          label: "Total Collage",
          value: '4468',
        ),
      ],
    );
  }
}

class DashboardItem extends StatelessWidget {
  final String label, value;
  final IconData iconData;
  const DashboardItem({
    super.key,
    required this.label,
    required this.value,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.red,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(
              width: 40,
            ),
            Icon(iconData),
          ],
        ),
      ),
    );
  }
}
