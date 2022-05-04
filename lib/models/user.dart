class UserData {
  late String _userId;
  late String _userName;
  late String _userEmail;
  late int _userCreatedDate;

  UserData({
    required String userId,
    required int userCreatedDate,
    required String userName,
    required String userEmail,
  }) {
    _userId = userId;
    _userCreatedDate = userCreatedDate;
    _userName = userName;
    _userEmail = userEmail;
  }

  factory UserData.fromMap(Map data) {
    return UserData(
      userId: data['userId'],
      userName: data['userName'],
      userCreatedDate: data['userCreatedDate'],
      userEmail: data['userEmail'],
    );
  }

  String get userId {
    return _userId;
  }

  String get userName {
    return _userName;
  }

  String get userEmail {
    return _userEmail;
  }
}
