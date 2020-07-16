class HttpUtil {
  static bool isOkStatus(int statusCode) {
    return statusCode > 199 && statusCode < 300;
  }
}
