import 'package:flutter/material.dart';
import 'package:flutter_manageasset_app/Models/app_user.dart';
import 'package:flutter_manageasset_app/Models/asset.dart';
import 'package:flutter_manageasset_app/Providers/current_user.dart';
import 'package:flutter_manageasset_app/Providers/manage_asset.dart';
import 'package:flutter_manageasset_app/widgets/asset_summary.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/asset.dart';
import '../screens/asset_add_screen.dart';
import '../Providers/auth.dart';
import '../screens/auth_screen.dart';

class AssetOverviewScreen extends StatefulWidget {
  static const routeName = 'asset-overview-screen';

  @override
  State<AssetOverviewScreen> createState() => _AssetOverviewScreenState();
}

class _AssetOverviewScreenState extends State<AssetOverviewScreen> {
  final Auth _auth = Auth();

  var _isInit = true;
  var _isLoading = false;

  void didChangeDependencies() {
    // Will run after the widget fully initialise but before widget build

    if (_isInit) {
      // for the first time..!!

      setState(() {
        _isLoading = true;
      });

      print('getting user details...');
      //_getUserNameAndPosition();
      String userposition = context.watch<CurrentUser>().currentUser.position;

      Provider.of<ManageAsset>(context, listen: false)
          .getAllAssets(userposition)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  String _selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Asset Management App'),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          (context.watch<CurrentUser>().currentUser.position == 'Manager')
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AssetAddScreen.routeName);
                  },
                  icon: const Icon(Icons.add),
                ),
          IconButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Log Out'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: const <Widget>[
                      Text('Are you sure you want to log out?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Log Out'),
                    onPressed: () async {
                      await _auth.logout();
                      Navigator.pushNamedAndRemoveUntil(
                          context, AuthScreen.routeName, (_) => false);
                    },
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: 600,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 80,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 50,
                          //color: Colors.blue,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20),
                          child: CircleAvatar(
                            child: Image.network(
                                'https://i.pinimg.com/originals/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.png'),
                            radius: 25,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 230,
                          padding: EdgeInsets.only(top: 10, bottom: 5),
                          //color: Colors.blue,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${context.watch<CurrentUser>().currentUser.name}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${context.watch<CurrentUser>().currentUser.position}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 450,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 20,
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          child: Text(
                            'Asset List',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Container(
                          height: 370,
                          child: ListView(
                            padding: const EdgeInsets.all(10),
                            children: context
                                .watch<ManageAsset>()
                                .items
                                .map(
                                  (assetData) => AssetSummary(
                                      assetData.asset_no,
                                      assetData.asset_name,
                                      assetData.asset_status,
                                      assetData.asset_date_registered,
                                      assetData.asset_location),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text('Copyright 2021'),
                  ),
                ],
              ),
            ),
    );
  }
}
