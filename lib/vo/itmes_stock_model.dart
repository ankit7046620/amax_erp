
class ItemStockModel {
  String? itemCode;
  String? warehouse;
  double? actualQty;
  double? valuationRate;
  double? reservedQty;

  ItemStockModel({this.itemCode, this.warehouse, this.actualQty, this.reservedQty, this.valuationRate});

  ItemStockModel.fromJson(Map<String, dynamic> json) {
    itemCode = json['item_code'];
    warehouse = json['warehouse'];
    actualQty = json['actual_qty'];
    valuationRate = json['valuation_rate'];
    reservedQty = json['reserved_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_code'] = itemCode;
    data['warehouse'] = warehouse;
    data['actual_qty'] = actualQty;
    data['valuation_rate'] = valuationRate;
    data['reserved_qty'] = reservedQty;
    return data;
  }
}
