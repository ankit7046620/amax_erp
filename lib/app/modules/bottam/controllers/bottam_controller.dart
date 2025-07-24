import 'package:amax_hr/app/modules/StockDashboard/views/stock_dashboard_view.dart';
import 'package:amax_hr/app/modules/crm/views/crm_view.dart';
import 'package:amax_hr/app/modules/purchaseOrdersDashboard/views/purchase_orders_dashboard_view.dart';
import 'package:amax_hr/app/routes/app_pages.dart';
import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:amax_hr/utils/app_funcation.dart';
import 'package:amax_hr/vo/WarehouseModel.dart';
import 'package:amax_hr/vo/crm_model.dart';
import 'package:amax_hr/vo/customer_list_model.dart';
import 'package:amax_hr/vo/purchase_order_model.dart';
import 'package:amax_hr/vo/sales_order.dart';
import 'package:amax_hr/vo/sell_order_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../saleDashboard/views/sale_dashboard_view.dart';

class BottamController extends GetxController {
  final count = 0.obs;
  List<String> moduleNames = [];
  final isLoading = true.obs;

  final warehouses = <WarehouseModel>[].obs;
  final totalWarehouses = 0.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAndStoreModules();
  }

  void increment() => count.value++;

  Module? moduleFromString(String value) {
    return Module.values.firstWhere((e) => e.value == value);
  }

  Map<String, dynamic> getModuleConfig(String moduleName) {
    final configs = {
      'Accounts': {'color': Colors.transparent, 'icon': FontAwesomeIcons.moneyBillTrendUp},
      'Assets': {'color': Colors.blue, 'icon': FontAwesomeIcons.building},
      'Automation': {'color': Colors.purple, 'icon': FontAwesomeIcons.robot},
      'BAPS': {'color': Colors.orange, 'icon': FontAwesomeIcons.chartColumn},
      'Bulk Transacti': {'color': Colors.indigo, 'icon': FontAwesomeIcons.truckRampBox},
      'Buying': {'color': Colors.teal, 'icon': FontAwesomeIcons.cartShopping},
      'CIS': {'color': Colors.cyan, 'icon': FontAwesomeIcons.idCard},
      'Communication': {'color': Colors.pink, 'icon': FontAwesomeIcons.comments},
      'Contacts': {'color': Colors.amber, 'icon': FontAwesomeIcons.addressBook},
      'Core': {'color': Colors.red, 'icon': FontAwesomeIcons.gear},
      'CRM': {'color': Colors.deepPurple, 'icon': FontAwesomeIcons.userTie},
      'Custom': {'color': Colors.brown, 'icon': FontAwesomeIcons.puzzlePiece},
      'Desk': {'color': Colors.lightGreen, 'icon': FontAwesomeIcons.desktop},
      'Email': {'color': Colors.blueGrey, 'icon': FontAwesomeIcons.envelope},
      'ERPNext Integr': {'color': Colors.deepOrange, 'icon': FontAwesomeIcons.plug},
      'File': {'color': Colors.grey, 'icon': FontAwesomeIcons.fileLines},
      'Geo': {'color': Colors.lightBlue, 'icon': FontAwesomeIcons.mapLocationDot},
      'HR': {'color': Colors.pinkAccent, 'icon': FontAwesomeIcons.usersGear},
      'Integrations': {'color': Colors.yellowAccent, 'icon': FontAwesomeIcons.link},
      'Maintenance': {'color': Colors.redAccent, 'icon': FontAwesomeIcons.screwdriverWrench},
      'Manufactoring': {'color': Colors.brown, 'icon': FontAwesomeIcons.industry},
      'Manufacturing': {'color': Colors.blueAccent, 'icon': FontAwesomeIcons.industry},
      'Payment Gatewa': {'color': Colors.green, 'icon': FontAwesomeIcons.creditCard},
      'Payments': {'color': Colors.greenAccent, 'icon': FontAwesomeIcons.wallet},
      'Payroll': {'color': Colors.tealAccent, 'icon': FontAwesomeIcons.moneyCheckDollar},
      'Portal': {'color': Colors.purpleAccent, 'icon': FontAwesomeIcons.globe},
      'Printing': {'color': Colors.orangeAccent, 'icon': FontAwesomeIcons.print},
      'Prods': {'color': Colors.lime, 'icon': FontAwesomeIcons.boxesStacked},
      'Projects': {'color': Colors.indigo, 'icon': FontAwesomeIcons.diagramProject},
      'Quality Manage': {'color': Colors.cyan, 'icon': FontAwesomeIcons.checkDouble},
      'Regional': {'color': Colors.amber, 'icon': FontAwesomeIcons.earthAsia},
      'Selling': {'color': Colors.pink, 'icon': FontAwesomeIcons.tags},
      'Setup': {'color': Colors.grey, 'icon': FontAwesomeIcons.tools},
      'Social': {'color': Colors.blue, 'icon': FontAwesomeIcons.shareNodes},
      'Stock': {'color': Colors.orange, 'icon': FontAwesomeIcons.boxesPacking},
      'Subcontracting': {'color': Colors.deepPurple, 'icon': FontAwesomeIcons.handshake},
      'Support': {'color': Colors.green, 'icon': FontAwesomeIcons.headset},
      'Telephony': {'color': Colors.red, 'icon': FontAwesomeIcons.phoneVolume},
      'Utilities': {'color': Colors.brown, 'icon': FontAwesomeIcons.toolbox},
      'Website': {'color': Colors.blue, 'icon': FontAwesomeIcons.windowMaximize},
      'Workflow': {'color': Colors.purple, 'icon': FontAwesomeIcons.diagramSuccessor},
      'X fieldss': {'color': Colors.grey, 'icon': FontAwesomeIcons.shapes},
    };

    return configs[moduleName] ?? {'color': Colors.grey, 'icon': FontAwesomeIcons.cubes};
  }










  void handleModule(String moduleName) {
    final module = moduleFromString(moduleName);
    if (module == null) {
      print("Unknown module: $moduleName");
      return;
    }

    switch (module) {
      case Module.crm:
        fetchLeadData();
        break;
      case Module.selling:
        fetchSellData();
        break;
      case Module.buying:
        fetchPurchaseData();
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

  Future<void> fetchAndStoreModules() async {
    try {
      final response = await ApiService.get(
        '/api/resource/Module Def',
        params: {'fields': '["module_name"]', 'limit_page_length': '1000'},
      );

      if (response != null && response.statusCode == 200) {
        final List modules = response.data['data'];
        moduleNames = modules.map((e) => e['module_name'].toString()).toList();

        // Print all module names
        moduleNames.forEach(print);
      } else {
        print('❌ Failed to fetch modules');
      }
    } catch (e) {
      print("❌ Error fetching modules: $e");
    } finally {
      isLoading.value = false; // ✅ Stop loader in any case
    }
  }

  Future<void> fetchLeadData() async {
    try {
      final response = await ApiService.get(
        '/api/resource/Lead',
        params: {
          'fields':
              '["name","lead_name","email_id","company_name","status","creation","modified","source","territory"]',
          'limit_page_length': '1000',
        },
      );

      if (response != null && response.statusCode == 200) {
        final List modules = response.data['data'];

        final CrmModel crmModel = CrmModel.fromJson({'data': modules});

        logger.d('crmModel===>#${crmModel.data.length}');

        Get.to(()=>CrmView(), arguments: {'module': 'crm', 'model': crmModel});
      } else {
        print('❌ Failed to fetch leads');
      }
    } catch (e) {
      print("❌ Error fetching leads: $e");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchSellData() async {
    EasyLoading.show();

    try {
      final response = await ApiService.get(
        '/api/resource/Sales Order?',
        params: {
          'fields':
              '["*"]',
          'limit_page_length': '1000',
        },
      );
      EasyLoading.dismiss();
      if (response != null && response.statusCode == 200) {
        final List modules = response.data['data'];

        List<SellOrderDataList>sellOrderDataList = (response.data['data'] as List)
            .map((e) => SellOrderDataList.fromJson(e))
            .toList();
        logger.d("sellOrderDataList::==>>${sellOrderDataList.length}");

        Get.to(()=>SaleDashboardView(), arguments: {'module': 'sale', 'model': sellOrderDataList});

      } else {
        EasyLoading.dismiss();
        print('❌ Failed to fetch leads');
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("❌ Error fetching leads: $e");
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }
  Future<void> fetchPurchaseData() async {
    EasyLoading.show();

    try {
      final response = await ApiService.get(
        '/api/resource/Purchase Order?',
        params: {
          'fields':
          '["*"]',
          'limit_page_length': '1000',
        },
      );
      EasyLoading.dismiss();
      if (response != null && response.statusCode == 200) {
         List<PurchaseOrderDataList> purchaselist = (response.data['data'] as List)
            .map((e) => PurchaseOrderDataList.fromJson(e))
            .toList();
        logger.d("purchaselist===${purchaselist.length}");
        Get.to(()=>PurchaseOrdersDashboardView(), arguments: {'module': 'purchase', 'model': purchaselist});

      } else {
        EasyLoading.dismiss();
        print('❌ Failed to fetch buys');
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("❌ Error fetching buys: $e");
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }



}
