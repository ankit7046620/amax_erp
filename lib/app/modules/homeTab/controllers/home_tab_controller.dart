
import 'package:amax_hr/app/modules/StockDashboard/views/stock_dashboard_view.dart';
import 'package:amax_hr/app/modules/crm/views/crm_view.dart';
import 'package:amax_hr/app/modules/purchaseOrdersDashboard/views/purchase_orders_dashboard_view.dart';
import 'package:amax_hr/app/modules/saleDashboard/views/sale_dashboard_view.dart';
import 'package:amax_hr/constant/url.dart';
import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

enum ModuleType { CRM, Selling, Buying, Stock }

class HomeTabController extends GetxController {
  final count = 0.obs;

  List<Color> popularColor = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.yellow,
  ];

  List<String> moduleNames = [];
  List<ModuleItem> popularModules = [];
  List<ModuleItem> otherModules = [];

  final isLoading = true.obs;

  Map<String, IconData> moduleIcons = {
    "CRM": FontAwesomeIcons.userGroup,
    "Selling": FontAwesomeIcons.cartShopping,
    "Buying": FontAwesomeIcons.bagShopping,
    "Stock": FontAwesomeIcons.boxesStacked,
    "Accounts": FontAwesomeIcons.fileInvoiceDollar,
    "HR": FontAwesomeIcons.userTie,
    "Projects": FontAwesomeIcons.diagramProject,
    "Support": FontAwesomeIcons.headset,
    "Manufacturing": FontAwesomeIcons.industry,
  };

  @override
  void onInit() {
    super.onInit();
    fetchAndStoreModules();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> fetchAndStoreModules() async {
    try {
      final response = await ApiService.get(
        ApiUri.getAllModule,
        params: {'fields': '["module_name"]', 'limit_page_length': '1000'},
      );

      if (response != null && response.statusCode == 200) {
        final List modules = response.data['data'];
        moduleNames = modules.map((e) => e['module_name'].toString()).toList();
        sortModuleNamesWithIcons(moduleNames);
      } else {
        print('❌ Failed to fetch modules');
      }
    } catch (e) {
      print("❌ Error fetching modules: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void sortModuleNamesWithIcons(List<String> moduleNames) {
    popularModules.clear();
    otherModules.clear();

    for (var name in moduleNames) {
      IconData icon = moduleIcons[name] ?? FontAwesomeIcons.cube;

      // Try to match with enum (case-insensitive)
      ModuleType? match;
      try {
        match = ModuleType.values.firstWhere(
              (e) => e.name.toLowerCase() == name.toLowerCase(),
        );
      } catch (_) {
        match = null;
      }

      ModuleItem item = ModuleItem(name: name, icon: icon);

      if (match != null) {
        popularModules.add(item);
      } else {
        otherModules.add(item);
      }
    }
    logger.d("popularModules: $popularModules");
    logger.d("otherModules: $otherModules");
    update();
  }

  Module? moduleFromString(String value) {
    return Module.values.firstWhere((e) => e.value == value);
  }

  void handleModuleOnTap(String moduleName) {
    final module = moduleFromString(moduleName);
    if (module == null) {
      print("Unknown module: $moduleName");
      return;
    }

    switch (module) {
      case Module.crm:
        Get.to(()=>CrmView());
        break;
      case Module.selling:
        Get.to(()=>SaleDashboardView());
        break;
      case Module.buying:
        Get.to(()=>PurchaseOrdersDashboardView());
        break;
      case Module.stock:
        Get.to(()=>StockDashboardView());

        break;

    // Add remaining cases as needed
      default:
        showSnackbar("Coming Soon", "$moduleName module is not ready yet.");
        print("Module ${module.value} is not yet handled.");
    }
  }

  void showSnackbar(String title, String message, {Color backgroundColor = Colors.indigo}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }



}

class ModuleItem {
  final String name;
  final IconData icon;

  ModuleItem({required this.name, required this.icon});

  @override
  String toString() => 'ModuleItem(name: $name)';
}