import 'package:flutter/material.dart';
import 'package:flutter_manageasset_app/Providers/current_user.dart';
import 'package:flutter_manageasset_app/screens/asset_editor_screen.dart';
import 'package:provider/src/provider.dart';

class AssetDetailScreen extends StatelessWidget {
  static const routeName = 'asset-detail-screen';

  final String asset_no;
  final String asset_name;
  final String asset_status;
  final String date_registered;
  final String asset_location;

  AssetDetailScreen(this.asset_no, this.asset_name, this.date_registered,
      this.asset_status, this.asset_location);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asset Detail'),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          (context.watch<CurrentUser>().currentUser.position == 'Manager')
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AssetEditorScreen.routeName,
                        arguments: asset_no.substring(2));
                  },
                  icon: Icon(Icons.edit)),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Padding(
            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AssetDetail('Asset Name', asset_name),
                AssetDetail('Asset Status', asset_status),
                AssetDetail('Asset No', asset_no),
                AssetDetail('Asset Location', asset_location),
                AssetDetail('Asset Registered', date_registered),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AssetDetail extends StatelessWidget {
  final String title;
  final String description;

  AssetDetail(this.title, this.description);

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title + ': ',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(width: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 17,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
