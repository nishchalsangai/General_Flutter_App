import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_mvp/services/user_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  bool _newUserStatus = false;

  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed In";
    } on FirebaseAuthException catch (ex) {
      if (ex.code == "user-not-found") {
        return "User is not registered";
      } else if (ex.code == "wrong-password") {
        return "Password provided is wrong";
      } else {
        return ex.message;
      }
    }
  }

  Future<String?> signUp(
      {required String userName, required String userEmail, required String userPassword}) async {
    try {
      final userDetails = await _firebaseAuth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);
      final user = userDetails.user!;
      await UserDataService(userId: user.uid)
          .addNewUser(userId: user.uid, userName: userName, userEmail: userEmail);
      _newUserStatus = true;
      return "Signed Up";
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String? get userIdGetter {
    return _firebaseAuth.currentUser?.uid;
  }

  String? get userEmailGetter {
    return _firebaseAuth.currentUser?.email;
  }

  bool get newUserStatusGetter {
    return _newUserStatus;
  }

  void userNotNew() {
    _newUserStatus = false;
  }
}
