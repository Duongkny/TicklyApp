
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthRefreshNotifier extends ChangeNotifier {
  AuthRefreshNotifier() {
    _subscription = FirebaseAuth.instance.userChanges().listen(
      (user) {
        _user = user;
        _isReady = true;

        notifyListeners();
      },
      onError: (Object error) {
        _isReady = true;
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<User?> _subscription;

  User? _user;
  bool _isReady = false;

  // Getter để AppRouter sử dụng.
  User? get user => _user;

  bool get isReady => _isReady;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
