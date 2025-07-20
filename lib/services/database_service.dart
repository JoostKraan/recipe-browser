import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  var db = FirebaseFirestore.instance;
  late var recipes = db.collection('recipes');

  readAllData (String path) async {
    final ref = db.collection(path);
    final snapshot = await ref.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  createRecipe (String name,String cookingTime){
    final data = <String,dynamic>{
      "name" : name,
      "cooking_time" : cookingTime,
    };
    db.collection('recipes').add(data).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
  }



}
