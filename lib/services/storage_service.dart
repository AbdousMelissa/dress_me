import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final supabase = Supabase.instance.client;

  Future<String?> uploadImage(File image) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage.from('clothes').upload(fileName, image);

      return supabase.storage.from('clothes').getPublicUrl(fileName);
    } catch (e) {
      print('Erreur upload: $e');
      return null;
    }
  }

  Future<bool> saveImageToDatabase(String imageUrl, String category) async {
    try {
      await supabase.from('clothes').insert({
        'image_url': imageUrl,
        'category': category,
      });

      return true;
    } catch (e) {
      print('Erreur insert DB: $e');
      return false;
    }
  }

  Future<List<dynamic>> getClothes(String category) async {
    try {
      if (category == 'all') {
        return await supabase.from('clothes').select();
      }

      return await supabase.from('clothes').select().eq('category', category);
    } catch (e) {
      print('Erreur select: $e');
      return [];
    }
  }
}
