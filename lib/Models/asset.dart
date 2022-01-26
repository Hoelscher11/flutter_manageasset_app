import 'package:flutter/material.dart';

class Asset {
  final String asset_no;
  final String asset_name;
  final String asset_date_registered;
  final String asset_status;
  final String asset_location;

  const Asset(
      {required this.asset_no,
      required this.asset_name,
      required this.asset_date_registered,
      required this.asset_status,
      required this.asset_location});
}
