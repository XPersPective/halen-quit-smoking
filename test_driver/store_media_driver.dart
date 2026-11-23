import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  final path = Directory(Platform.environment['STORE_MEDIA_DIR']!);
  await path.create(recursive: true);
  await integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      const screenshots = {'01-today', '02-analytics', '03-plan'};
      if (!screenshots.contains(name) || bytes.isEmpty) return false;
      await File('${path.path}/$name.png').writeAsBytes(bytes, flush: true);
      return true;
    },
  );
}
