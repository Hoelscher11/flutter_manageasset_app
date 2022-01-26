import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/asset.dart';

class ManageAsset with ChangeNotifier {
  List<Asset> items = [];
  late String fbAssetId;
  var asset = Asset(
      asset_no: '',
      asset_name: '',
      asset_date_registered: '',
      asset_status: '',
      asset_location: '');

  Future<void> getAllAssets(String position) async {
    final List<Asset> loadedProducts = [];
    var url =
        'https://fluttermanageassetapp-default-rtdb.asia-southeast1.firebasedatabase.app/assets.json';
    try {
      final response = await http.get(Uri.parse(url));
      print(json.decode(response.body));

      if (json.decode(response.body) != null) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;

        int num = 0;
        String code;
        extractedData.forEach((prodNo, prodData) {
          if (position == 'Staff' &&
              prodData['asset_status'] == 'Depreciated') {
            num += 1;
            return;
          } else {
            if (prodData['asset_status'] == 'Depreciated') {
              code = 'D-';
            } else {
              code = 'X-';
            }
            loadedProducts.add(Asset(
              asset_no: code + num.toString(),
              asset_name: prodData['asset_name'],
              asset_date_registered: prodData['asset_date_registered'],
              asset_status: prodData['asset_status'],
              asset_location: prodData['asset_location'],
            ));
            num += 1;
          }
        });
      } else {
        print('Oh jeng');
      }
    } catch (error) {
      throw (error);
    }
    items = loadedProducts;
    notifyListeners();
  }

  Future<void> getAssetDetails(int id) async {
    final List<Asset> loadedProducts = [];
    var url =
        'https://fluttermanageassetapp-default-rtdb.asia-southeast1.firebasedatabase.app/assets.json';
    try {
      final response = await http.get(Uri.parse(url));
      print(json.decode(response.body));

      if (json.decode(response.body) != null) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;

        int num = 0;
        extractedData.forEach((prodNo, prodData) {
          loadedProducts.add(Asset(
            asset_no: 'X-' + num.toString(),
            asset_name: prodData['asset_name'],
            asset_date_registered: prodData['asset_date_registered'],
            asset_status: prodData['asset_status'],
            asset_location: prodData['asset_location'],
            // isFavorite: prodData['isFavorite'],
          ));
          if (num == id) {
            asset = loadedProducts[num];
            fbAssetId = prodNo;
          }
          num += 1;
        });
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(String assetName, String assetDate,
      String assetStatus, String assetLocation) async {
    final url =
        'https://fluttermanageassetapp-default-rtdb.asia-southeast1.firebasedatabase.app/assets.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'asset_no': '',
          'asset_name': assetName,
          'asset_date_registered': assetDate,
          'asset_status': assetStatus,
          'asset_location': assetLocation,
        }),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(int id, String assetName, String assetStatus,
      String assetLocation) async {
    final prodIndex = id;
    if (prodIndex >= 0) {
      final url =
          'https://fluttermanageassetapp-default-rtdb.asia-southeast1.firebasedatabase.app/assets/$fbAssetId.json';
      await http.patch(Uri.parse(url),
          body: jsonEncode({
            //'asset_name': newProduct.asset_name,
            'asset_no': 'X-' + id.toString(),
            'asset_name': assetName,
            'asset_status': assetStatus,
            'asset_location': assetLocation,
          }));
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(
      int id, String assetName, String assetLocation) async {
    final exProdIndex = id;
    if (exProdIndex >= 0) {
      final url =
          'https://fluttermanageassetapp-default-rtdb.asia-southeast1.firebasedatabase.app/assets/$fbAssetId.json';
      await http.patch(Uri.parse(url),
          body: jsonEncode({
            //'asset_name': newProduct.asset_name,
            'asset_no': 'D-' + id.toString(),
            'asset_name': assetName,
            'asset_status': "Depreciated",
            'asset_location': assetLocation,
          }));
    } else {
      print('...');
    }
  }
}
