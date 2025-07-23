import 'package:cloud_firestore/cloud_firestore.dart';

class TagService {
  var db = FirebaseFirestore.instance;


  void createTag(String name) async {
    final ref = db.collection("tags").doc(name);
    final doc = await ref.get();
    if (doc.exists){
      print("tag already exists");
    }
    else{
      db.collection("tags").doc(name).set({"name": name});
      print("created tag called $name");
    }
  }
  void assignTagsToRecipe(List<String> tags,String recipe){
    final recipeRef = db.collection("recipes").doc(recipe);
    recipeRef.update({'tags' : FieldValue.arrayUnion(tags)});
  }
  void removeTagFromRecipe(List<String> tags, String recipe){
    final recipeRef = db.collection("recipes").doc(recipe);
    recipeRef.update({'tags' : FieldValue.arrayRemove(tags)});
  }

}