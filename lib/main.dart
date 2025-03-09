import 'package:exam_dev_mobile/screen/accueil_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: ".env");
    print("Fichier .env chargé avec succès");
  } catch (e) {
    print("Erreur lors du chargement du fichier .env : $e");
  }
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'exmane_flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AccueilPage(),
    );
  }
}
