import 'dart:async';

import 'package:flutter/material.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _authSubscription;
  late final StreamSubscription<dynamic> _signupSubscription;

  GoRouterRefreshStream(
      Stream<dynamic> authStream, Stream<dynamic> signupStream) {
    notifyListeners();
    _authSubscription = authStream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );

    _signupSubscription = signupStream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _signupSubscription.cancel();
    super.dispose();
  }
}
