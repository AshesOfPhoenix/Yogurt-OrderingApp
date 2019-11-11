import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Settings extends StatefulWidget {
  static const String routeName = "/settings";
  final FirebaseUser user;

  Settings(this.user);

  @override
  _SettingsState createState() => _SettingsState(user: user);
}

class _SettingsState extends State<Settings> {
  FirebaseUser user;
  _SettingsState({this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: WHITE,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                  "Settings",
                  style: TextStyle(fontSize: 40, fontFamily: 'MadeEvolveSans'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
