import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini_mvp/globals/theme/custom_theme.dart';
import 'package:mini_mvp/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'auth_stream.dart';
import 'auth_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
      ],
      child: AuthStreamBuilder(builder: (context, userSnapshot) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: CustomTheme.mainTheme,
          home: AuthWidgets(
            userSnapshot: userSnapshot,
          ),
        );
      }),
    );
  }
}
