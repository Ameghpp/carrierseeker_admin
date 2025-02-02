import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/format_function.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../util/check_login.dart';
import 'dashboard_bloc/dashboard_bloc.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map _dashboard = {};

  final DashboardBloc _dashboardBloc = DashboardBloc();

  @override
  void initState() {
    checkLogin(context);
    getDashboard();
    super.initState();
  }

  void getDashboard() {
    _dashboardBloc.add(GetAllDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _dashboardBloc,
      child: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getDashboard();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is DashboardGetSuccessState) {
            _dashboard = state.dashboard;
            Logger().w(_dashboard);
            setState(() {});
          } else if (state is DashboardSuccessState) {
            getDashboard();
          }
        },
        builder: (context, state) {
          return Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: [
              DashboardItem(
                iconData: Icons.apartment,
                label: "Total Users",
                value: formatInteger(_dashboard['users_count']),
              ),
              DashboardItem(
                iconData: Icons.apartment,
                label: "Total Universities",
                value: formatInteger(_dashboard['universities_count']),
              ),
              DashboardItem(
                iconData: Icons.apartment,
                label: "Total Collage",
                value: formatInteger(_dashboard['colleges_count']),
              ),
              DashboardItem(
                iconData: Icons.apartment,
                label: "Total Stream",
                value: formatInteger(_dashboard['streams_count']),
              ),
              DashboardItem(
                iconData: Icons.apartment,
                label: "Total Interests",
                value: formatInteger(_dashboard['interests_count']),
              ),
            ],
          );
        },
      ),
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
