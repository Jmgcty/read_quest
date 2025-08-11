class AppAssets {
  AppAssets._();
  static final String logo = _getImage('logo.png');
  static final String appBackground = _getImage('cust_app_background.png');
  static final String birdCartoon = _getImage('bird_cartoon.png');
  static final String birdSayHello = _getImage('bird_say_hello.png');
  static final String appName = _getImage('cust_app_name.png');
  //
  static String _getImage(String path) => 'assets/images/$path';
}
