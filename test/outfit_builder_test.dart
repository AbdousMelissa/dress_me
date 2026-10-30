import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:dress_me/services/outfit_builder.dart';

void main() {
  group('OutfitBuilder.build', () {
    test('returns null when the wardrobe is empty', () {
      expect(OutfitBuilder.build([]), isNull);
    });

    test('returns null when a required category is missing', () {
      final clothes = [
        {'category': 'haut'},
        {'category': 'bas'},
      ];

      expect(OutfitBuilder.build(clothes), isNull);
    });

    test('selects one item from every required category', () {
      final tops = [
        {'category': 'haut', 'name': 't-shirt'},
        {'category': 'haut', 'name': 'chemise'},
      ];
      final bottoms = [
        {'category': 'bas', 'name': 'jean'},
      ];
      final shoes = [
        {'category': 'chaussures', 'name': 'baskets'},
      ];

      final outfit = OutfitBuilder.build(
        [...tops, ...bottoms, ...shoes],
        random: Random(0),
      );

      expect(outfit, isNotNull);
      expect(outfit!.keys, containsAll(['haut', 'bas', 'chaussures']));
      expect(tops, contains(outfit['haut']));
      expect(bottoms, contains(outfit['bas']));
      expect(shoes, contains(outfit['chaussures']));
    });
  });
}