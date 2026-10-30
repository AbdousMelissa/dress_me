import 'dart:math';

class OutfitBuilder {
  static Map<String, dynamic>? build(
    List<Map<String, dynamic>> clothes, {
    Random? random,
  }) {
    final tops = clothes.where((item) => item['category'] == 'haut').toList();
    final bottoms = clothes.where((item) => item['category'] == 'bas').toList();
    final shoes =
        clothes.where((item) => item['category'] == 'chaussures').toList();

    if (tops.isEmpty || bottoms.isEmpty || shoes.isEmpty) return null;

    final picker = random ?? Random();
    return {
      'haut': tops[picker.nextInt(tops.length)],
      'bas': bottoms[picker.nextInt(bottoms.length)],
      'chaussures': shoes[picker.nextInt(shoes.length)],
    };
  }
}