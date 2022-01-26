import 'package:flutter_manageasset_app/Models/asset.dart';
import 'package:intl/intl.dart';

const DATA = const [
  Asset(
    asset_no: '1-1',
    asset_name: 'Van 1',
    asset_date_registered: '12-12-2022',
    //asset_date_registered: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    asset_status: 'Active',
    asset_location: 'Johor',
  ),
  Asset(
    asset_no: '1-2',
    asset_name: 'Lori 1',
    asset_date_registered: '10-09-2022',
    //asset_date_registered: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    asset_status: 'Active',
    asset_location: 'Selangor',
  ),
  Asset(
    asset_no: '1-3',
    asset_name: 'Lori 2',
    asset_date_registered: '24-04-2019',
    //asset_date_registered: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    asset_status: 'Inactive',
    asset_location: 'Melaka',
  ),
  Asset(
    asset_no: '1-4',
    asset_name: 'Van 2',
    asset_date_registered: '01-05-2018',
    //asset_date_registered: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    asset_status: 'Inactive',
    asset_location: 'Kedah',
  ),
  Asset(
    asset_no: '1-5',
    asset_name: 'Van 3',
    asset_date_registered: '12-04-2020',
    //asset_date_registered: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    asset_status: 'Active',
    asset_location: 'Kelantan',
  ),
  Asset(
    asset_no: '1-6',
    asset_name: 'Van 4',
    asset_date_registered: '07-05-2016',
    //asset_date_registered: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    asset_status: 'Active',
    asset_location: 'Perlis',
  ),
];
