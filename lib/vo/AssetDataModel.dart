class AssetData {
  final String? name;
  final String? assetName;
  final String? assetCategory;
  final String? location;
  final String? status;
  final double? totalAssetCost;
  final String? creation;
  final String? company;
  final String? itemCode;
  final String? itemName;
  final String? purchaseDate;
  final double? valueAfterDepreciation;

  AssetData({
    this.name,
    this.assetName,
    this.assetCategory,
    this.location,
    this.status,
    this.totalAssetCost,
    this.creation,
    this.company,
    this.itemCode,
    this.itemName,
    this.purchaseDate,
    this.valueAfterDepreciation,
  });

  factory AssetData.fromJson(Map<String, dynamic> json) {
    return AssetData(
      name: json['name'],
      assetName: json['asset_name'],
      assetCategory: json['asset_category'],
      location: json['location'],
      status: json['status'],
      totalAssetCost: json['total_asset_cost']?.toDouble(),
      creation: json['creation'],
      company: json['company'],
      itemCode: json['item_code'],
      itemName: json['item_name'],
      purchaseDate: json['purchase_date'],
      valueAfterDepreciation: json['value_after_depreciation']?.toDouble(),
    );
  }
}

// Chart Data Model
class AssetLocationChartData {
  final String location;
  final double totalAssetValue;

  AssetLocationChartData({
    required this.location,
    required this.totalAssetValue,
  });
}