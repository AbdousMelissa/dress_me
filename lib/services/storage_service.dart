import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  static Future<void> uploadImage(File image) async {
    final supabase = Supabase.instance.client;

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage
        .from('clothes')
        .upload(fileName, image);
  }

  // 🔐 Récupérer une URL signée pour afficher une image privée
  static Future<String> getImageUrl(String fileName) async {
    final supabase = Supabase.instance.client;

    final url = await supabase.storage
        .from('clothes')
        .createSignedUrl(fileName, 60 * 60); // expire dans 1h

    return url;
  }

  // 📄 Lister les fichiers du bucket privé
  static Future<List<String>> listImages() async {
    final supabase = Supabase.instance.client;

    final files = await supabase.storage
        .from('clothes')
        .list();

    return files.map((f) => f.name).toList();
  }
}