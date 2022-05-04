import 'package:flutter/material.dart';
import 'package:mini_mvp/services/auth_service.dart';
import 'package:mini_mvp/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/user.dart';

class AuthStreamBuilder extends StatelessWidget {
  AuthStreamBuilder({this.builder});

  final Widget Function(BuildContext, AsyncSnapshot)? builder; //<User?>

  @override
  Widget build(BuildContext context) {
    print('AuthWidgetBuilder rebuild');
    return StreamBuilder(
      stream: context.read<AuthenticationService>().authStateChanges,
      builder: (context, Snapshot) {
        return MultiProvider(
            providers: [
              Provider<UserDataService>(
                create: (_) =>
                    UserDataService(userId: context.read<AuthenticationService>().userIdGetter),
              ),
            ],
            child: StreamBuilder(
                stream: UserDataService(userId: context.read<AuthenticationService>().userIdGetter)
                    .userData,
                builder: (context, userSnap) {
                  switch (userSnap.connectionState) {
                    case ConnectionState.active:
                      if (userSnap.hasData) {
                        return Provider<UserData>.value(
                          value: userSnap.data as UserData,
                          child: builder!(context, Snapshot as AsyncSnapshot<User?>),
                        );
                      }

                      return builder!(context, Snapshot as AsyncSnapshot<User?>);
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.done:
                    default:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                  }
                }));
      },
    );
  }
}
