class AppAssets {
  AppAssets._();
  static final String logo = _getImage('logo.png');
  static final String appBackground = _getImage('app_bg.png');
  static final String birdCartoon = _getImage('bird_cartoon.png');
  static final String appName = _getImage('app_name.png');
  //
  static String _getImage(String path) => 'assets/images/$path';
}
