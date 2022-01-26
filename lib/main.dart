import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_manageasset_app/Providers/current_user.dart';
import 'package:flutter_manageasset_app/Providers/manage_asset.dart';
import 'package:flutter_manageasset_app/screens/asset_editor_screen.dart';
import 'package:flutter_manageasset_app/screens/asset_overview_screen.dart';
import 'package:flutter_manageasset_app/screens/auth_screen.dart';
import 'screens/asset_add_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentUser()),
        ChangeNotifierProvider(create: (_) => ManageAsset()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AuthScreen(),
      ),
      routes: {
        AssetOverviewScreen.routeName: (ctx) => AssetOverviewScreen(),
        AssetEditorScreen.routeName: (ctx) => AssetEditorScreen(),
        AssetAddScreen.routeName: (ctx) => AssetAddScreen(),
        AuthScreen.routeName: (ctx) => AuthScreen(),
      },
    );
  }
}
