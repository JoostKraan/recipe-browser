import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/components/svg_component.dart';
import 'package:recipe/pages/ingredients.dart';
import 'package:recipe/pages/recipe.dart';
import 'package:recipe/pages/recipe_list.dart';
import 'package:recipe/providers/constants_provider.dart';
import 'package:recipe/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final constantsProvider = await ConstantsProvider.create();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => constantsProvider)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'LexendDeca',
        colorScheme: ColorScheme.fromSeed(seedColor: constants.primaryColor ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;
  String? selectedRecipeId;

  void _selectRecipe(String recipeId) {
    setState(() {
      selectedRecipeId = recipeId;
    });
  }

  void _goBackToRecipeList() {
    setState(() {
      selectedRecipeId = null;
    });
  }

  Widget _getCurrentPage() {
    if (currentPage == 0) {
      if (selectedRecipeId != null) {
        return Recipe(
          id: selectedRecipeId!,
          onBack: _goBackToRecipeList,
        );
      } else {
        return RecipeList(onRecipeSelected: _selectRecipe);
      }
    } else {
      return const Ingredients();
    }
  }

  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;
    return Scaffold(
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
            if (currentPage != 0) {
              selectedRecipeId = null;
            }
          });
        },
        backgroundColor: constants.primaryColor,
        selectedItemColor: constants.fontColor,
        unselectedItemColor: constants.iconColor,
        items: [
          BottomNavigationBarItem(
            icon: BtrSvg(image: 'assets/icons/menu-book.svg'),
            label: "Recepten",
          ),
          BottomNavigationBarItem(
            icon: BtrSvg(image: 'assets/icons/egg.svg'),
            label: "Ingrediënten",
          ),
        ],
      ),
      backgroundColor: constants.primaryColor,
    );
  }
}