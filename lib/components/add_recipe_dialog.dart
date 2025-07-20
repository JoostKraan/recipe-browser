import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recipe/components/svg_component.dart';
import 'package:recipe/components/text_component.dart';

import '../providers/constants-provider.dart';

class createRecipeDialog extends StatelessWidget {
  const createRecipeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;
    return SimpleDialog(
      backgroundColor: constants.primaryColor,
      title: btrText(text: 'Recept Naam'),
      children: [
        SimpleDialogOption(child: TextFormField()),
        SimpleDialogOption(
          child: Column(
            children: [
              Row(
                spacing: 10,
                children: [
                  btrText(
                    fontSize: 18,
                    text:
                    'Tags : ',
                  ),
                  ActionChip(
                    backgroundColor: constants.secondaryColor,
                    avatar: btrSvg(
                      image : 'assets/icons/run-fast.svg',
                      color: Colors.yellow[700],
                    ),
                    onPressed: () {
                      print('f');
                    },
                    label: const btrText(text: 'Snel',fontSize: 18),
                  ),
                  ActionChip(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: constants.secondaryColor,
                    avatar: btrSvg(
                      image : 'assets/icons/leaf-circle.svg',
                      color: Colors.green,
                    ),
                    onPressed: () {
                      print('f');
                    },
                    label: const btrText(text: 'Vega',fontSize: 18,),
                  ),
                ],
              ),
            ],
          ),
        ),
        SimpleDialogOption(
          child: OutlinedButton(
            onPressed: null,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text('Ok',style: TextStyle(color: constants.fontColor),),
          ),
        ),
        SimpleDialogOption(
          child: OutlinedButton(
            onPressed: null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red[700]!),
            ),
            child: Text('Annuleer',style: TextStyle(color: constants.fontColor),),
          ),
        ),
      ],
    );
  }
}
