// controllers/stock_dashboard_controller.dart
import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart' show ApiService;
import 'package:amax_hr/vo/WarehouseModel.dart' show WarehouseModel;
import 'package:amax_hr/vo/item_model.dart';
import 'package:amax_hr/vo/itmes_stock_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class StockDashboardController extends GetxController {
  // Observable variables
  final totalWarehouses = 0.obs;
  final warehouses = <WarehouseModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Additional metrics (you can extend these based on your needs)
  final totalActiveItems = 0.obs; // Static for now, you can make it dynamic
  final totalStockValue =
      ''.obs; // Static for now, you can make it dynamic

  @override
  void onInit() {
    super.onInit();
    fetchWarehouses();
    fetchAllItems();
    fetchStockData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Fetch warehouse data from API
  Future<void> fetchWarehouses() async {
    EasyLoading.show();

    try {
      final response = await ApiService.get(
        'api/resource/Warehouse',
        params: {'fields': '["*"]', 'limit_page_length': '1000'},
      );

      if (response != null && response.statusCode == 200) {
        List<WarehouseModel> warehouseList = (response.data['data'] as List)
            .map((e) => WarehouseModel.fromJson(e))
            .toList();

        // Update observable variables
        warehouses.value = warehouseList;
        totalWarehouses.value = warehouseList.length;

        logger.d("warehouseList===${warehouseList.length}");

        // Optional: If you want to navigate to another view
        // Get.to(() => StockDashboardView(), arguments: {'module': 'warehouse', 'model': warehouseList});
      } else {
        print('❌ Failed to fetch warehouses');
        errorMessage.value = 'Failed to fetch warehouses';
      }
    } catch (e) {
      print("❌ Error fetching warehouses: $e");
      errorMessage.value = 'Error fetching warehouses: $e';
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

  Future<void> fetchAllItems() async {
    EasyLoading.show();

    try {
      final response = await ApiService.get(
        'api/resource/Item',

        params: {'fields': '["*"]', 'limit_page_length': '1000'},
      );

      if (response != null && response.statusCode == 200) {
        List<ItemsModel> itemsModel = (response.data['data'] as List)
            .map((e) => ItemsModel.fromJson(e))
            .toList();

        totalActiveItems.value = itemsModel.length;
        logger.d("warehouseList===${itemsModel.length}");
      } else {
        print('❌ Failed to fetch warehouses');
        errorMessage.value = 'Failed to fetch warehouses';
      }
    } catch (e) {
      print("❌ Error fetching warehouses: $e");
      errorMessage.value = 'Error fetching warehouses: $e';
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }
  Future<void> fetchStockData() async {
    EasyLoading.show();

    try {
      final response = await ApiService.get(
        'api/resource/Bin?',

        params: {'fields': '["*"]', 'limit_page_length': '1000'},
      );

      if (response != null && response.statusCode == 200) {
        List<ItemStockModel> itemsModel = (response.data['data'] as List)
            .map((e) => ItemStockModel.fromJson(e))
            .toList();
        getStockValuation(itemsModel);


      } else {
        print('❌ Failed to fetch warehouses');
        errorMessage.value = 'Failed to fetch warehouses';
      }
    } catch (e) {
      print("❌ Error fetching warehouses: $e");
      errorMessage.value = 'Error fetching warehouses: $e';
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }


  double getStockValuation(List<ItemStockModel> items) {
    double totalValuation = 0.0;

    for (var item in items) {
      final qty = item.actualQty ?? 0;
      final rate = item.valuationRate ?? 0;

      // ✅ Only include if both are non-zero
      if (qty > 0 && rate > 0) {
        totalValuation += qty * rate;
        formatToCrore(totalValuation);
      }
    }

    logger.d("getStockValuation >>> ₹${totalValuation.toStringAsFixed(2)}");
    return totalValuation;
  }

  String formatToCrore(double value) {
    double inCr = value / 10000000; // 1 crore = 1 crore = 10^7

    totalStockValue.value='${inCr.toStringAsFixed(3)} Cr';
    return '${inCr.toStringAsFixed(3)} Cr';
  }


  // Refresh data
  Future<void> refreshData() async {
    await fetchWarehouses();
  }

  // Get warehouses by company
  List<WarehouseModel> getWarehousesByCompany(String company) {
    return warehouses
        .where((warehouse) => warehouse.company == company)
        .toList();
  }

  // Get active warehouses (not disabled)
  List<WarehouseModel> getActiveWarehouses() {
    return warehouses.where((warehouse) => warehouse.disabled == 0).toList();
  }

  // Get warehouse groups
  List<WarehouseModel> getWarehouseGroups() {
    return warehouses.where((warehouse) => warehouse.isGroup == 1).toList();
  }

  // Get individual warehouses (not groups)
  List<WarehouseModel> getIndividualWarehouses() {
    return warehouses.where((warehouse) => warehouse.isGroup == 0).toList();
  }
}
