import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/collage/colleges.dart';
import 'package:flutter_application_1/features/course/courses.dart';
import 'package:flutter_application_1/features/dashboard/dashboard.dart';
import 'package:flutter_application_1/features/interests/interests.dart';
import 'package:flutter_application_1/features/stream/streams.dart';
import 'package:flutter_application_1/features/university/universities.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../common_widget/custom_drawer.dart';
import 'login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(
          milliseconds: 100,
        ), () {
      User? currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null || currentUser.appMetadata['role'] != 'admin') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });

    _tabController = TabController(
      length: 6,
      vsync: this,
      initialIndex: 0,
    );
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: CustomDrawer(
        tabController: _tabController,
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Dashboard(),
          Universities(),
          Collages(),
          Courses(),
          Streams(),
          Interests(),
        ],
      ),
    );
  }
}
