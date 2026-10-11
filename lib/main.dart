import 'package:flutter/material.dart';
import 'package:tickly/src/constants/environment.dart';

import 'package:tickly/src/core/firebase/firebase_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Environment.initialize();
  await FirebaseProvider.initialize();
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
