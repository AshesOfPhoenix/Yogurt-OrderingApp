import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Orders extends StatefulWidget {
  static const String routeName = "/orders";
  final FirebaseUser user;

  Orders(this.user);

  @override
  _OrdersState createState() => _OrdersState(user: user);
}

class _OrdersState extends State<Orders> {
  FirebaseUser user;
  _OrdersState({this.user});
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
                  "Orders",
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
