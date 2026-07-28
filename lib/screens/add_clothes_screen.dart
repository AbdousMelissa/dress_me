import 'dart:io';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/yolo_classifier.dart';

class AddClothesScreen extends StatefulWidget {
  final File image;

  const AddClothesScreen({super.key, required this.image});

  @override
  State<AddClothesScreen> createState() => _AddClothesScreenState();
}

class _AddClothesScreenState extends State<AddClothesScreen> {
  final storageService = StorageService();
  final classifier = YoloClassifier();

  String? category;
  bool loading = false;
  bool analyzing = true;

  @override
  void initState() {
    super.initState();
    analyzeImage();
  }

  Future<void> analyzeImage() async {
    final detected = await classifier.classify(widget.image);

    if (detected == "non-vêtement") {
      setState(() {
        analyzing = false;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Objet non reconnu"),
          content: const Text("Cette photo ne semble pas représenter un vêtement."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );

      return;
    }

    setState(() {
      category = detected;
      analyzing = false;
    });
  }

  Future<void> saveClothes() async {
    if (category == null) return;

    setState(() => loading = true);

    // Upload image dans Supabase Storage
    final imageUrl = await storageService.uploadImage(widget.image);

    if (imageUrl == null) {
      setState(() => loading = false);
      print("Erreur upload image");
      return;
    }

    // Insert dans la base Supabase
    final success =
        await storageService.saveImageToDatabase(imageUrl, category!);

    if (!success) {
      setState(() => loading = false);
      print("Erreur insert DB");
      return;
    }

    Navigator.pop(context); // Retour au HomeScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un vêtement")),
      body: analyzing
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),
                Image.file(widget.image, height: 300),
                const SizedBox(height: 20),

                // Catégorie détectée par l'IA
                Text(
                  category != null
                      ? "Catégorie détectée : $category"
                      : "Aucune catégorie détectée",
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: loading ? null : saveClothes,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("Enregistrer"),
                ),
              ],
            ),
    );
  }
}
