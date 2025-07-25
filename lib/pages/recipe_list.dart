import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/pages/recipe.dart';

import '../components/add_recipe_dialog.dart';
import '../components/svg_component.dart';
import '../components/text_component.dart';
import '../providers/constants_provider.dart';
import '../services/recipe_service.dart';

class RecipeList extends StatefulWidget {
  final Function(String)? onRecipeSelected;

  const RecipeList({super.key, this.onRecipeSelected});

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  late Future<List<Map<String, dynamic>>> _recipesFuture;

  Future<List<Map<String, dynamic>>> _loadRecipes() async {
    return await RecipeService().readAllData('recipes');
  }

  @override
  void initState() {
    super.initState();
    _recipesFuture = _loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;
    return Scaffold(
      backgroundColor: constants.primaryColor,
      appBar: AppBar(
        backgroundColor: constants.secondaryColor,
        title: BtrText(text: 'Recepten'),
        actions: [
          IconButton(
            onPressed: () => context.read<ConstantsProvider>().toggleDarkMode(),
            icon: BtrSvg(
              image: context.read<ConstantsProvider>().isDarkMode
                  ? 'assets/icons/dark-mode.svg'
                  : 'assets/icons/light-mode.svg',
            ),
          ),
        ],
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: BtrText(text: 'No recipes found'));
          }
          final recipes = snapshot.data!;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final name = recipes[index]['name'];
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (widget.onRecipeSelected != null) {
                              widget.onRecipeSelected!(name);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Recipe(id: name),
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: constants.secondaryColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: BtrText(text: name),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final updatedRecipes = await RecipeService().deleteRecipe(
                          recipes[index]['id'],
                        );
                        setState(() {
                          _recipesFuture = Future.value(updatedRecipes);
                        });
                      },
                      icon: BtrSvg(
                        image: 'assets/icons/delete.svg',
                        color: constants.errorColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: constants.successColor,
        onPressed: () async {
          final recipeId = await showDialog<String>(
            context: context,
            builder: (context) => const CreateRecipeDialog(),
          );
          if (recipeId != null) {
            setState(() {
              _recipesFuture = _loadRecipes();
            });
            if (!mounted) return;
            if (widget.onRecipeSelected != null) {
              widget.onRecipeSelected!(recipeId);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Recipe(id: recipeId)),
              );
            }
          }
        },
        child: BtrSvg(image: 'assets/icons/add.svg'),
      ),
    );
  }
}