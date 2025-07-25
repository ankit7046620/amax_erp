// lib/app/modules/StockDashboard/controllers/stock_dashboard_controller.dart
import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart' show ApiService;
import 'package:amax_hr/vo/WarehouseModel.dart' show WarehouseModel;
import 'package:amax_hr/vo/item_model.dart';
import 'package:amax_hr/vo/itmes_stock_model.dart';
import 'package:get/get.dart';

class StockDashboardController extends GetxController {
  // Observable variables
  final totalWarehouses = 0.obs;
  final warehouses = <WarehouseModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final totalActiveItems = 0.obs;
  final totalStockValue = ''.obs;

  RxList<WarehouseStockChartData> barChartData = <WarehouseStockChartData>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  // Load all APIs in parallel with shared loading state
  void loadAllData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchWarehouses(),
        fetchAllItems(),
        fetchStockData(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch warehouse data from API
  Future<void> fetchWarehouses() async {
    try {
      final response = await ApiService.get(
        'api/resource/Warehouse',
        params: {'fields': '["*"]', 'limit_page_length': '1000'},
      );

      if (response != null && response.statusCode == 200) {
        List<WarehouseModel> warehouseList = (response.data['data'] as List)
            .map((e) => WarehouseModel.fromJson(e))
            .toList();

        warehouses.value = warehouseList;
        totalWarehouses.value =
            warehouseList.where((w) => w.disabled != 1).length;

        logger.d("warehouseList===${warehouseList.length}");
      } else {
        errorMessage.value = 'Failed to fetch warehouses';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching warehouses: $e';
    }
  }

  Future<void> fetchAllItems() async {
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
        logger.d("itemsList===${itemsModel.length}");
      } else {
        errorMessage.value = 'Failed to fetch items';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching items: $e';
    }
  }

  Future<void> fetchStockData() async {
    try {
      final response = await ApiService.get(
        'api/resource/Bin?',
        params: {'fields': '["*"]', 'limit_page_length': '1000'},
      );

      if (response != null && response.statusCode == 200) {
        List<ItemStockModel> itemsModel = (response.data['data'] as List)
            .map((e) => ItemStockModel.fromJson(e))
            .toList();

        logger.d("fetchStockData===${itemsModel.length}");
        getStockValuation(itemsModel);
        generateWarehouseStockChartData(itemsModel);
      } else {
        errorMessage.value = 'Failed to fetch stock data';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching stock data: $e';
    }
  }

  double getStockValuation(List<ItemStockModel> items) {
    double totalValuation = 0.0;
    for (var item in items) {
      totalValuation += item.stockValue ?? 0.0;
    }
    logger.d("getStockValuation >>> ₹${totalValuation.toStringAsFixed(2)}");
    formatToCrore(totalValuation);
    return totalValuation;
  }

  String formatToCrore(double value) {
    double inCr = value / 10000000;
    totalStockValue.value = '${inCr.toStringAsFixed(3)} Cr';
    return '${inCr.toStringAsFixed(3)} Cr';
  }

  Future<void> refreshData() async {
    loadAllData();
  }

  List<WarehouseModel> getWarehousesByCompany(String company) {
    return warehouses
        .where((warehouse) => warehouse.company == company)
        .toList();
  }

  List<WarehouseModel> getActiveWarehouses() {
    return warehouses.where((warehouse) => warehouse.disabled == 0).toList();
  }

  List<WarehouseModel> getWarehouseGroups() {
    return warehouses.where((warehouse) => warehouse.isGroup == 1).toList();
  }

  List<WarehouseModel> getIndividualWarehouses() {
    return warehouses.where((warehouse) => warehouse.isGroup == 0).toList();
  }

  List<WarehouseModel> getRejectedWarehouses() {
    return warehouses.where((warehouse) => warehouse.isRejectedWarehouse == 1).toList();
  }

  void generateWarehouseStockChartData(List<ItemStockModel> itemsModel) {
    final Map<String, double> stockMap = {};
    for (var item in itemsModel) {
      final warehouse = item.warehouse ?? 'Unknown';
      final stockValue = item.stockValue ?? 0.0;
      stockMap[warehouse] = (stockMap[warehouse] ?? 0) + stockValue;
    }
    barChartData.value = stockMap.entries
        .map((entry) => WarehouseStockChartData(entry.key, entry.value))
        .toList();
  }
}

class WarehouseStockChartData {
  final String warehouse;
  final double totalStockValue;

  WarehouseStockChartData(this.warehouse, this.totalStockValue);
}