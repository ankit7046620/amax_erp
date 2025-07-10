class HeadersKey {
  static const String contentType = "Content-Type";
  static const String appSource = "AppSource";
  static const String appVersion = "AppVersion";
  static const String authorization = "Authorization";
  static const String applicationJson = "application/json";
  static const String android = "Android";
  static const String iOS = "iOS";
}

class LocalKeys{
  static const String onboardingSeen= "onboarding_seen";
  static const String sid= "sid";
  static const String eid= "eid";
  static const String fullName= "full_name";
}

class EdgeInsetType {
  static const double xxxxxxxs = 2;
  static const double xxxxxxs = 5;
  static const double xxxxxs = 8;
  static const double xxxxs = 10;
  static const double xxxs = 12;
  static const double xxs = 15;
  static const double xs = 18;
  static const double s = 20;
  static const double m = 25;
  static const double l = 30;
  static const double xl = 40;
  static const double xxl = 50;
  static const double xxxl = 55;
  static const double xxxxl = 60;
  static const double xxxxxl = 65;
  static const double xxxxxxl = 70;
  static const double xxxxxxxl = 90;
}

class SizeType {
  static double xxxxxxxxxxxs = 10;
  static double xxxxxxxxxxs = 15;
  static double xxxxxxxxxs = 18;
  static double xxxxxxxxs = 20;
  static double xxxxxxxs = 23;
  static double xxxxxxs = 26;
  static double xxxxxs = 30;
  static double xxxxs = 35;
  static double xxxs = 40;
  static double xxs = 42;
  static double xs = 45;
  static double s = 50;
  static double m = 65;
  static double l = 75;
  static double xl = 80;
  static double xxl = 90;
  static double xxxl = 100;
  static double xxxxl = 110;
  static double xxxxxl = 120;
  static double xxxxxxl = 140;
  static double xxxxxxxl = 150;
  static double xxxxxxxxl = 175;
  static double xxxxxxxxxl = 190;
  static double xxxxxxxxxxl = 210;
  static double xxxxxxxxxxxl = 235;
  static double xxxxxxxxxxxxl = 250;
}

class SpacingType {
  static const double xxxxs = 2;
  static const double xxxs = 5;
  static const double xxs = 8;
  static const double xs = 10;
  static const double s = 12;
  static const double m = 15;
  static const double l = 20;
  static const double xl = 25;
  static const double xxl = 35;
  static const double xxxl = 45;
  static const double xxxxl = 50;
  static const double xxxxxl = 80;
  static const double xxxxxxl = 140;
}

enum ImageType { svg, png, network, file, jpg, unknown }

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http://') || startsWith('https://')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file://')) {
      return ImageType.file;
    } else if (endsWith('.jpg')) {
      return ImageType.jpg;
    } else {
      return ImageType.png;
    }
  }
}