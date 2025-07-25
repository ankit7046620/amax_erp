

class ItemStockModel {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  var docstatus;
  var idx;
  String? itemCode;
  String? warehouse;
 var actualQty;
  var plannedQty;
  var indentedQty;
  var orderedQty;
 var projectedQty;
  var reservedQty;
 var reservedQtyForProduction;
  var reservedQtyForSubContract;
  var reservedQtyForProductionPlan;
  var reservedStock;
  String? stockUom;
 var valuationRate;
 var stockValue;

  ItemStockModel(
      {this.name,
        this.owner,
        this.creation,
        this.modified,
        this.modifiedBy,
        this.docstatus,
        this.idx,
        this.itemCode,
        this.warehouse,
        this.actualQty,
        this.plannedQty,
        this.indentedQty,
        this.orderedQty,
        this.projectedQty,
        this.reservedQty,
        this.reservedQtyForProduction,
        this.reservedQtyForSubContract,
        this.reservedQtyForProductionPlan,
        this.reservedStock,
        this.stockUom,
        this.valuationRate,
        this.stockValue});

  ItemStockModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    itemCode = json['item_code'];
    warehouse = json['warehouse'];
    actualQty = json['actual_qty'];
    plannedQty = json['planned_qty'];
    indentedQty = json['indented_qty'];
    orderedQty = json['ordered_qty'];
    projectedQty = json['projected_qty'];
    reservedQty = json['reserved_qty'];
    reservedQtyForProduction = json['reserved_qty_for_production'];
    reservedQtyForSubContract = json['reserved_qty_for_sub_contract'];
    reservedQtyForProductionPlan = json['reserved_qty_for_production_plan'];
    reservedStock = json['reserved_stock'];
    stockUom = json['stock_uom'];
    valuationRate = json['valuation_rate'];
    stockValue = json['stock_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['owner'] = this.owner;
    data['creation'] = this.creation;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    data['docstatus'] = this.docstatus;
    data['idx'] = this.idx;
    data['item_code'] = this.itemCode;
    data['warehouse'] = this.warehouse;
    data['actual_qty'] = this.actualQty;
    data['planned_qty'] = this.plannedQty;
    data['indented_qty'] = this.indentedQty;
    data['ordered_qty'] = this.orderedQty;
    data['projected_qty'] = this.projectedQty;
    data['reserved_qty'] = this.reservedQty;
    data['reserved_qty_for_production'] = this.reservedQtyForProduction;
    data['reserved_qty_for_sub_contract'] = this.reservedQtyForSubContract;
    data['reserved_qty_for_production_plan'] =
        this.reservedQtyForProductionPlan;
    data['reserved_stock'] = this.reservedStock;
    data['stock_uom'] = this.stockUom;
    data['valuation_rate'] = this.valuationRate;
    data['stock_value'] = this.stockValue;
    return data;
  }
}
