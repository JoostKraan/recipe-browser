import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/components/svg_component.dart';
import 'package:recipe/components/text_component.dart';
import 'package:recipe/providers/constants_provider.dart';
import 'package:recipe/recipe.dart';
import 'package:recipe/services/recipe_service.dart';
import 'package:recipe/firebase_options.dart';

import 'components/add_recipe_dialog.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'LexendDeca',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  late Future<List<Map<String, dynamic>>> _recipesFuture;
  @override
  void initState() {
    super.initState();
    _recipesFuture = _loadRecipes();
  }

  Future<List<Map<String, dynamic>>> _loadRecipes() async {
    return await RecipeService().readAllData('recipes');
  }
  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;
    return Scaffold(
      backgroundColor: constants.primaryColor,
      appBar: AppBar(
        backgroundColor: constants.primaryColor,
        title: BtrText(text: 'Recepten'),
        actions: [
          IconButton(
            onPressed: () => context.read<ConstantsProvider>().toggleDarkMode(),
            icon: BtrSvg(
              image:
              context.read<ConstantsProvider>().isDarkMode
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
            return const Center(child: BtrText(text:'No recipes found'));
          }
          final recipes = snapshot.data!;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final name = recipes[index]['name'];
              return Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: GestureDetector(
                        onTap: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Recipe(id: name),
                          ),
                        );},
                        child: Container(
                          decoration: BoxDecoration(
                            color: constants.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: BtrText(text: name,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final updatedRecipes = await RecipeService()
                          .deleteRecipe(recipes[index]['id']);
                      setState(() {
                        _recipesFuture = Future.value(updatedRecipes);
                      });
                    },
                    icon:BtrSvg(
                      image:
                      'assets/icons/delete.svg',
                      color: constants.errorColor,
                    ),
                  ),
                ],
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Recipe(id: recipeId),
              ),
            );
          }
        },
        child: BtrSvg(image: 'assets/icons/add.svg'),
      ),
    );
  }
}
