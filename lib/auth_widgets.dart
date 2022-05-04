import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_mvp/managers/home_manager.dart';
import 'package:mini_mvp/managers/sign_in_sign_up_manager.dart';
import 'package:mini_mvp/screens/home_screen.dart';
import 'package:mini_mvp/screens/login_screen.dart';
import 'package:mini_mvp/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthWidgets extends StatelessWidget {
  final AsyncSnapshot<dynamic> userSnapshot;

  AuthWidgets({required this.userSnapshot});

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      final firebaseUser = context.watch<AuthenticationService>().userIdGetter;
      if (firebaseUser != null) {
        return ChangeNotifierProvider(
            create: (_) => HomeManager(firebaseUser), child: const HomeScreen());
      } else {
        return ChangeNotifierProvider(
            create: (_) => CredentialsManager(), child: const LogInScreen());
      }
    }
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
