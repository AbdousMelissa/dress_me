import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/photo_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const DressMeApp());
}

class DressMeApp extends StatelessWidget {
  const DressMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PhotoPage(),
    );
  }
}