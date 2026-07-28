import 'package:flutter/material.dart';
import '../services/outfit_service.dart';

class OutfitScreen extends StatefulWidget {
  const OutfitScreen({super.key});

  @override
  State<OutfitScreen> createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  final outfitService = OutfitService();
  Map<String, dynamic>? outfit;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    generate();
  }

  Future<void> generate() async {
    setState(() => loading = true);

    final result = await outfitService.generateOutfit();

    setState(() {
      outfit = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (outfit == null) {
      return const Scaffold(
        body: Center(child: Text("Impossible de générer une tenue")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Tenue du jour")),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Image.network(outfit!['haut']['image_url'], height: 200),
                const SizedBox(height: 20),
                Image.network(outfit!['bas']['image_url'], height: 200),
                const SizedBox(height: 20),
                Image.network(outfit!['chaussures']['image_url'], height: 200),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: generate,
            child: const Text("Nouvelle tenue"),
          ),
        ],
      ),
    );
  }
}
