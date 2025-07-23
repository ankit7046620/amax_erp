import 'package:get/get.dart';

import '../modules/Onboarding/bindings/onboarding_binding.dart';
import '../modules/Onboarding/views/onboarding_view.dart';
import '../modules/bottam/bindings/bottam_binding.dart';
import '../modules/bottam/views/bottam_view.dart';
import '../modules/crm/bindings/crm_binding.dart';
import '../modules/crm/views/crm_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/leadDetails/bindings/lead_details_binding.dart';
import '../modules/leadDetails/views/lead_details_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/purchaseGraph/bindings/purchase_graph_binding.dart';
import '../modules/purchaseGraph/views/purchase_graph_view.dart';
import '../modules/purchaseOrdersDashboard/bindings/purchase_orders_dashboard_binding.dart';
import '../modules/purchaseOrdersDashboard/views/purchase_orders_dashboard_view.dart';
import '../modules/saleGraph/bindings/sale_graph_binding.dart';
import '../modules/saleGraph/views/sale_graph_view.dart';
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
      page: () => CrmView(),
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
    GetPage(
      name: _Paths.SALE_GRAPH,
      page: () => SaleGraphView(),
      binding: SaleGraphBinding(),
    ),
    GetPage(
      name: _Paths.PURCHASE_ORDERS_DASHBOARD,
      page: () => const PurchaseOrdersDashboardView(),
      binding: PurchaseOrdersDashboardBinding(),
    ),
    GetPage(
      name: _Paths.PURCHASE_GRAPH,
      page: () => const PurchaseGraphView(),
      binding: PurchaseGraphBinding(),
    ),
  ];
}
