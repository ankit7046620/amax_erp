const String globalCompanyName = GlobalCompany.vasani;

class HeadersKey {
  static const String contentType = "Content-Type";
  static const String appSource = "AppSource";
  static const String appVersion = "AppVersion";
  static const String authorization = "Authorization";
  static const String applicationJson = "application/json";
  static const String android = "Android";
  static const String iOS = "iOS";
}

class GlobalCompany {
  static const String vasani = "Vasani Polymers";
  static const String amaxDemo = "Amax Consultancy Services (Demo)";
  static const String tech = "techcloudamax";

  static const String ams = "Amax Consultancy Services";
  static const String cello = "cello";
  static const String ap = "Amax Polymers";
  static const String acd = "Amax Consultancy Services (Demo)";
  static const String tp = "tata pips";
  static const String tipendra = "tipendra";
  static const String mayur = "mayur";
  static const String akshar = "Akshar plastic for granual";
  static const String reliance = "Reliance Industry";
}

class CrmLeadStatus {
  static const String converted = 'converted';
}

class GlobalConstants {
  static const String appName = "Plastic";
  static const String appVersion = "1.0.0";
  static const String appSource = "Plastic App";
  static const String android = "Android";
  static const String iOS = "iOS";
  static const String defaultLanguage = "en";
  static const String defaultCurrency = "USD";
  static const String defaultDateFormat = "yyyy-MM-dd";
  static const String defaultTimeFormat = "HH:mm:ss";
}

class CardStatus {
  static const String toReceiveAndBill = "To Receive and Bill";
}

class ChartFilterType {
  static const String yearly = 'Yearly';
  static const String quarterly = 'Quarterly';
  static const String monthly = 'Monthly';
  static const String weekly = 'Weekly';
  static const String daily = 'Daily';
}

class LocalKeys {
  static const String sid = 'sid';
  static const String fullName = 'fullName';
  static const String userId = 'userId';
  static const String userImage = 'userImage';
  static const String systemUser = 'systemUser';
  static const String cookieHeader = 'cookieHeader';
  static const String onboardingSeen = "onboarding_seen";
  static const String module = "module";

  static const String eid = "eid";
  static const String userPermissions = "UserPermissions";
  static const String userRoles = "user_roles";
}

enum Module {
  accounts("Accounts"),
  assets("Assets"),
  automation("Automation"),
  bulkTransaction("Bulk Transaction"),
  buying("Buying"),
  communication("Communication"),
  contacts("Contacts"),
  core("Core"),
  crm("CRM"),
  custom("Custom"),
  desk("Desk"),
  email("Email"),
  erpNextIntegrations("ERPNext Integrations"),
  geo("Geo"),
  healthcare("Healthcare"),
  hr("HR"),
  integrations("Integrations"),
  maintenance("Maintenance"),
  manufacturing("Manufacturing"),
  paymentGateways("Payment Gateways"),
  payments("Payments"),
  payroll("Payroll"),
  portal("Portal"),
  printing("Printing"),
  projects("Projects"),
  qualityManagement("Quality Management"),
  regional("Regional"),
  selling("Selling"),
  setup("Setup"),
  social("Social"),
  stock("Stock"),
  subcontracting("Subcontracting"),
  support("Support"),
  telephony("Telephony"),
  utilities("Utilities"),
  website("Website"),
  workflow("Workflow");

  final String value;

  const Module(this.value);
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

enum GlobalPermissionType { read, write, create, delete, submit, cancel, amend }

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
