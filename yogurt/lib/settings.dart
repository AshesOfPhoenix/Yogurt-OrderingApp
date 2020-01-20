import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yogurt/authentication.dart';
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

  String deliveryLocation;
  String userID;

  bool orangeActive = false;
  bool blueActive = false;
  bool grayActive = false;

  @override
  void initState() {
    userID = user.uid;
    deliveryLocation = "FRI";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
                    "Settings",
                    style: TextStyle(fontSize: 40, fontFamily: 'MadeEvolveSans'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                          child: Text(
                            "Theme",
                            style: TextStyle(
                                color: THEME_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      Container(
                        decoration: new BoxDecoration(
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: new Offset(1.0, 2.0),
                              blurRadius: 5.0,
                            )
                          ],
                          color: WHITE,
                          //borderRadius: new BorderRadius.all(Radius.circular(12))
                        ),
                        height: 60,
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Color",
                                style: TextStyle(
                                    color: LIGHT_GRAY,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18),
                              ),
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      print("Orange color selected");
                                      setState(() {
                                        orangeActive = true;
                                        blueActive = false;
                                        grayActive = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: new BoxDecoration(
                                            color: THEME_COLOR,
                                            border: (orangeActive) ? Border.all(color: BLACK, width: 3.5) : null,
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular(30))),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      print("Blue color selected");
                                      setState(() {
                                        orangeActive = false;
                                        blueActive = true;
                                        grayActive = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: new BoxDecoration(
                                            color: THEME_COLOR_BLUE,
                                            border: (blueActive) ? Border.all(color: BLACK, width: 3.5) : null,
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular(30))),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      print("Gray color selected");
                                      setState(() {
                                        orangeActive = false;
                                        blueActive = false;
                                        grayActive = true;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: new BoxDecoration(
                                            color: LIGHT_GRAY,
                                            border: (grayActive) ? Border.all(color: BLACK, width: 3.5) : null,
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular(30))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 4),
                          child: Text(
                            "Account",
                            style: TextStyle(
                                color: THEME_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Change your username");
                          print("User ID: " + userID);
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: new Offset(1.0, 2.0),
                                blurRadius: 5.0,
                              )
                            ],
                            color: WHITE,
                            //borderRadius: new BorderRadius.all(Radius.circular(12))
                          ),
                          height: 60,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Username",
                                  style: TextStyle(
                                      color: LIGHT_GRAY,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                                Text(
                                  "Kristjan",
                                  style: TextStyle(
                                      color: LIGHT_GRAY,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Change your email");
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: new Offset(1.0, 2.0),
                                blurRadius: 5.0,
                              )
                            ],
                            color: WHITE,
                            //borderRadius: new BorderRadius.all(Radius.circular(12))
                          ),
                          height: 60,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      color: LIGHT_GRAY,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                                Text(
                                  "kristjan.krizman@gmail.com",
                                  style: TextStyle(
                                      color: LIGHT_GRAY,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Change your password");
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: new Offset(1.0, 2.0),
                                blurRadius: 5.0,
                              )
                            ],
                            color: WHITE,
                            //borderRadius: new BorderRadius.all(Radius.circular(12))
                          ),
                          height: 60,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Reset password",
                                  style: TextStyle(
                                      color: LIGHT_GRAY,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                                Text(
                                  "M****b******1",
                                  style: TextStyle(
                                      color: LIGHT_GRAY,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Delivery location: " + deliveryLocation);
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: new Offset(1.0, 2.0),
                                blurRadius: 5.0,
                              )
                            ],
                            color: WHITE,
                            //borderRadius: new BorderRadius.all(Radius.circular(12))
                          ),
                          height: 60,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  "Delivery Location",
                                  style: TextStyle(
                                      color: LIGHT_GRAY,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                                Container(
                                  child: Text(
                                    deliveryLocation,
                                    style: TextStyle(
                                        color: LIGHT_GRAY,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Signed out");
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Home()),
                              (Route<dynamic> route) => false);
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: new Offset(1.0, 2.0),
                                blurRadius: 5.0,
                              )
                            ],
                            color: WHITE,
                            //borderRadius: new BorderRadius.all(Radius.circular(12))
                          ),
                          height: 60,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Sign Out",
                                  style: TextStyle(
                                      color: LIGHT_GRAY,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 4),
                          child: Text(
                            "Support",
                            style: TextStyle(
                                color: THEME_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Being a good boy and donate");
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: new Offset(1.0, 2.0),
                                blurRadius: 5.0,
                              )
                            ],
                            color: WHITE,
                            //borderRadius: new BorderRadius.all(Radius.circular(12))
                          ),
                          height: 60,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Donate",
                                  style: TextStyle(
                                      color: LIGHT_GRAY,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                                Image.asset(
                                  "assets/pay_pal.png",
                                  height: 60,
                                  width: 80,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Contact support");
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: new Offset(1.0, 2.0),
                                blurRadius: 5.0,
                              )
                            ],
                            color: WHITE,
                            //borderRadius: new BorderRadius.all(Radius.circular(12))
                          ),
                          height: 60,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Contact Us",
                                  style: TextStyle(
                                      color: LIGHT_GRAY,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
