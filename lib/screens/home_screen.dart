import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'dressing_screen.dart';
import 'outfit_screen.dart';
import 'add_clothes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked == null) return;

    final file = File(picked.path);

    // On envoie la photo à l'écran de choix de catégorie
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddClothesScreen(image: file),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dress Me")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Ajouter un vêtement"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DressingScreen()),
                );
              },
              child: const Text("Voir mon dressing"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OutfitScreen()),
                );
              },
              child: const Text("Tenue du jour"),
            ),
          ],
        ),
      ),
    );
  }
}
