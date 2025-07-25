import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/components/text_component.dart';
import 'package:recipe/services/ingredients_service.dart';
import '../providers/constants_provider.dart';

class IngredientToRecipeDialog extends StatefulWidget {
  final String id;
  final List<String>? ingredientList;
  const IngredientToRecipeDialog({super.key, required this.id,this.ingredientList});

  @override
  State<IngredientToRecipeDialog> createState() => _IngredientToRecipeDialogState();
}

class _IngredientToRecipeDialogState extends State<IngredientToRecipeDialog> {
  List<String> allIngredients = [];
  List<String> filteredIngredients = [];
  List<String> selectedItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    final data = await IngredientsService().readAllIngredients();
    setState(() {
      allIngredients = data.map((e) {
        if (e is Ingredient) {
          return e.name;
        }
        return e.toString(); // fallback
      }).toList();
      final recipeIngredientNames = widget.ingredientList
          ?.map((e) => e.split(" ").sublist(1).join(" "))
          .toList() ??
          [];
      filteredIngredients = allIngredients.where((ingredient) {
        return !recipeIngredientNames.contains(ingredient);
      }).toList();
    });
  }


  void _filterIngredients(String query) {
    setState(() {
      filteredIngredients = allIngredients
          .where(
            (ingredient) =>
                ingredient.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  void _toggleSelection(String ingredient) {
    setState(() {
      if (selectedItems.contains(ingredient)) {
        selectedItems.remove(ingredient);
      } else {
        selectedItems.add(ingredient);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;

    return SimpleDialog(
      backgroundColor: constants.primaryColor,
      title: const BtrText(text: 'Ingrediënten toevoegen'),
      children: [
        SizedBox(
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      child: TextField(
                        controller: searchController,
                        onChanged: _filterIngredients,
                        decoration: InputDecoration(
                         hintStyle: TextStyle(color: constants.fontColor),
                          hintText: "Zoek ingrediënten...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: allIngredients.isEmpty
                      ? Center(child: Text("Geen ingrediënten gevonden"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: filteredIngredients.length,
                          itemBuilder: (context, index) {
                            final ingredient = filteredIngredients[index];
                            final isSelected = selectedItems.contains(
                              ingredient,
                            );
                            return ListTile(
                              tileColor: isSelected
                                  ? constants.selectedTileColor
                                  : constants.unselectedTileColor,
                              title: Text(
                                ingredient,
                                style: TextStyle(
                                  color: constants.fontColor,
                                  fontSize: constants.fontSize * 0.9,
                                ),
                              ),
                              trailing: Icon(
                                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                                color: isSelected ? constants.successColor : constants.iconColor,
                                size: constants.iconSize,
                              ),
                              onTap: () => _toggleSelection(ingredient),
                            );

                          },
                        ),
                ),

                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: BtrText(text: "Geselecteerde Ingrediënten"),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Wrap(
                    spacing: 6,
                    children: selectedItems
                        .map(
                          (e) => Chip(
                            label: Text(e),
                            onDeleted: () {
                              _toggleSelection(e);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {Navigator.pop(context, selectedItems);},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        'Ok',
                        style: TextStyle(color: constants.fontColor),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        'Annuleren',
                        style: TextStyle(color: constants.fontColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
