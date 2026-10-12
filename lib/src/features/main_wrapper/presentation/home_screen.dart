import 'package:flutter/material.dart';
import 'package:tickly/src/core/extensions/context.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Text(
        'HomeScreen hoạt động!',
        style: TextStyle(
          fontSize: 24,
          color: context.colorScheme.primary,
        ),
      ),
    ),
  );
}

}