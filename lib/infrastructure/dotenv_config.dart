import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotenvConfig {
  static Future<void> load() async {
    await dotenv.load();
  }
}
