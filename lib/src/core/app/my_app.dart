import 'package:flutter/material.dart';
import 'package:tickly/src/features/auth/presentation/screens/auth_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: const AuthScreen(),
    );
  }
}

