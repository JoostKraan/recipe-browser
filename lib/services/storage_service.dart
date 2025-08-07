import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService{
  final storageRef = FirebaseStorage.instance.ref();

  String getImage(Image image){
    final imagesRef = storageRef.child("recipe-thumbnails/$image");
    

  }
}