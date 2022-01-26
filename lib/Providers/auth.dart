import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/app_user.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var userdata = AppUser('', '');

  Future register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = _auth.currentUser;
      print(user!.email);
    } on FirebaseException catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = _auth.currentUser;
    } on FirebaseException catch (e) {
      print(e.toString());
      return e;
    }
  }

  // AppUser getUser() {
  //   getUserDetails();
  //   print(userdata.name);
  //   return userdata;
  // }

  // Future<void> getUserDetails() async {
  //   final List<AppUser> loadedProducts = [];
  //   var url =
  //       'https://fluttermanageassetapp-default-rtdb.asia-southeast1.firebasedatabase.app/user.json';
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     print(json.decode(response.body));

  //     if (json.decode(response.body) != null) {
  //       final extractedData =
  //           json.decode(response.body) as Map<String, dynamic>;

  //       int num = 0;
  //       extractedData.forEach((prodNo, prodData) {
  //         loadedProducts.add(AppUser(
  //           prodData['userName'],
  //           prodData['userPosition'],
  //         ));
  //         if (num == 0) {
  //           userdata = loadedProducts[num];
  //           print(userdata.name);
  //         }
  //       });
  //     }
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

  Future logout() async {
    try {
      return await _auth.signOut();
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  Future<void> addUser(String name, String position) async {
    final url =
        'https://fluttermanageassetapp-default-rtdb.asia-southeast1.firebasedatabase.app/user.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'userName': name,
          'userPosition': position,
        }),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
