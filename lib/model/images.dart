class SplashImage {
  final Uri uri;

  SplashImage(this.uri);

  _getWithSize(String width, String height) {
    Map<String, String> parameters =
        new Map<String, String>.from(uri.queryParameters)
          ..addAll({
            'h': height,
            'w': width,
          });

    return uri.replace(queryParameters: parameters).toString();
  }

  String low() {
    return _getWithSize('320', '280');
  }

  String medium() {
    return _getWithSize('800', '600');
  }

  String high() {
    return "${uri.origin}${uri.path}";
  }
}
