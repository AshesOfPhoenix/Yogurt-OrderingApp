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
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
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
              Container(
                height: 500,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Pending order",
                          style: TextStyle(
                              color: THEME_COLOR,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, left: 15, right: 15),
                      child: Container(
                        decoration: new BoxDecoration(
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: new Offset(1.0, 2.0),
                                blurRadius: 5.0,
                              )
                            ],
                            color: WHITE,
                            borderRadius: new BorderRadius.all(Radius.circular(12))),
                        height: 110,
                        width: 100,
                        child: Padding(
                          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0, top: 8.0),
                        child: Text(
                          "Completed orders",
                          style: TextStyle(
                              color: THEME_COLOR,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, left: 15, right: 15),
                      child: Container(
                        decoration: new BoxDecoration(
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: new Offset(1.0, 2.0),
                                blurRadius: 5.0,
                              )
                            ],
                            color: WHITE,
                            borderRadius: new BorderRadius.all(Radius.circular(12))),
                        height: 110,
                        width: 100,
                        child: Padding(
                          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
