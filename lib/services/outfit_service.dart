import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

class OutfitService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> generateOutfit() async {
    try {
      // Récupérer tous les vêtements
      final clothes = await supabase.from('clothes').select();

      if (clothes.isEmpty) return null;

      // Séparer par catégorie
      final hauts = clothes.where((c) => c['category'] == 'haut').toList();
      final bas = clothes.where((c) => c['category'] == 'bas').toList();
      final shoes = clothes.where((c) => c['category'] == 'chaussures').toList();

      if (hauts.isEmpty || bas.isEmpty || shoes.isEmpty) {
        return null; // Impossible de générer une tenue complète
      }

      final random = Random();

      return {
        'haut': hauts[random.nextInt(hauts.length)],
        'bas': bas[random.nextInt(bas.length)],
        'chaussures': shoes[random.nextInt(shoes.length)],
      };
    } catch (e) {
      print("Erreur génération tenue : $e");
      return null;
    }
  }
}
