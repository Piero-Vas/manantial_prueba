import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = fb.FirebaseAuth.instance.currentUser;
    if (user != null) {
      Future.microtask(
          () => Navigator.pushReplacementNamed(context, '/events'));
    } else {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/'));
    }
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
