import 'package:breakthrough_apps_challenge/app/widgets/auth_widget.dart';
import 'package:breakthrough_apps_challenge/app/profile/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: TextTheme().copyWith(
          caption: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
      // home: ProfilePage(),
      home: AuthWidget(
        child: ProfilePage(),
      ),
    );
  }
}
