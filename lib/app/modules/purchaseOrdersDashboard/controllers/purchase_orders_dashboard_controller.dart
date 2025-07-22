import 'package:get/get.dart';
import 'package:amax_hr/main.dart';
import 'package:amax_hr/vo/purchase_order_model.dart';

class ChartFilterType {
  static const String yearly = 'Yearly';
  static const String quarterly = 'Quarterly';
  static const String monthly = 'Monthly';
  static const String weekly = 'Weekly';
  static const String daily = 'Daily';
}

class PurchaseOrdersDashboardController extends GetxController {
  // Observable variables
  final count = 0.obs;
  final RxDouble totalPurchaseAmount = 0.0.obs;

  // Purchase order data
  List<Datum> purchaseOrders = [];

  // Chart filter types
  static const List<String> chartFilters = [
    ChartFilterType.yearly,
    ChartFilterType.quarterly,
    ChartFilterType.monthly,
    ChartFilterType.weekly,
    ChartFilterType.daily,
  ];

  // Chart type mapping for each card
  final RxMap<String, RxString> chartTypeMap = {
    'ANNUAL PURCHASES': ChartFilterType.monthly.obs,
    'Purchase Orders to Receive': ChartFilterType.monthly.obs,
    'Purchase Orders to Bill': ChartFilterType.monthly.obs,
    'Active Suppliers': ChartFilterType.monthly.obs,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPassedData();
  }

  void _loadPassedData() {
    final args = Get.arguments;
    logger.d('✅ Purchase data args: $args');

    if (args is Map && args.containsKey('model')) {
      final purchaseOrderModel = args['model'];
      if (purchaseOrderModel is PurchaseOrder && purchaseOrderModel.data != null) {
        purchaseOrders = purchaseOrderModel.data!;
        _calculateInitialValues();
        logger.d('✅ Loaded ${purchaseOrders.length} purchase order items');
      } else {
        logger.e('❌ PurchaseOrder model is invalid or missing data');
      }
    } else {
      logger.e('❌ Invalid or missing purchase data in arguments');
    }
  }

  void _calculateInitialValues() {
    // Calculate initial total purchase amount with default monthly filter
    totalPurchaseAmount.value = calculateFilteredTotal(
        purchaseOrders,
        ChartFilterType.monthly
    );
  }

  // Calculate filtered total based on chart type
  double calculateFilteredTotal(List<Datum> orders, String filterType) {
    double total = 0.0;
    final now = DateTime.now();

    for (var order in orders) {
      if (order.transactionDate == null || order.baseNetTotal == null) continue;

      final date = order.transactionDate!;
      final baseNetTotal = order.baseNetTotal?.toDouble() ?? 0.0;

      bool includeInTotal = false;

      switch (filterType.toLowerCase()) {
        case 'monthly':
          includeInTotal = date.month == now.month && date.year == now.year;
          break;
        case 'weekly':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));
          includeInTotal = !date.isBefore(weekStart) && !date.isAfter(weekEnd);
          break;
        case 'quarterly':
          final quarter = ((now.month - 1) ~/ 3) + 1;
          final dateQuarter = ((date.month - 1) ~/ 3) + 1;
          includeInTotal = date.year == now.year && dateQuarter == quarter;
          break;
        case 'yearly':
          includeInTotal = date.year == now.year;
          break;
        case 'daily':
          includeInTotal = date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
          break;
      }

      if (includeInTotal) {
        total += baseNetTotal;
      }
    }

    logger.d("💰 Filtered Purchase Total for [$filterType]: ₹$total");
    return total;
  }

  // Get pending orders to receive
  List<Datum> getPendingOrdersToReceive() {
    return purchaseOrders.where((order) {
      return order.status == Status.TO_RECEIVE_AND_BILL ||
          (order.perReceived != null && order.perReceived! < 100);
    }).toList();
  }

  // Get pending orders to bill
  List<Datum> getPendingOrdersToBill() {
    return purchaseOrders.where((order) {
      return order.status == Status.TO_RECEIVE_AND_BILL ||
          (order.perBilled != null && order.perBilled! < 100);
    }).toList();
  }

  // Get active suppliers
  List<String> getActiveSuppliers() {
    final suppliers = <String>{};
    for (var order in purchaseOrders) {
      if (order.supplier != null &&
          order.status != Status.CANCELLED &&
          order.status != Status.DRAFT) {
        suppliers.add(order.supplier!);
      }
    }
    return suppliers.toList();
  }

  // Get filtered pending orders to receive based on chart type
  List<Datum> getFilteredPendingOrdersToReceive(String filterType) {
    final pendingOrders = getPendingOrdersToReceive();
    return _filterOrdersByDateRange(pendingOrders, filterType);
  }

  // Get filtered pending orders to bill based on chart type
  List<Datum> getFilteredPendingOrdersToBill(String filterType) {
    final pendingOrders = getPendingOrdersToBill();
    return _filterOrdersByDateRange(pendingOrders, filterType);
  }

  // Get filtered active suppliers based on chart type
  List<String> getFilteredActiveSuppliers(String filterType) {
    final filteredOrders = _filterOrdersByDateRange(purchaseOrders, filterType);
    final suppliers = <String>{};

    for (var order in filteredOrders) {
      if (order.supplier != null &&
          order.status != Status.CANCELLED &&
          order.status != Status.DRAFT) {
        suppliers.add(order.supplier!);
      }
    }
    return suppliers.toList();
  }

  // Helper method to filter orders by date range
  List<Datum> _filterOrdersByDateRange(List<Datum> orders, String filterType) {
    final now = DateTime.now();

    return orders.where((order) {
      if (order.transactionDate == null) return false;

      final date = order.transactionDate!;

      switch (filterType.toLowerCase()) {
        case 'monthly':
          return date.month == now.month && date.year == now.year;
        case 'weekly':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));
          return !date.isBefore(weekStart) && !date.isAfter(weekEnd);
        case 'quarterly':
          final quarter = ((now.month - 1) ~/ 3) + 1;
          final dateQuarter = ((date.month - 1) ~/ 3) + 1;
          return date.year == now.year && dateQuarter == quarter;
        case 'yearly':
          return date.year == now.year;
        case 'daily':
          return date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
        default:
          return true;
      }
    }).toList();
  }

  // Update chart filter and recalculate values
  void updateChartFilter(String cardTitle, String newFilter) {
    chartTypeMap[cardTitle]?.value = newFilter;

    // Update values based on the card that changed
    switch (cardTitle) {
      case 'ANNUAL PURCHASES':
        totalPurchaseAmount.value = calculateFilteredTotal(purchaseOrders, newFilter);
        break;
      case 'Purchase Orders to Receive':
      // The view will automatically update by calling getFilteredPendingOrdersToReceive
        break;
      case 'Purchase Orders to Bill':
      // The view will automatically update by calling getFilteredPendingOrdersToBill
        break;
      case 'Active Suppliers':
      // The view will automatically update by calling getFilteredActiveSuppliers
        break;
    }

    logger.d("📊 Updated $cardTitle filter to: $newFilter");
    update(); // Trigger UI update
  }

  // Get count for specific card with current filter
  dynamic getCountForCard(String cardTitle) {
    final currentFilter = chartTypeMap[cardTitle]?.value ?? ChartFilterType.monthly;

    switch (cardTitle) {
      case 'ANNUAL PURCHASES':
        return totalPurchaseAmount.value;
      case 'Purchase Orders to Receive':
        return getFilteredPendingOrdersToReceive(currentFilter).length;
      case 'Purchase Orders to Bill':
        return getFilteredPendingOrdersToBill(currentFilter).length;
      case 'Active Suppliers':
        return getFilteredActiveSuppliers(currentFilter).length;
      default:
        return 0;
    }
  }

  // Get purchase orders by status
  List<Datum> getPurchaseOrdersByStatus(Status status) {
    return purchaseOrders.where((order) => order.status == status).toList();
  }

  // Get purchase orders by supplier
  List<Datum> getPurchaseOrdersBySupplier(String supplier) {
    return purchaseOrders.where((order) => order.supplier == supplier).toList();
  }

  // Get purchase orders by date range
  List<Datum> getPurchaseOrdersByDateRange(DateTime startDate, DateTime endDate) {
    return purchaseOrders.where((order) {
      if (order.transactionDate == null) return false;
      return order.transactionDate!.isAfter(startDate.subtract(const Duration(days: 1))) &&
          order.transactionDate!.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  // Get total amount for specific supplier
  double getTotalAmountBySupplier(String supplier, String filterType) {
    final supplierOrders = purchaseOrders.where((order) => order.supplier == supplier).toList();
    return calculateFilteredTotal(supplierOrders, filterType);
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
}