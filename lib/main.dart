import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/login/login_screen.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://eotxxxnstghrdmexufzv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVvdHh4eG5zdGdocmRtZXh1Znp2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI4NTcxNDIsImV4cCI6MjA0ODQzMzE0Mn0.g0LY5Uv80SEP-pb1i-6fv5p3VPC04LxiPbXH1C0Y0EY',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: appTheme,
      home: const LoginScreen(),
    );
  }
}
