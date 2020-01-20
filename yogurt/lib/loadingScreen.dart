import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:yogurt/authentication.dart';
import 'Colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yogurt/images.dart';
import 'package:path_provider/path_provider.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/loading";

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  //!final Firestore instance = Firestore.instance;
  Map<String, String> fileNames = <String, String>{};
  final FirebaseAuth _auth = FirebaseAuth.instance;

  

  Stream<FirebaseUser> get user{
    return _auth.onAuthStateChanged;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    FilterIfAvailable() //!klici metodo za filtriranje items ki pretvori Firestore.instance v QuerySnapshot
        .getImages()
        .then((QuerySnapshot docs) async {
      if (docs.documents.isNotEmpty) {
        //!preveri ce list ni prazen
        Directory tempDir = Directory.systemTemp; //!pridobi začasni directory
        for (var i = 0; i < docs.documents.length; i++) {
          //!l!oopa skozi izdelke
          var item = docs.documents[i].data; //!dodeli izdelek v variable
          fileNames[item['ime']] = item['file_name'];
          await FilterIfAvailable().cacheFile(docs, tempDir, item); //! Prebran data zapiši v file
        }
      }
    }).catchError((e) {
      print("Got error: ${e.error}");
    });
    print(fileNames);
    return new Timer(Duration(seconds: 5), onDoneLoading); //!Call function after 5 seconds
  }

  onDoneLoading() async {
    Navigator.of(context) //!Push to Home page
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: THEME_COLOR,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/yogurtIcon.png'),
              height: 60,
              width: 60,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
