import 'package:get/get.dart';

import '../modules/Onboarding/bindings/onboarding_binding.dart';
import '../modules/Onboarding/views/onboarding_view.dart';
import '../modules/bottam/bindings/bottam_binding.dart';
import '../modules/bottam/views/bottam_view.dart';
import '../modules/crm/bindings/crm_binding.dart';
import '../modules/crm/views/crm_view.dart';
import '../modules/leadDetails/bindings/lead_details_binding.dart';
import '../modules/leadDetails/views/lead_details_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/sales/bindings/sales_binding.dart';
import '../modules/sales/views/sales_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.BOTTAM,
      page: () => const BottamView(),
      binding: BottamBinding(),
    ),
    GetPage(
      name: _Paths.CRM,
      page: () => const CrmView(),
      binding: CrmBinding(),
    ),
    GetPage(
      name: _Paths.SALES,
      page: () => const SalesView(),
      binding: SalesBinding(),
    ),
    GetPage(
      name: _Paths.LEAD_DETAILS,
      page: () => const LeadDetailsView(),
      binding: LeadDetailsBinding(),
    ),
  ];
}
