import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/components/text_component.dart';
import 'package:recipe/services/ingredients_service.dart';

import '../providers/constants_provider.dart';

class AddIngredientDialog extends StatefulWidget {
  const AddIngredientDialog({super.key});

  @override
  State<AddIngredientDialog> createState() => _AddIngredientDialogState();
}

class _AddIngredientDialogState extends State<AddIngredientDialog> {
  TextEditingController name = TextEditingController();
  TextEditingController unit = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;
    return SimpleDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [BtrText(text: 'Nieuw Ingredient')],
      ),
      backgroundColor: constants.primaryColor,
      children: [
        SimpleDialogOption(
          child: Column(
            children: [
              TextField(
                controller: name,
                style: TextStyle(
                  color: constants.fontColor, // Text color
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "bijv : Rijst, Broccoli, Kip ",
                  hintStyle: TextStyle(
                    color: constants.fontColor.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  label: const BtrText(text: 'Naam'),
                  labelStyle: TextStyle(
                    color: constants.fontColor.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: constants.fontColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: constants.fontColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              TextField(
                controller: unit,
                style: TextStyle(
                  color: constants.fontColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  label: const BtrText(text: 'Eenheid'),
                  labelStyle: TextStyle(
                    color: constants.fontColor.withOpacity(0.8),
                    fontSize: 14,
                  ),
                  hintText: "bijv : g, el, kg",
                  hintStyle: TextStyle(
                    color: constants.fontColor.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: constants.fontColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: constants.fontColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SimpleDialogOption(
          child: Row(
            spacing: 30,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  final formattedName = name.text.isNotEmpty
                      ? name.text[0].toUpperCase() + name.text.substring(1)
                      : '';
                  IngredientsService().createIngredient(
                    formattedName,
                    unit.text,
                  );
                  Navigator.pop(context,true);
                },
                style: OutlinedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Ok', style: TextStyle(color: constants.fontColor)),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  'Annuleren',
                  style: TextStyle(color: constants.fontColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
