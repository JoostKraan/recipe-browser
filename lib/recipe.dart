import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/providers/constants_provider.dart';
import 'package:recipe/services/recipe_service.dart';
import 'package:recipe/services/tag_service.dart';

import 'components/text_component.dart';

class Recipe extends StatefulWidget {
  final String id;

  const Recipe({super.key, required this.id});

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  late Future<Map<String, dynamic>?> _recipeFuture;
  @override
  void initState() {
    super.initState();
    _recipeFuture = RecipeService().readRecipe(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;
    return Scaffold(
      backgroundColor: constants.primaryColor,
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
                        label: BtrText(
                          text: recipe['rating'].toString(),
                          color: Colors.black,
                        ),
                        shape: StadiumBorder(),
                      ),
                    ),
                  ],
                ),
              ),
             Expanded(
               child: Container(
                 decoration: BoxDecoration(color: constants.specialColor,
                   border: BoxBorder.all(color: constants.primaryColor),
                   borderRadius: BorderRadius.all(Radius.circular(20))
                 ),

                 child: Column(
                   children: [
                     Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: BtrText( text: recipe["name"],color: Colors.black),
                         ),
                       ],
                     )
                   ],
                 ),
               ),
             )

            ],
          );
        },
      ),
    );
  }
}
