import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_mvp/services/auth_service.dart';
import 'package:provider/provider.dart';

class CredentialsManager extends ChangeNotifier {
  TextEditingController username = TextEditingController();
  final GlobalKey<FormState> credKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isPasswordVisible = true;
  bool autoValidate = false;
  double passwordStrength = 0;
  bool disableButton = false;
  bool registerScreen = false;

  CredentialsManager() {}

  switchRegisterScreen() {
    registerScreen = !registerScreen;
    notifyListeners();
  }

  changePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  switchButtonVisibility() {
    disableButton = !disableButton;
    notifyListeners();
  }

  SignIn(BuildContext context) {
    try {
      final isValid = credKey.currentState!.validate();
      if (email.text.toLowerCase().isEmpty || password.text.isEmpty) {
        showInSnackBar(context, "Fields are empty");
      } else if (isValid) {
        switchButtonVisibility();
        context
            .read<AuthenticationService>()
            .signIn(
              email: email.text.trim(),
              password: password.text.trim(),
            )
            .then((value) {
          switchButtonVisibility();
          showInSnackBar(context, value);
        });
      }
    } catch (ex) {
      print(ex);
      switchButtonVisibility();
    }
  }

  SignUp(BuildContext context) {
    try {
      final isValid = credKey.currentState!.validate();
      if (isValid) {
        switchButtonVisibility();
        context.read<AuthenticationService>().signUp(
              userEmail: email.text.toLowerCase().trim(),
              userPassword: password.text.trim(),
              userName: username.text,
            );
        switchButtonVisibility();
      }
    } catch (ex) {
      print(ex);
      switchButtonVisibility();
    }
  }

  void showInSnackBar(BuildContext context, String? val) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        val ?? "Try Again!",
        style: GoogleFonts.openSans(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    ));
  }
}
