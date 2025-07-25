import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/components/add_ingredient_to_recipe_dialog.dart';
import 'package:recipe/components/svg_component.dart';
import 'package:recipe/providers/constants_provider.dart';
import 'package:recipe/services/ingredients_service.dart';
import 'package:recipe/services/recipe_service.dart';
import '../components/text_component.dart';

class Recipe extends StatefulWidget {

  final String id;
  final VoidCallback? onBack;

  const Recipe({super.key, required this.id, this.onBack});

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  late Future<Map<String, dynamic>?> _recipeFuture;
  late Future<List<String>> _ingredientsFuture;
  List<String> ingredientList = [];

  @override
  void initState() {
    super.initState();
    _recipeFuture = RecipeService().readRecipe(widget.id);
    _ingredientsFuture = IngredientsService().readIngredientsOfRecipe(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;

    return Scaffold(
      backgroundColor: constants.primaryColor,
      appBar: widget.onBack != null ? AppBar(
        backgroundColor: constants.secondaryColor,
        leading: IconButton(
          icon: BtrSvg(image: 'assets/icons/arrow-back.svg',color: Colors.white),
          onPressed: widget.onBack,
        ),
      ) : null,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Recipe not found"));
          }
          final recipe = snapshot.data!;
          return Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    Image.asset('assets/img/${recipe['image']}'),
                    Positioned(
                      top: 50,
                      right: 2,
                      child: Chip(
                        label: BtrText(text: recipe['rating'].toString()),
                        shape: StadiumBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: constants.specialColor,
                    border: BoxBorder.all(color: constants.specialColor),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),

                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 10),
                              child: BtrText(
                                text: recipe["name"],
                                fontSize: 30,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 10),
                              child: BtrText(
                                text: "| ${recipe["category"]}",
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 10),
                              child: BtrText(
                                text: "${recipe["cooking_time"]}",
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 10),
                              child: BtrText(
                                text: "${recipe["cuisine"]}",
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BtrText(text: "Ingrediënten"),
                            IconButton(
                              onPressed: () async {
                                final result = await showDialog(
                                  context: context,
                                  builder: (context) => IngredientToRecipeDialog(
                                    id: widget.id,
                                    ingredientList: ingredientList,
                                  ),
                                );

                                if (result != null) {
                                  setState(() {
                                    _ingredientsFuture = IngredientsService().readIngredientsOfRecipe(widget.id);
                                  });
                                }
                              },
                              icon: BtrSvg(
                                image: 'assets/icons/add.svg',
                                size: 30,
                                color: constants.accentColor,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            SizedBox(
                                width: MediaQuery.sizeOf(context).width - 2,
                                child: FutureBuilder<List<String>>(
                                  future: _ingredientsFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                      return const Center(child: BtrText(text: "No ingredients"));
                                    }

                                    final ingredients = snapshot.data!;

                                    // Update ingredient list when data changes
                                    if (ingredientList.length != ingredients.length ||
                                        !ingredientList.every((element) => ingredients.contains(element))) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (mounted) {
                                          setState(() {
                                            ingredientList = ingredients;
                                          });
                                        }
                                      });
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: ingredients.map((ingredient) {
                                          return BtrText(text: ingredient);
                                        }).toList(),
                                      ),
                                    );
                                  },
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}