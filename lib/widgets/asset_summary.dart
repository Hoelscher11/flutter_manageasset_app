import 'package:flutter/material.dart';
import 'package:flutter_manageasset_app/Providers/current_user.dart';
import 'package:flutter_manageasset_app/screens/asset_detail_screen.dart';
import 'package:provider/src/provider.dart';
import '../screens/asset_editor_screen.dart';

class AssetSummary extends StatefulWidget {
  final String asset_no;
  final String asset_name;
  final String asset_status;
  final String date_registered;
  final String asset_location;

  AssetSummary(this.asset_no, this.asset_name, this.date_registered,
      this.asset_status, this.asset_location);

  @override
  State<AssetSummary> createState() => _AssetSummaryState();
}

class _AssetSummaryState extends State<AssetSummary> {
  var _isInit = true;
  var _isLoading = false;
  void didChangeDependencies() {
    // Will run after the widget fully initialise but before widget build

    if (_isInit) {
      // for the first time..!!
      setState(() {
        _isLoading = true;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.redAccent,
          radius: 25,
          child: Text(
            widget.asset_no,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          widget.asset_name,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          widget.date_registered + ' (' + widget.asset_status + ')',
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        trailing: context.watch<CurrentUser>().currentUser.position == 'Manager'
            ? SizedBox.shrink()
            : CircleAvatar(
                backgroundColor: Colors.grey[100],
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pushNamed(AssetEditorScreen.routeName,
                        arguments: widget.asset_no.substring(2));
                  },
                ),
              ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AssetDetailScreen(
                widget.asset_no,
                widget.asset_name,
                widget.asset_status,
                widget.date_registered,
                widget.asset_location,
              ),
            ),
          );
        });
  }
}
