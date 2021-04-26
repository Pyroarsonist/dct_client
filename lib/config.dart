import 'package:flutter_config/flutter_config.dart';

class Config {
  static String getBackendHost() {
    return FlutterConfig.get('BACKEND_URL') as String;
  }

  static void _ensureVariable(String env) {
    if (FlutterConfig.get(env) == null) throw Exception('Bad $env');
  }

  static void ensureVariables() {
    _ensureVariable('BACKEND_URL');
    _ensureVariable('GOOGLE_MAPS_API_KEY');
  }
}
