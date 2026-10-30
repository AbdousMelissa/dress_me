import 'package:supabase_flutter/supabase_flutter.dart';
import 'outfit_builder.dart';

class OutfitService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> generateOutfit() async {
    try {
      // Récupérer tous les vêtements
      final clothes = await supabase.from('clothes').select();

      return OutfitBuilder.build(clothes);
    } catch (e) {
      print("Erreur génération tenue : $e");
      return null;
    }
  }
}
