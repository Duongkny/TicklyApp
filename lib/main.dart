import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

bool isInitializedFirebase = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tickly',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tickly'),
        ),
        body: const Center(
          child: Text('Welcome to Tickly!'),
        ),
      ),
    );
  }
}
