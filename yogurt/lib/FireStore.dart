import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

final Firestore yogurts = Firestore.instance; 
final Firestore users = Firestore.instance;

Stream items; //!Stream for items
Stream userData; //!Stream for userData

class FetchFromFirestore{

  Future<Query> queryItems() async {
    //!Fetch items
    Query query;
    try {
      Query query = yogurts.collection('current_items').where("available", isEqualTo: true);
      //!Filter available izdelke
      //*QuerySnapshot contains zero or more QueryDocumentSnapshot objects representing the results of a query
      
    } catch (e) {
      print("Got error: ${e.error}");
    }
    return query;
  }

  

  Future<Stream> queryUserData(String userID) async {
    //!Fetch userData
    try {
      Query query2 = users.collection('users').where("uid", isEqualTo: userID); //!Users
      userData = query2.snapshots().map((list) {
        return list.documents.map((doc) {
          return doc.data;
        });
      });
    } catch (e) {
      print("Got error: ${e.error}");
    }
    return userData;
  }
}

class UserData{
  FirebaseUser user;
  UserData(this.user);
  final Firestore users = Firestore.instance;
  Stream userData;
  Color themeColor;
  
  

  Future<QuerySnapshot> queryUserData() async {
    //!Fetch userData
    try {
      Future<QuerySnapshot> userDataQuery = users.collection('users').where("uid", isEqualTo: user.uid).getDocuments(); //!Users
      return userDataQuery;
    } catch (e) {
      print("Got error: ${e.error}");
    }
  }

  
}