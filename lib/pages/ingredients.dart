import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/components/create_ingredient.dart';
import 'package:recipe/components/svg_component.dart';
import 'package:recipe/components/text_component.dart';
import 'package:recipe/services/ingredients_service.dart';
import '../providers/constants_provider.dart';

class Ingredients extends StatefulWidget {
  const Ingredients({super.key});

  @override
  State<Ingredients> createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  late Future<List<Ingredient>> ingredientsFuture;

  Future<List<Ingredient>> _loadIngredients() async {
    return await IngredientsService().readAllIngredients();
  }

  void _refreshIngredients() {
    setState(() {
      ingredientsFuture = _loadIngredients();
    });
  }

  @override
  void initState() {
    super.initState();
    ingredientsFuture = _loadIngredients();
  }

  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: constants.primaryColor,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder<List<Ingredient>>(
                future: ingredientsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No ingredients found"));
                  }

                  final ingredients = snapshot.data!;
                  print(ingredients);

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Expanded(child: BtrText(text: 'Ingredient')),
                        ),
                        DataColumn(
                          label: Expanded(child: BtrText(text: 'Eenheid')),
                        ),
                        DataColumn(
                          label: Expanded(child: BtrText(text: 'Actie')),
                        ),
                      ],
                      rows: ingredients.map((ingredient) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(BtrText(text: ingredient.name)),
                            DataCell(BtrText(text: ingredient.unit)),
                            DataCell(
                              IconButton(
                                icon: BtrSvg(image: 'assets/icons/delete.svg',color: constants.errorColor,),
                                onPressed: () {IngredientsService().deleteIngredient(ingredient.name); _refreshIngredients();},
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await showDialog(
              context: context,
              builder: (context) => const AddIngredientDialog(),
            );

            if (result == true) {
              _refreshIngredients();
            }
          },
          backgroundColor: constants.accentColor,
          child: BtrSvg(image: 'assets/icons/add.svg'),
        ),
      ),
    );
  }
}
