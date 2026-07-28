import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class DressingScreen extends StatefulWidget {
  const DressingScreen({super.key});

  @override
  State<DressingScreen> createState() => _DressingScreenState();
}

class _DressingScreenState extends State<DressingScreen> {
  final storageService = StorageService();

  List<dynamic> files = [];
  bool loading = true;

  String selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadImages();
    });
  }

  Future<void> loadImages() async {
    final result = await storageService.getClothes(selectedCategory);

    print("RESULTAT SUPABASE : $result");

    setState(() {
      files = result;
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

    return Scaffold(
      appBar: AppBar(title: const Text("Mon Dressing")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton<String>(
              value: selectedCategory,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('Tous')),
                DropdownMenuItem(value: 'haut', child: Text('Hauts')),
                DropdownMenuItem(value: 'bas', child: Text('Bas')),
                DropdownMenuItem(value: 'chaussures', child: Text('Chaussures')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                  loading = true;
                });
                loadImages();
              },
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: files.length,
              itemBuilder: (context, index) {
                final item = files[index];
                final url = (item['image_url'] ?? '').toString();

                if (url.isEmpty) {
                  return const Center(child: Icon(Icons.broken_image));
                }

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error, color: Colors.red),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
