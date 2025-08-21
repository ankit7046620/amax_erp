import 'package:get/get.dart';

import '../modules/AssetDashboar/bindings/asset_dashboar_binding.dart';
import '../modules/AssetDashboar/views/asset_dashboar_view.dart';
import '../modules/AttendanceDashboard/bindings/attendance_dashboard_binding.dart';
import '../modules/AttendanceDashboard/views/attendance_dashboard_view.dart';
import '../modules/EmployeeCheckin/bindings/employee_checkin_binding.dart';
import '../modules/EmployeeCheckin/views/employee_checkin_view.dart';
import '../modules/LeaveApplication/bindings/leave_application_binding.dart';
import '../modules/LeaveApplication/views/leave_application_view.dart';
import '../modules/Onboarding/bindings/onboarding_binding.dart';
import '../modules/Onboarding/views/onboarding_view.dart';
import '../modules/StockDashboard/bindings/stock_dashboard_binding.dart';
import '../modules/StockDashboard/views/stock_dashboard_view.dart';
import '../modules/accounts/bindings/accounts_binding.dart';
import '../modules/accounts/views/accounts_view.dart';
import '../modules/attendenceBoard/bindings/attendence_board_binding.dart';
import '../modules/attendenceBoard/views/attendence_board_view.dart';
import '../modules/bottam/bindings/bottam_binding.dart';
import '../modules/bottam/views/bottam_view.dart';
import '../modules/calendar/bindings/calendar_binding.dart';
import '../modules/calendar/views/calendar_view.dart';
import '../modules/crm/bindings/crm_binding.dart';
import '../modules/crm/views/crm_view.dart';
import '../modules/empolyeeDashBoard/bindings/empolyee_dash_board_binding.dart';
import '../modules/empolyeeDashBoard/views/empolyee_dash_board_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/homeTab/bindings/home_tab_binding.dart';
import '../modules/homeTab/views/home_tab_view.dart';
import '../modules/hrAdmin/bindings/hr_admin_binding.dart';
import '../modules/hrAdmin/bindings/hr_admin_binding.dart';
import '../modules/hrAdmin/views/hr_admin_view.dart';
import '../modules/hrAdmin/views/hr_admin_view.dart';
import '../modules/hrReqirement/bindings/hr_reqirement_binding.dart';
import '../modules/hrReqirement/views/hr_reqirement_view.dart';
import '../modules/hrSetting/bindings/hr_setting_binding.dart';
import '../modules/hrSetting/views/hr_setting_view.dart';
import '../modules/hrView/bindings/hr_view_binding.dart';
import '../modules/hrView/views/hr_view_view.dart';
import '../modules/leadDetails/bindings/lead_details_binding.dart';
import '../modules/leadDetails/views/lead_details_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navBar/bindings/nav_bar_binding.dart';
import '../modules/navBar/views/nav_bar_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/payroll/bindings/payroll_binding.dart';
import '../modules/payroll/views/payroll_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/projectBoard/bindings/project_board_binding.dart';
import '../modules/projectBoard/views/project_board_view.dart';
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
import '../modules/task/bindings/task_binding.dart';
import '../modules/task/views/task_view.dart';

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
    GetPage(name: _Paths.CRM, page: () => CrmView(), binding: CrmBinding()),
    GetPage(
      name: _Paths.SALES,
      page: () => const SalesView(),
      binding: SalesBinding(),
    ),
    GetPage(
      name: _Paths.LEAD_DETAILS,
      page: () => LeadDetailsView(),
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
      page: () => NavBarView(),
      binding: NavBarBinding(),
    ),
    GetPage(
      name: _Paths.HOME_TAB,
      page: () => HomeTabView(),
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
    GetPage(
      name: _Paths.ATTENDANCE_DASHBOARD,
      page: () => const AttendanceDashboardView(),
      binding: AttendanceDashboardBinding(),
    ),
    GetPage(
      name: _Paths.PROJECT_BOARD,
      page: () => const ProjectBoardView(),
      binding: ProjectBoardBinding(),
    ),
    GetPage(
      name: _Paths.PAYROLL,
      page: () => PayrollChartView(),
      binding: PayrollBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNTS,
      page: () => const AccountsView(),
      binding: AccountsBinding(),
    ),
    GetPage(
      name: _Paths.EMPLOYEE_CHECKIN,
      page: () => const EmployeeCheckinView(),
      binding: EmployeeCheckinBinding(),
    ),
    GetPage(
      name: _Paths.HR_ADMIN,
      page: () => const HrAdminView(),
      binding: HrAdminBinding(),
      children: [
        GetPage(
          name: _Paths.HR_ADMIN,
          page: () => const HrAdminView(),
          binding: HrAdminBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.HR_REQIREMENT,
      page: () => const HrReqirementView(),
      binding: HrReqirementBinding(),
    ),
    GetPage(
      name: _Paths.EMPOLYEE_DASH_BOARD,
      page: () => const EmpolyeeDashBoardView(),
      binding: EmpolyeeDashBoardBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDENCE_BOARD,
      page: () => const AttendenceBoardView(),
      binding: AttendenceBoardBinding(),
    ),
    GetPage(
      name: _Paths.HR_SETTING,
      page: () => const HrSettingView(),
      binding: HrSettingBinding(),
    ),
    GetPage(
      name: _Paths.HR_VIEW,
      page: () => const HrViewView(),
      binding: HrViewBinding(),
    ),
    GetPage(
      name: _Paths.LEAVE_APPLICATION,
      page: () => const LeaveApplicationView(),
      binding: LeaveApplicationBinding(),
    ),
    GetPage(
      name: _Paths.TASK,
      page: () => const TaskView(),
      binding: TaskBinding(),
    ),
    GetPage(
      name: _Paths.CALENDAR,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
    ),
  ];
}
