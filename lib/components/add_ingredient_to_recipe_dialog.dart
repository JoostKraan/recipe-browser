import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/components/text_component.dart';
import 'package:recipe/services/ingredients_service.dart';
import '../providers/constants_provider.dart';
import 'package:recipe/services/ingredients_service.dart' show Ingredient;

class IngredientToRecipeDialog extends StatefulWidget {
  final String recipeId;
  final List<String>? ingredientList;

  const IngredientToRecipeDialog({
    super.key,
    required this.recipeId,
    this.ingredientList,
  });

  @override
  State<IngredientToRecipeDialog> createState() =>
      _IngredientToRecipeDialogState();
}

class _IngredientToRecipeDialogState extends State<IngredientToRecipeDialog> {
  List<Ingredient> allIngredientObjs = [];
  List<Ingredient> filteredIngredientObjs = [];
  List<String> selectedIds = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    final data = await IngredientsService().readAllIngredients();
    final existingIds = widget.ingredientList ?? [];
    setState(() {
      allIngredientObjs = data;
      filteredIngredientObjs = allIngredientObjs
          .where((ing) => !existingIds.contains(ing.id))
          .toList();
    });
  }

  void _filterIngredients(String query) {
    final existingIds = widget.ingredientList ?? [];
    setState(() {
      filteredIngredientObjs = allIngredientObjs
          .where((ing) =>
      !existingIds.contains(ing.id) &&
          ing.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleSelection(Ingredient ing) {
    setState(() {
      if (selectedIds.contains(ing.id)) {
        selectedIds.remove(ing.id);
      } else {
        selectedIds.add(ing.id);
      }
    });
  }

  Future<void> _onConfirm() async {
    final items = selectedIds.map((id) => {'id': id, 'quantity': 0.0}).toList();
    await IngredientsService()
        .assignIngredientsToRecipe(widget.recipeId, items);
    Navigator.pop(context, selectedIds);
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
                TextField(
                  controller: searchController,
                  onChanged: _filterIngredients,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: constants.fontColor),
                    hintText: "Zoek ingrediënten...",
                    prefixIcon: Icon(Icons.search, color: constants.iconColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: filteredIngredientObjs.isEmpty
                      ? Center(
                    child: Text(
                      "Geen ingrediënten gevonden",
                      style: TextStyle(color: constants.fontColor),
                    ),
                  )
                      : ListView.builder(
                    itemCount: filteredIngredientObjs.length,
                    itemBuilder: (ctx, index) {
                      final ing = filteredIngredientObjs[index];
                      final isSel = selectedIds.contains(ing.id);
                      return ListTile(
                        tileColor: isSel
                            ? constants.selectedTileColor
                            : constants.unselectedTileColor,
                        title: Text(
                          ing.name,
                          style: TextStyle(
                            color: constants.fontColor,
                            fontSize: constants.fontSize * 0.9,
                          ),
                        ),
                        trailing: Icon(
                          isSel
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: isSel
                              ? constants.successColor
                              : constants.iconColor,
                          size: constants.iconSize,
                        ),
                        onTap: () => _toggleSelection(ing),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                if (selectedIds.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: BtrText(text: "Geselecteerde Ingrediënten"),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Wrap(
                      spacing: 6,
                      children: selectedIds.map((id) {
                        final ing = allIngredientObjs.firstWhere((e) => e.id == id);
                        return Chip(
                          label: Text(ing.name),
                          onDeleted: () => _toggleSelection(ing),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: constants.unselectedTileColor,
                      ),
                      child: Text(
                        'Annuleren',
                        style: TextStyle(color: constants.fontColor),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: selectedIds.isNotEmpty ? _onConfirm : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: constants.successColor,
                      ),
                      child: Text(
                        'Toevoegen',
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
