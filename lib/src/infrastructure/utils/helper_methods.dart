class HelperMethods {
  static bool isTokenExpired(DateTime expireAt) {
    return expireAt.isBefore(DateTime.now());
  }
}
