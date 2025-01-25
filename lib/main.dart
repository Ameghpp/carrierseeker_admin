import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://supabase.com/dashboard/project/eotxxxnstghrdmexufzv',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVvdHh4eG5zdGdocmRtZXh1Znp2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI4NTcxNDIsImV4cCI6MjA0ODQzMzE0Mn0.g0LY5Uv80SEP-pb1i-6fv5p3VPC04LxiPbXH1C0Y0EY',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Image.network(
            'https://plus.unsplash.com/premium_photo-1681487732859-c2a780022063?q=80&w=2018&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Center(
            child: SizedBox(
                width: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "login",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: 'email'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            _obscureText = !_obscureText;
                            setState(() {});
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 42, 146, 230),
                        foregroundColor: const Color.fromARGB(255, 13, 13, 14),
                      ),
                      onPressed: () {},
                      child: Text('LOGIN'),
                    ),
                  ],
                )),
          ),
        ),
      ],
    ));
  }
}
