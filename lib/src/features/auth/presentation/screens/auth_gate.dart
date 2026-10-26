import 'package:tickly/src/core/extensions/context.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.signedIn,
    required this.signedOut,
    this.unverified,
  });

  final Widget signedIn;
  final Widget signedOut;
  final Widget? unverified;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text(context.loc.authCheckFailed)),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return signedOut;
        }

        // Nếu app yêu cầu xác minh email:
        // giữ lại luồng Verify Email đang có.
        if (!user.emailVerified && unverified != null) {
          return unverified!;
        }

        return signedIn;
      },
    );
  }
}
