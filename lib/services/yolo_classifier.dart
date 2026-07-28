import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:onnxruntime_flutter/onnxruntime_flutter.dart';

class YoloClassifier {
  late OrtSession session;

  Future<void> loadModel() async {
    final env = OrtEnv.instance;

    session = await OrtSession.fromAsset(
      'models/yolov8l-cls.onnx',
      env: env,
    );
  }

  Future<String> classify(File imageFile) async {
    await loadModel();

    // Charger l’image
    final rawImage = img.decodeImage(await imageFile.readAsBytes())!;
    final resized = img.copyResize(rawImage, width: 224, height: 224);

    // Convertir en float32
    final input = List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );

    // Exécuter le modèle
    final outputs = session.run({'input': input});
    final scores = outputs['output'] as List<double>;

    // Labels pour ton app
    final labels = [
      "haut",
      "bas",
      "chaussures",
      "non-vêtement",
    ];

    // Trouver la catégorie la plus probable
    final maxIndex = scores.indexOf(scores.reduce((a, b) => a > b ? a : b));

    return labels[maxIndex];
  }
}
