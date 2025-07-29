import 'package:amax_hr/app/modules/AssetDashboar/bindings/asset_dashboar_binding.dart';
import 'package:amax_hr/app/modules/AssetDashboar/views/asset_dashboar_view.dart';
import 'package:get/get.dart';

import '../modules/Onboarding/bindings/onboarding_binding.dart';
import '../modules/Onboarding/views/onboarding_view.dart';
import '../modules/StockDashboard/bindings/stock_dashboard_binding.dart';
import '../modules/StockDashboard/views/stock_dashboard_view.dart';
import '../modules/bottam/bindings/bottam_binding.dart';
import '../modules/bottam/views/bottam_view.dart';
import '../modules/crm/bindings/crm_binding.dart';
import '../modules/crm/views/crm_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/homeTab/bindings/home_tab_binding.dart';
import '../modules/homeTab/views/home_tab_view.dart';
import '../modules/leadDetails/bindings/lead_details_binding.dart';
import '../modules/leadDetails/views/lead_details_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navBar/bindings/nav_bar_binding.dart';
import '../modules/navBar/views/nav_bar_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/purchaseGraph/bindings/purchase_graph_binding.dart';
import '../modules/purchaseGraph/views/purchase_graph_view.dart';
import '../modules/purchaseOrdersDashboard/bindings/purchase_orders_dashboard_binding.dart';
import '../modules/purchaseOrdersDashboard/views/purchase_orders_dashboard_view.dart';
import '../modules/saleGraph/bindings/sale_graph_binding.dart';
import '../modules/saleGraph/views/sale_graph_view.dart';
import '../modules/sales/bindings/sales_binding.dart';
import '../modules/sales/views/sales_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
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
      name: _Paths.ASSET_DASHBOAR,
      page: () => const AssetDashboardView(),
      binding: AssetDashboarBinding(),
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
      page: () =>   LeadDetailsView(),
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
    GetPage(
      name: _Paths.STOCK_DASHBOARD,
      page: () => const StockDashboardView(),
      binding: StockDashboardBinding(),
    ),
    GetPage(
      name: _Paths.NAV_BAR,
      page: () => const NavBarView(),
      binding: NavBarBinding(),
    ),
    GetPage(
      name: _Paths.HOME_TAB,
      page: () =>   HomeTabView(),
      binding: HomeTabBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
