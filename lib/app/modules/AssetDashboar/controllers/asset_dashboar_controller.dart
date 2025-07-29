import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/vo/AssetDataModel.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AssetDashboardController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var totalAssets = 0.obs;
  var newAssetsThisYear = 0.obs;
  var totalAssetValue = "₹ 0.00 L".obs;
  var assetsList = <AssetData>[].obs;
  var barChartData = <AssetLocationChartData>[].obs;
  var categoryChartData = <AssetCategoryChartData>[].obs;
  var locationChartData = <AssetLocationChartData>[].obs;
  var assetValueAnalyticsData = <AssetValueAnalyticsData>[].obs;
  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
  @override
  void onInit() {
    super.onInit();
    fetchAssetData();
  }

  Future<void> fetchAssetData() async {
    isLoading.value = true;
    EasyLoading.show();

    try {
      final response = await ApiService.get(
        '/api/resource/Asset',
        params: {
          'fields': '["*"]',
          'limit_page_length': '1000',
        },
      );

      EasyLoading.dismiss();

      if (response != null && response.statusCode == 200) {
        List<AssetData> assets = (response.data['data'] as List)
            .map((e) => AssetData.fromJson(e))
            .toList();

        assetsList.value = assets;
        logger.d("assets list === ${assets.length}");

        // Calculate dashboard metrics
        calculateDashboardMetrics(assets);

        // Prepare chart data
        prepareChartData(assets);
        prepareCategoryChartData(assets);
        prepareLocationChartData(assets);
        prepareAssetValueAnalyticsData(assets);

      } else {
        EasyLoading.dismiss();
        print('❌ Failed to fetch assets');
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("❌ Error fetching assets: $e");
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

  void calculateDashboardMetrics(List<AssetData> assets) {
    // Filter active assets (not cancelled or draft)
    final activeAssets = assets.where((asset) =>
    asset.status != "Cancelled" && asset.status != "Draft").toList();

    totalAssets.value = activeAssets.length;

    // Calculate new assets this year (2025)
    final currentYear = DateTime.now().year;
    newAssetsThisYear.value = activeAssets.where((asset) {
      if (asset.creation != null) {
        final creationDate = DateTime.tryParse(asset.creation!);
        return creationDate?.year == currentYear;
      }
      return false;
    }).length;

    // Calculate total asset value
    double totalValue = 0.0;
    for (var asset in activeAssets) {
      totalValue += asset.totalAssetCost ?? 0.0;
    }

    // Convert to Lakhs and format
    double valueInLakhs = totalValue / 100000;
    totalAssetValue.value = "₹ ${valueInLakhs.toStringAsFixed(2)} L";
  }

  void prepareChartData(List<AssetData> assets) {
    // Filter active assets
    final activeAssets = assets.where((asset) =>
    asset.status != "Cancelled" && asset.status != "Draft").toList();

    // Group by location and calculate total value
    Map<String, double> locationValues = {};

    for (var asset in activeAssets) {
      String location = asset.location?.isNotEmpty == true
          ? asset.location!
          : "Unassigned";

      locationValues[location] = (locationValues[location] ?? 0.0) +
          (asset.totalAssetCost ?? 0.0);
    }

    // Convert to chart data
    barChartData.value = locationValues.entries
        .map((entry) => AssetLocationChartData(
      location: entry.key,
      totalAssetValue: entry.value / 100000, // Convert to Lakhs
    ))
        .toList();
  }

  void prepareCategoryChartData(List<AssetData> assets) {
    // Filter active assets
    final activeAssets = assets.where((asset) =>
    asset.status != "Cancelled" && asset.status != "Draft").toList();

    // Group by category and calculate total value
    Map<String, double> categoryValues = {};

    for (var asset in activeAssets) {
      String category = asset.assetCategory?.isNotEmpty == true
          ? asset.assetCategory!
          : "Uncategorized";

      categoryValues[category] = (categoryValues[category] ?? 0.0) +
          (asset.totalAssetCost ?? 0.0);
    }

    // Convert to chart data
    categoryChartData.value = categoryValues.entries
        .map((entry) => AssetCategoryChartData(
      category: entry.key,
      value: entry.value,
    ))
        .toList();
  }

  void prepareLocationChartData(List<AssetData> assets) {
    // Filter active assets
    final activeAssets = assets.where((asset) =>
    asset.status != "Cancelled" && asset.status != "Draft").toList();

    // Group by location and calculate total value
    Map<String, double> locationValues = {};

    for (var asset in activeAssets) {
      String location = asset.location?.isNotEmpty == true
          ? asset.location!
          : "Unassigned";

      locationValues[location] = (locationValues[location] ?? 0.0) +
          (asset.totalAssetCost ?? 0.0);
    }

    // Convert to chart data for pie chart
    locationChartData.value = locationValues.entries
        .map((entry) => AssetLocationChartData(
      location: entry.key,
      totalAssetValue: entry.value,
    ))
        .toList();
  }

  void prepareAssetValueAnalyticsData(List<AssetData> assets) {
    // Filter active assets
    final activeAssets = assets.where((asset) =>
    asset.status != "Cancelled" && asset.status != "Draft").toList();

    // Calculate total asset value and depreciated amount
    double totalAssetValue = 0.0;
    double totalDepreciatedAmount = 0.0;

    for (var asset in activeAssets) {
      totalAssetValue += asset.totalAssetCost ?? 0.0;
      // Calculate depreciated amount (total cost - value after depreciation)
      double depreciatedAmount = (asset.totalAssetCost ?? 0.0) -
          (asset.valueAfterDepreciation ?? 0.0);
      totalDepreciatedAmount += depreciatedAmount;
    }

    assetValueAnalyticsData.value = [
      AssetValueAnalyticsData(
        type: "Asset Value",
        value: totalAssetValue,
      ),
      AssetValueAnalyticsData(
        type: "Depreciated Amount",
        value: totalDepreciatedAmount,
      ),
    ];
  }

  Future<void> refreshData() async {
    await fetchAssetData();
  }
}

// Chart Data Models
class AssetLocationChartData {
  final String location;
  final double totalAssetValue;

  AssetLocationChartData({
    required this.location,
    required this.totalAssetValue,
  });
}

class AssetCategoryChartData {
  final String category;
  final double value;

  AssetCategoryChartData({
    required this.category,
    required this.value,
  });
}

class AssetValueAnalyticsData {
  final String type;
  final double value;

  AssetValueAnalyticsData({
    required this.type,
    required this.value,
  });
}