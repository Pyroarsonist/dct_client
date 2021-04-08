class Utils {
  static bool isStatusCodeOk(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }
}
