import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Text(
              'Welcome to Tickly!',
            ),
            Text(
              'Please log in to continue.',
            ),
          ],
        ),
      ),
    );
  }
}