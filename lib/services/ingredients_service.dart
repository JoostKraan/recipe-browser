import 'package:cloud_firestore/cloud_firestore.dart';

class IngredientsService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final String path = 'ingredients';

  Future<void> createIngredient(String name, String unit) async {
    await db.collection(path).doc().set({
      'name': name,
      'unit': unit,
    });
    print('Created new Ingredient $name : $unit');
  }

  Future<void> deleteIngredient(String id) async {
    await db.collection(path).doc(id).delete();
    print('Deleted ingredient : $id');
  }

  /// Batch‐assigns multiple ingredients to a recipe in one update.
  Future<void> assignIngredientsToRecipe(
      String recipeId,
      List<Map<String, dynamic>> ingredients,
      ) async {
    final batchItems = ingredients.map((item) {
      final ref = db.collection(path).doc(item['id'] as String);
      return {
        'ingredient_ref': ref,
        'quantity': item['quantity'] as double,
      };
    }).toList();

    await db
        .collection('recipes')
        .doc(recipeId)
        .update({
      path: FieldValue.arrayUnion(batchItems),
    });
  }

  Future<void> removeIngredientById(
      String recipeId,
      String ingredientId,
      ) async {
    final recipeRef = db.collection('recipes').doc(recipeId);
    final snapshot = await recipeRef.get();

    if (!snapshot.exists) return;

    final ingredients = List<Map<String, dynamic>>.from(
      snapshot.data()?[path] ?? [],
    );

    ingredients.removeWhere((ing) {
      final ref = ing['ingredient_ref'] as DocumentReference;
      return ref.id == ingredientId;
    });

    await recipeRef.update({path: ingredients});
  }

  Future<List<String>> readIngredientsOfRecipe(String recipeId) async {
    final recipeSnapshot =
    await db.collection('recipes').doc(recipeId).get();
    final recipeData = recipeSnapshot.data();

    final ingredientsList =
        recipeData?[path] as List<dynamic>? ?? [];

    List<String> ingredientNames = [];

    for (var ing in ingredientsList) {
      try {
        final quantity = ing['quantity'];
        final ingredientRef = ing['ingredient_ref'] as DocumentReference;
        final ingredientDoc = await ingredientRef.get();
        if (ingredientDoc.exists) {
          final ingredientData =
          ingredientDoc.data() as Map<String, dynamic>;
          final name = ingredientData['name'];
          final unit = ingredientData['unit'];

          ingredientNames.add('$quantity$unit $name');
        }
      } catch (e) {
        print('Error reading ingredient: $e');
        continue;
      }
    }

    return ingredientNames;
  }

  Future<List<Ingredient>> readAllIngredients() async {
    final ref = db.collection(path);
    final snapshot = await ref.get();
    return snapshot.docs.map((doc) =>
        Ingredient.fromDoc(doc)
    ).toList();
  }
}

/// Model for Ingredient, now including Firestore document ID
class Ingredient {
  final String id;
  final String name;
  final String unit;

  Ingredient({
    required this.id,
    required this.name,
    required this.unit,
  });

  /// Create from a Firestore DocumentSnapshot
  factory Ingredient.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Ingredient(
      id: doc.id,
      name: data['name'] as String? ?? '',
      unit: data['unit'] as String? ?? '-',
    );
  }

  /// (Optional) Create from a raw map and provided ID
  factory Ingredient.fromMapWithId(
      String id,
      Map<String, dynamic> data,
      ) {
    return Ingredient(
      id: id,
      name: data['name'] as String? ?? '',
      unit: data['unit'] as String? ?? '-',
    );
  }
}
