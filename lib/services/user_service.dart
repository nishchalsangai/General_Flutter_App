import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class UserDataService {
  late final String? userId;
  late CollectionReference users;

  UserDataService({String? userId}) {
    this.userId = userId;
    users = FirebaseFirestore.instance.collection('UserData');
  }

  Future<void> addNewUser({
    required String userId,
    required String userName,
    required String userEmail,
  }) async {
    try {
      await users.doc(userId).set({
        "userId": userId,
        "userName": userName,
        "userEmail": userEmail,
        "userCreatedDate": DateTime.now().millisecondsSinceEpoch,
      }).then((value) {
        print("User Added to the database");
      });
    } on FirebaseException catch (ex) {
      print(ex.message);
    }
  }

  Stream<UserData> get userData {
    return users.doc(userId).snapshots().map((event) {
      return UserData.fromMap(event.data() as Map<dynamic, dynamic>);
    });
  }
}
