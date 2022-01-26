import 'package:flutter/cupertino.dart';
import 'package:flutter_manageasset_app/Models/app_user.dart';

class CurrentUser with ChangeNotifier {
  AppUser currentUser = AppUser('', '');

  AppUser get getCurrentUser => currentUser;

  void changeUser(String name, String position) {
    currentUser = AppUser(name, position);
    notifyListeners();
  }

  watch() {}
}
