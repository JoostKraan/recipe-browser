import 'package:cloud_firestore/cloud_firestore.dart';

class IngredientsService {
  var db = FirebaseFirestore.instance;
  final String path = 'ingredients';

  createIngredient(String name, String unit) {
    db.collection(path).doc(name).set({
      "name": name,
      "unit": unit,
    });
    print("Created new Ingredient $name : $unit");
  }
  deleteIngredient(String id){
    db.collection(path).doc(id).delete();
    print("deleted ingredient : $id");
  }

  Future<void> assignIngredientToRecipe(String recipe,
      String ingredientId,
      double quantity,) async {
    final ingredientRef = db.collection(path).doc(ingredientId);

    await db.collection("recipes").doc(recipe).update({
      path: FieldValue.arrayUnion([
        {
          "ingredient_ref": ingredientRef,
          "quantity": quantity,
        }
      ])
    });
  }

  Future<void> removeIngredientById(String recipe, String ingredientId) async {
    final recipeRef = db.collection("recipes").doc(recipe);
    final snapshot = await recipeRef.get();

    if (!snapshot.exists) return;

    final ingredients = List<Map<String, dynamic>>.from(
        snapshot.data()?[path] ?? []);

    ingredients.removeWhere((ing) {
      final ref = ing["ingredient_ref"] as DocumentReference;
      return ref.id == ingredientId;
    });

    await recipeRef.update({path: ingredients});

  }
  Future<List<String>> readIngredientsOfRecipe(String recipeId) async {
    final recipeSnapshot = await db.collection("recipes").doc(recipeId).get();
    final recipeData = recipeSnapshot.data();

    final ingredientsList = recipeData?["ingredients"] as List<dynamic>? ?? [];

    List<String> ingredientNames = [];

    for (var ing in ingredientsList) {
      try {
        final quantity = ing["quantity"];
        final ingredientRef = ing["ingredient_ref"] as DocumentReference;
        final ingredientDoc = await ingredientRef.get();
        if (ingredientDoc.exists) {
          final ingredientData = ingredientDoc.data() as Map<String, dynamic>;
          final name = ingredientData["name"];
          final unit = ingredientData["unit"];

          ingredientNames.add("$quantity$unit $name");
        }
      } catch (e) {
        print("Error reading ingredient: $e");
        continue;
      }
    }
    return ingredientNames;
  }
  Future<List<Ingredient>> readAllIngredients() async {
    final ref = db.collection(path);
    final snapshot = await ref.get();
    return snapshot.docs
        .map((doc) => Ingredient.fromMap(doc.data()))
        .toList();
  }

}
class Ingredient {
  final String name;
  final String unit;

  Ingredient({required this.name, required this.unit});

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map["name"] ?? "",
      unit: map["unit"] ?? "-",
    );
  }
}