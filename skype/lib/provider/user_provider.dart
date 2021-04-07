import 'package:flutter/cupertino.dart';
import 'package:skype/models/user.dart';
import 'package:skype/resourses/Auth_methods.dart';
import 'package:skype/resourses/Auth_methods.dart';

class UserProvider with ChangeNotifier{
  User _user;
  AuthMethods _authMethods= AuthMethods();
  User get getUser=>_user;
  Future<void> refreshUser() async{
User user = await _authMethods.getUserDetails();
_user=user;
notifyListeners();
  }
}