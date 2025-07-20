import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:recipe/providers/constants-provider.dart';
import 'package:recipe/services/database_service.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
  void initState()  {
    super.initState();
    _recipesFuture = _loadRecipes();
  }
  Future<List<Map<String, dynamic>>> _loadRecipes() async {
    return await DatabaseService().readAllData('recipes');
  }
  Future<List<Map<String, dynamic>>> _createRecipe() async {
    return await DatabaseService().createRecipe('aardappel', '10m');
  }


  void _showRecipeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Naam van recept'),
          children: [
            SimpleDialogOption(child: TextFormField()),
            SimpleDialogOption(child: Column(
              children: [
                Row(children: [
                  ActionChip(
                    onPressed: () { print('f');},
                    label: const Text('Aaron Burr'),
                  ),
                  ActionChip(
                    onPressed: () { print('f');},
                    label: const Text('Aaron Burr'),
                  ),

                ],)

              ],
            ),)
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;
    return Scaffold(
      backgroundColor: constants.primaryColor,
      appBar: AppBar(
        backgroundColor: constants.primaryColor,
        title: Text(style: TextStyle(color: constants.fontColor), 'Recepten'),
        actions: [
          IconButton(
            onPressed: () => context.read<ConstantsProvider>().toggleDarkMode(),
            icon: SvgPicture.asset(
              color: constants.iconColor,
              context.read<ConstantsProvider>().isDarkMode
                  ? 'assets/icons/dark-mode.svg'
                  : 'assets/icons/light-mode.svg',
              width: constants.iconSize,
              height: constants.iconSize,
            ),
          ),
        ],
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found'));
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: constants.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            style: TextStyle(color: constants.fontColor),
                            name,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: SvgPicture.asset(
                      'assets/icons/delete.svg',
                      width: constants.iconSize,
                      height: constants.iconSize,
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
        onPressed: _createRecipe,
        child: SvgPicture.asset(
          'assets/icons/add.svg',
          width: constants.iconSize,
          height: constants.iconSize,
        ),
      ),
    );
  }
}
