import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/components/text_component.dart';
import '../providers/constants_provider.dart';
import '../services/recipe_service.dart';

class CreateRecipeDialog extends StatelessWidget {
  const CreateRecipeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final constants = context.watch<ConstantsProvider>().constants;
    return SimpleDialog(
      backgroundColor: constants.primaryColor,
      title: BtrText(text: 'Recept Naam'),
      children: [
        SimpleDialogOption(
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: constants.fontColor),
          ),
        ),
        SimpleDialogOption(
          child: OutlinedButton(
            onPressed: () async {
              await RecipeService().createRecipe(
                rating: 0.0,
                name: controller.text,
                image: 'yakitori.jpg',
                lastUpdated: DateTime.now()
              );
              final recipeData = await RecipeService().readRecipe(controller.text);

                Navigator.pop(context, recipeData!['id']);
            },
            style: OutlinedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Ok', style: TextStyle(color: constants.fontColor)),
          ),
        ),
        SimpleDialogOption(
          child: OutlinedButton(
            onPressed: null,
            style: OutlinedButton.styleFrom(backgroundColor: Colors.red[700]),
            child: Text(
              'Annuleer',
              style: TextStyle(color: constants.fontColor),
            ),
          ),
        ),
      ],
    );
  }
}
