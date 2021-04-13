import 'package:http/http.dart';

class Utils {
  static bool isStatusCodeOk(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  static bool isUnauthorized(int statusCode) {
    return statusCode == 401;
  }

  static void logHttpError(Response response) {
    print(
        "Failed making request with status code ${response.statusCode}: ${response.request?.url}\nBody: ${response.body}");
  }
}
