import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FilterIfAvailable {
  getImages() {
    //!Metoda za filtriranje documents v current_items collection-u
    return Firestore.instance //!vrni firestore instance
        .collection("current_items")
        .where("available", isEqualTo: true) //!kjer je izdelek available == true
        .getDocuments(); //!pridobi documents, kateri so tipa QuerySnapshots
  }

  Future cacheFile(QuerySnapshot docs, Directory tempDir, Map<String, dynamic> item) async {
    String imageName = item['file_name']; //!pridobi ime slike
    String iconName = item['ico_name']; //!pridobi ime ikone
    
    final File file = File('${tempDir.path}/$imageName'); //!save IMAGE
    final File fileIco = File('${tempDir.path}/$iconName'); //!save ICO
    
    //fileNames[item['ime']] = item['file_name']; //!dodaj path do slik v mapo
    
    (await file.exists()) //!preveri če slika obstaja
        ? print("$imageName že obstaja") //!če obstaja izpiše da obstaja
        : FirebaseStorage.instance //!drugace pa se enkrat naloži
            .ref()
            .child("items") //!Search items folder on Firebase Storage
            .child(imageName)
            .writeToFile(file);
    
    (await fileIco.exists()) //!preveri če slika obstaja
        ? print("$iconName že obstaja") //!če obstaja izpiše da obstaja
        : FirebaseStorage.instance //!drugace pa se enkrat naloži
            .ref()
            .child("icons") //!Search icons folder on Firebase Storage
            .child(iconName)   //!Prebrano ime iz baze
            .writeToFile(fileIco); //! Prebran data zapiši v file
  }
}
