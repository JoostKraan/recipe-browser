import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  var db = FirebaseFirestore.instance;
  late var recipes = db.collection('recipes');

  readAllData(String path) async {
    final ref = db.collection(path);
    final snapshot = await ref.get();
    return snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
  }

  createRecipe(
    String name,
    String cookingTime,
    String description,
    String link,
    List<String> tags,
    String category,
    int servings,
    double cooktimeRating,
    String creator,
    String lastUpdated,
    String lastUpdatedBy,
  ) async {
    final data = <String, dynamic>{
      "name": name,
      "cooking_time": cookingTime, //total cooking time in minutes including prep
      "description": description, //quick summary of recipe
      "link": link, //optional link to source of recipe like Albert heijn recipes
      "tags": tags, //vegetarian,vegan,light meal, hefty meal
      "category": category, //breakfast, lunch, dinner
      "servings": servings, //default serving amount per person
      "cooktime_rating": cooktimeRating, //1-5
      "creator": creator, //user that created the recipe
      "last_updated": lastUpdated,
      "last_updated_by": lastUpdatedBy,
    };
    db
        .collection('recipes')
        .add(data)
        .then(
          (documentSnapshot) =>
              print("Added Data with ID: ${documentSnapshot.id}"),
        );
    return await readAllData('recipes');
  }

  deleteRecipe(String path, String id) async {
    db
        .collection(path)
        .doc(id)
        .delete()
        .then(
          (doc) => print("Document deleted id: $id"),
          onError: (e) => print("Error updating document $e"),
        );
    return await readAllData('recipes');
  }
}
