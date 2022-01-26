import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_manageasset_app/Providers/manage_asset.dart';
import 'package:flutter_manageasset_app/screens/asset_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AssetEditorScreen extends StatefulWidget {
  static const routeName = 'asset-editor-screen';

  @override
  State<AssetEditorScreen> createState() => _AssetEditorScreenState();
}

class _AssetEditorScreenState extends State<AssetEditorScreen> {
  var _isInit = true;
  var _isLoading = false;
  String? assetStatus;
  String? assetLocation;

  TextEditingController assetName = TextEditingController();
  String assetDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  late String fbProductId;
  late String productId;

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

  void didChangeDependencies() {
    // Will run after the widget fully initialise but before widget build

    if (_isInit) {
      // for the first time..!!
      setState(() {
        _isLoading = true;
      });

      productId = ModalRoute.of(context)!.settings.arguments as String;

      Provider.of<ManageAsset>(context, listen: false)
          .getAssetDetails(int.parse(productId))
          .then((_) {
        setState(() {
          _isLoading = false;
          assetName.text =
              Provider.of<ManageAsset>(context, listen: false).asset.asset_name;
          assetStatus = Provider.of<ManageAsset>(context, listen: false)
              .asset
              .asset_status;
          assetLocation = Provider.of<ManageAsset>(context, listen: false)
              .asset
              .asset_location;
        });
      });

      print(assetName.text);
      print(assetStatus);
      print(assetLocation);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Asset'),
        backgroundColor: Colors.redAccent,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                                icon: Icon(Icons.update),
                                onPressed: () {
                                  if (Provider.of<ManageAsset>(context,
                                              listen: false)
                                          .asset
                                          .asset_name ==
                                      '') {
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
                                    //asset.asset_name = assetName as String;
                                    Provider.of<ManageAsset>(context,
                                            listen: false)
                                        .updateProduct(
                                            int.parse(productId),
                                            assetName.text,
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
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AssetOverviewScreen.routeName,
                                    (_) => false,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 20),
                            CircleAvatar(
                              backgroundColor: Colors.red,
                              child: IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Confirm Delete ?'),
                                      content:
                                          Text('Your data will be deleted.'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Yes'),
                                          onPressed: () {
                                            Provider.of<ManageAsset>(context,
                                                    listen: false)
                                                .deleteProduct(
                                                    int.parse(productId),
                                                    assetName.text,
                                                    assetLocation.toString());
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              AssetOverviewScreen.routeName,
                                              (_) => false,
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  );
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
