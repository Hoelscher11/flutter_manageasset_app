import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_manageasset_app/Models/app_user.dart';
import 'package:flutter_manageasset_app/Providers/auth.dart';
import 'package:flutter_manageasset_app/Providers/current_user.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import 'package:http/http.dart' as http;
import '../screens/asset_overview_screen.dart';
import 'dart:convert';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10),
              child: Center(
                child: Container(
                  width: 200,
                  height: 130,
                  /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                  child: Image.asset("assets/images/carlogo.png"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
              child: Center(
                child: Container(
                  width: 300,
                  height: 370,
                  /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                  child: AuthCard(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;

  final Auth _auth = Auth();

  String? selectedValue;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Map<String, String> _userData = {
    'name': '',
    'position': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Size> _heightAnimation;

  var user = AppUser('', '');
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 300,
        ));
    _heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    //implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_authMode == AuthMode.Login) {
      dynamic result = await _auth.login(
          _authData['email'].toString(), _authData['password'].toString());
      print('Result: ' + result.toString());

      var errorMessage = 'Authentication failed';
      if (result.toString().contains('email-exists')) {
        errorMessage = 'This email address is already in use.';
        _showErrorDialog(errorMessage);
      } else if (result.toString().contains('invalid-email')) {
        errorMessage = 'This is not a valid email address';
        _showErrorDialog(errorMessage);
      } else if (result.toString().contains('weak-password')) {
        errorMessage = 'This password is too weak.';
        _showErrorDialog(errorMessage);
      } else if (result.toString().contains('user-not-found')) {
        errorMessage = 'Could not find a user with that email.';
        _showErrorDialog(errorMessage);
      } else if (result.toString().contains('wrong-password')) {
        errorMessage = 'Invalid password.';
        _showErrorDialog(errorMessage);
      } else {
        print('User successfully logged in');
        var url =
            'https://fluttermanageassetapp-default-rtdb.asia-southeast1.firebasedatabase.app/user.json';
        try {
          final response = await http.get(Uri.parse(url));
          //print(json.decode(response.body));

          if (json.decode(response.body) != null) {
            final extractedData =
                json.decode(response.body) as Map<String, dynamic>;
            int num = 0;
            extractedData.forEach((prodNo, prodData) {
              if (prodData['userName'] == _userData['name']) {
                user = AppUser(prodData['userName'], prodData['userPosition']);
                Provider.of<CurrentUser>(context, listen: false)
                    .changeUser(prodData['userName'], prodData['userPosition']);
              }

              num += 1;
              print(num);
            });
          }
        } catch (error) {
          throw (error);
        }

        Navigator.pushNamedAndRemoveUntil(
            context, AssetOverviewScreen.routeName, (_) => false);
      }
    } else {
      dynamic result = await _auth.register(
          _authData['email'].toString(), _authData['password'].toString());

      _auth.addUser(
          _userData['name'].toString(), _userData['position'].toString());

      var errorMessage = 'Authentication failed';
      if (result.toString().contains('email-exists')) {
        errorMessage = 'This email address is already in use.';
        _showErrorDialog(errorMessage);
      } else if (result.toString().contains('invalid-email')) {
        errorMessage = 'This is not a valid email address';
        _showErrorDialog(errorMessage);
      } else if (result.toString().contains('weak-password')) {
        errorMessage = 'This password is too weak.';
        _showErrorDialog(errorMessage);
      } else if (result.toString().contains('user-not-found')) {
        errorMessage = 'Could not find a user with that email.';
        _showErrorDialog(errorMessage);
      } else if (result.toString().contains('wrong-password')) {
        errorMessage = 'Invalid password.';
        _showErrorDialog(errorMessage);
      } else {
        print('User successfully registered in');
        var url =
            'https://fluttermanageassetapp-default-rtdb.asia-southeast1.firebasedatabase.app/user.json';
        try {
          final response = await http.get(Uri.parse(url));
          //print(json.decode(response.body));

          if (json.decode(response.body) != null) {
            final extractedData =
                json.decode(response.body) as Map<String, dynamic>;
            int num = 0;
            extractedData.forEach((prodNo, prodData) {
              if (prodData['userName'] == _userData['name']) {
                user = AppUser(prodData['userName'], prodData['userPosition']);
                Provider.of<CurrentUser>(context, listen: false)
                    .changeUser(prodData['userName'], prodData['userPosition']);
              }

              num += 1;
              print(num);
            });
          }
        } catch (error) {
          throw (error);
        }

        Navigator.pushNamedAndRemoveUntil(
            context, AssetOverviewScreen.routeName, (_) => false);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        //height: _heightAnimation.value.height,
        constraints:
            //BoxConstraints(minHeight: _heightAnimation.value.height),
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (_authMode == AuthMode.Signup)
                  Row(
                    children: <Widget>[
                      CustomDropdownButton2(
                        hint: 'Select Position',
                        buttonWidth: 150,
                        dropdownItems: ['Staff', 'Manager'],
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _userData['position'] = value as String;
                            selectedValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value as String;
                    _userData['name'] = value.toString();
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value as String;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Colors.redAccent,
                    textColor: Theme.of(context).primaryTextTheme.button!.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Colors.redAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
