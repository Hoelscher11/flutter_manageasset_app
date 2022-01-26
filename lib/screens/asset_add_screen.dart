import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_manageasset_app/Providers/manage_asset.dart';
import 'package:flutter_manageasset_app/screens/asset_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AssetAddScreen extends StatefulWidget {
  static const routeName = 'asset-add-screen';
  @override
  State<AssetAddScreen> createState() => _AssetAddScreenState();
}

class _AssetAddScreenState extends State<AssetAddScreen> {
  String? assetStatus;
  String? assetLocation;

  var _state = [
    'Johor',
    'Kuala Lumpur',
    'Labuan',
    'Putrajaya',
    'Kedah',
    'Kelantan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Perak',
    'Perlis',
    'Pulau Pinang',
    'Sabah',
    'Selangor',
    'Sarawak',
    'Terengganu',
  ];

  TextEditingController assetName = TextEditingController();
  String assetDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Asset'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Asset Name',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10.0),
                      border: OutlineInputBorder(),
                    ),
                    controller: assetName,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Asset Status',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomDropdownButton2(
                    hint: 'Select Status',
                    buttonWidth: 150,
                    dropdownItems: ['Active', 'Inactive'],
                    value: assetStatus,
                    onChanged: (value) {
                      setState(() {
                        assetStatus = value as String;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Asset Location',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomDropdownButton2(
                    hint: 'Select Location',
                    buttonWidth: 150,
                    dropdownItems: _state,
                    value: assetLocation,
                    onChanged: (value) {
                      setState(() {
                        assetLocation = value as String;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.add),
                          onPressed: () {
                            if (assetName == '') {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('No data'),
                                  content: Text('Something went wrong.'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                    )
                                  ],
                                ),
                              );
                            } else {
                              Provider.of<ManageAsset>(context, listen: false)
                                  .addProduct(
                                      assetName.text,
                                      assetDate,
                                      assetStatus.toString(),
                                      assetLocation.toString());
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AssetOverviewScreen.routeName,
                                (_) => false,
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
