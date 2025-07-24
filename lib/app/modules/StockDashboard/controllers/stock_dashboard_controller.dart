// controllers/stock_dashboard_controller.dart
import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart' show ApiService;
import 'package:amax_hr/vo/WarehouseModel.dart' show WarehouseModel;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';


class StockDashboardController extends GetxController {
  // Observable variables
  final totalWarehouses = 0.obs;
  final warehouses = <WarehouseModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Additional metrics (you can extend these based on your needs)
  final totalActiveItems = 93.obs; // Static for now, you can make it dynamic
  final totalStockValue = '51.350 L'.obs; // Static for now, you can make it dynamic

  @override
  void onInit() {
    super.onInit();
    fetchWarehouses();
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
        params: {
          'fields': '["*"]',
          'limit_page_length': '1000',
        },
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

  // Refresh data
  Future<void> refreshData() async {
    await fetchWarehouses();
  }

  // Get warehouses by company
  List<WarehouseModel> getWarehousesByCompany(String company) {
    return warehouses.where((warehouse) => warehouse.company == company).toList();
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