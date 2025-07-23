import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeService {
  var db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>>readAllData(String path) async {
    final ref = db.collection(path);
    final snapshot = await ref.get();
    return snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
  }
  Future<Map<String, dynamic>?> readRecipe(String id) async  {
    final ref = db.collection("recipes").doc(id);
    final doc = await ref.get();
    if (doc.exists) {
      return {
        "id": doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>>createRecipe(
      { String name = 'No name entered',
        String cookingTime = '0m',
        String description = 'N/A',
        String? link = 'N/A',
        String? image = 'null',
        List<String>? tags,
        String? category = 'N/A',
        int? servings = 0,
        String? cooktimeRating = 'N/A',
        double? rating = 0.0,
        String? creator = 'N/A',
        DateTime? lastUpdated,
        String? lastUpdatedBy = 'N/A'
      }
      ) async {
    final data = <String, dynamic>{
      "name": name,
      "cooking_time": cookingTime, //total cooking time in minutes including prep
      "description": description, //quick summary of recipe
      "link": link, //optional link to source of recipe like Albert heijn recipes
      "image": image, //thumbnail image of recipe
      "tags": tags, //vegetarian,vegan,light meal, hefty meal
      "category": category, //breakfast, lunch, dinner
      "servings": servings, //default serving amount per person
      "cooktime_rating": cooktimeRating, //1-5
      "rating" : rating,
      "creator": creator, //user that created the recipe
      "last_updated": lastUpdated,
      "last_updated_by": lastUpdatedBy,
    };
    db
        .collection('recipes').doc(name)
        .set(data);
    return await readAllData('recipes');
  }

  deleteRecipe(String id) async {
    db
        .collection('recipes')
        .doc(id)
        .delete()
        .then(
          (doc) => print("Document deleted id: $id"),
          onError: (e) => print("Error updating document $e"),
        );
    return await readAllData('recipes');
  }
}
