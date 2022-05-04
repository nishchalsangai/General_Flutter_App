import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import '../globals/mixins/validate_mixins.dart';
import '../globals/size_config.dart';
import '../globals/theme/app_theme.dart';
import '../managers/sign_in_sign_up_manager.dart';

class LogInScreen extends StatelessWidget with ValidateMixin {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<CredentialsManager>(builder: (context, credentialsManager, child) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: credentialsManager.credKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: const AssetImage("assets/images/hello.png"),
                      fit: BoxFit.contain,
                      height: SizeConfig.safeBlockVertical! * 30,
                      width: SizeConfig.safeBlockHorizontal! * 30,
                    ),
                    credentialsManager.registerScreen ? userNameHandler() : const SizedBox(),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical! * 2,
                    ),
                    emailHandler(),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical! * 2,
                    ),
                    passwordHandler(),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical! * 3,
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                              colors: [AppTheme.primaryColor, AppTheme.accentColor])),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0),
                        onPressed: () => credentialsManager.registerScreen
                            ? credentialsManager.SignUp(context)
                            : credentialsManager.SignIn(context),
                        child: Text(credentialsManager.registerScreen ? "REGISTER" : "SIGN IN"),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical! * 1.5,
                    ),
                    orDivider(),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical! * 1.5,
                    ),
                    TextButton(
                        onPressed: () {
                          credentialsManager.switchRegisterScreen();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              credentialsManager.registerScreen
                                  ? "Switch back to "
                                  : "New to the app? ",
                              style: GoogleFonts.openSans(
                                  fontSize: 12,
                                  color: AppTheme.headingColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              credentialsManager.registerScreen ? "Log in" : "Register here!",
                              style: GoogleFonts.openSans(
                                  fontSize: 12,
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  SizedBox orDivider() {
    return SizedBox(
        child: Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            "OR",
            style: GoogleFonts.openSans(
                fontSize: 12, color: AppTheme.headingColor, fontWeight: FontWeight.w600),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    ));
  }

  userNameHandler() {
    return Consumer<CredentialsManager>(builder: (context, credentialsManager, child) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: TextFormField(
          keyboardType: TextInputType.text,
          validator: usernameValidator,
          controller: credentialsManager.username,
          style: GoogleFonts.openSans(
              fontSize: 14, color: AppTheme.headingColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            hintText: 'Full Name',
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppTheme.primaryColor)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            hintStyle: GoogleFonts.openSans(
                fontSize: 14, color: AppTheme.headingColor, fontWeight: FontWeight.w600),
            prefixIcon: const Icon(
              Icons.person,
              color: AppTheme.primaryColor,
            ),
            suffixIcon: const Icon(
              Icons.lock,
              color: AppTheme.primaryColor,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintMaxLines: 1,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            errorStyle: const TextStyle(fontSize: 12.0),
          ),
        ),
      );
    });
  }

  emailHandler() {
    return Consumer<CredentialsManager>(builder: (context, credentialsManager, child) {
      return Container(
        /* width: SizeConfig.safeBlockHorizontal! * 90,*/
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: credentialsManager.email,
          validator: emailValidator,
          style: GoogleFonts.openSans(
              fontSize: 14, color: AppTheme.headingColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            hintText: 'Email',
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppTheme.primaryColor)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            hintStyle: GoogleFonts.openSans(
                fontSize: 14, color: AppTheme.headingColor, fontWeight: FontWeight.w600),
            prefixIcon: const Icon(
              Icons.email_rounded,
              color: AppTheme.primaryColor,
            ),
            suffixIcon: const Icon(
              Icons.lock,
              color: AppTheme.primaryColor,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintMaxLines: 1,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            errorStyle: const TextStyle(fontSize: 12.0),
          ),
        ),
      );
    });
  }

  passwordHandler() {
    return Consumer<CredentialsManager>(builder: (context, credentialsManager, child) {
      return Container(
        /*  width: SizeConfig.safeBlockHorizontal! * 90,*/
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: TextFormField(
          validator: passwordValidator,
          controller: credentialsManager.password,
          obscureText: credentialsManager.isPasswordVisible,
          style: GoogleFonts.openSans(
              fontSize: 14, color: AppTheme.headingColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            focusColor: AppTheme.primaryColor,
            filled: true,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppTheme.primaryColor)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            hintStyle: GoogleFonts.openSans(
                fontSize: 14, color: AppTheme.headingColor, fontWeight: FontWeight.w600),
            prefixIcon: const Icon(
              Icons.verified_user,
              color: AppTheme.primaryColor,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintMaxLines: 1,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            errorStyle: const TextStyle(fontSize: 12.0),
            suffixIcon: IconButton(
              color: AppTheme.primaryColor,
              icon: credentialsManager.isPasswordVisible
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
              onPressed: () => credentialsManager.changePasswordVisibility(),
            ),
            hintText: "Password",
          ),
        ),
      );
    });
  }
}
