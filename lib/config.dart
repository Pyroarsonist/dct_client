import 'package:flutter_config/flutter_config.dart';

class Config {
  static String getBackendHost() {
    return FlutterConfig.get('BACKEND_URL');
  }
}
