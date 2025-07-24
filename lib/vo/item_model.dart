class   ItemsModel {
  final String? itemCode;
  final String? itemName;
  final double? actualQty;
  final double? valuationRate;
  final bool? isStockItem;
  final bool? disabled;

  ItemsModel({
    this.itemCode,
    this.itemName,
    this.actualQty,
    this.valuationRate,
    this.isStockItem,
    this.disabled,
  });

  factory ItemsModel.fromJson(Map<String, dynamic> json) {
    return ItemsModel(
      itemCode: json['item_code'],
      itemName: json['item_name'],
      actualQty: (json['actual_qty'] ?? 0).toDouble(),
      valuationRate: (json['valuation_rate'] ?? 0).toDouble(),
      isStockItem: json['is_stock_item'] == 1,
      disabled: json['disabled'] == 1,
    );
  }
}
