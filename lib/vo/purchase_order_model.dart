// To parse this JSON data, do
//
//     final purchaseOrder = purchaseOrderFromJson(jsonString);

import 'dart:convert';

PurchaseOrder purchaseOrderFromJson(String str) => PurchaseOrder.fromJson(json.decode(str));
String purchaseOrderToJson(PurchaseOrder data) => json.encode(data.toJson());

class PurchaseOrder {
  List<PurchaseOrderDataList>? data;

  PurchaseOrder({this.data});

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) => PurchaseOrder(
    data: json["data"] == null
        ? []
        : List<PurchaseOrderDataList>.from(
        json["data"].map((x) => PurchaseOrderDataList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.map((x) => x.toJson()).toList(),
  };
}

class PurchaseOrderDataList {
  String? name;
  String? owner;
  DateTime? creation;
  DateTime? modified;
  String? modifiedBy;
  dynamic docstatus;
  dynamic idx;
  String? title;
  String? namingSeries;
  String? supplier;
  String? supplierName;
  dynamic orderConfirmationNo;
  dynamic orderConfirmationDate;
  DateTime? transactionDate;
  DateTime? scheduleDate;
  String? company;
  dynamic applyTds;
  dynamic taxWithholdingCategory;
  dynamic isSubcontracted;
  dynamic supplierWarehouse;
  dynamic amendedFrom;
  dynamic costCenter;
  dynamic project;
  String? currency;
  dynamic conversionRate;
  String? buyingPriceList;
  String? priceListCurrency;
  dynamic plcConversionRate;
  dynamic ignorePricingRule;
  dynamic scanBarcode;
  dynamic setFromWarehouse;
  String? setWarehouse;
  dynamic totalQty;
  dynamic totalNetWeight;
  dynamic baseTotal;
  dynamic baseNetTotal;
  dynamic total;
  dynamic netTotal;
  dynamic taxWithholdingNetTotal;
  dynamic baseTaxWithholdingNetTotal;
  dynamic setReserveWarehouse;
  String? taxCategory;
  String? taxesAndCharges;
  dynamic shippingRule;
  dynamic incoterm;
  dynamic namedPlace;
  dynamic baseTaxesAndChargesAdded;
  dynamic baseTaxesAndChargesDeducted;
  dynamic baseTotalTaxesAndCharges;
  dynamic taxesAndChargesAdded;
  dynamic taxesAndChargesDeducted;
  dynamic totalTaxesAndCharges;
  dynamic baseGrandTotal;
  dynamic baseRoundingAdjustment;
  String? baseInWords;
  dynamic baseRoundedTotal;
  dynamic grandTotal;
  dynamic roundingAdjustment;
  dynamic roundedTotal;
  dynamic disableRoundedTotal;
  String? inWords;
  dynamic advancePaid;
  String? applyDiscountOn;
  dynamic baseDiscountAmount;
  dynamic additionalDiscountPercentage;
  dynamic discountAmount;
  String? otherChargesCalculation;
  String? supplierAddress;
  String? addressDisplay;
  dynamic contactPerson;
  dynamic contactDisplay;
  dynamic contactMobile;
  dynamic contactEmail;
  dynamic shippingAddress;
  dynamic shippingAddressDisplay;
  dynamic billingAddress;
  dynamic billingAddressDisplay;
  dynamic customer;
  dynamic customerName;
  dynamic customerContactPerson;
  dynamic customerContactDisplay;
  dynamic customerContactMobile;
  dynamic customerContactEmail;
  String? paymentTermsTemplate;
  String? tcName;
  String? terms;
  String? status;
  dynamic perBilled;
  dynamic perReceived;
  String? letterHead;
  dynamic groupSameItems;
  dynamic selectPrintHeading;
  String? language;
  dynamic fromDate;
  dynamic toDate;
  dynamic autoRepeat;
  dynamic isInternalSupplier;
  String? representsCompany;
  dynamic refSq;
  String? partyAccountCurrency;
  dynamic interCompanyOrderReference;
  dynamic isOldSubcontractingFlow;

  PurchaseOrderDataList({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.docstatus,
    this.idx,
    this.title,
    this.namingSeries,
    this.supplier,
    this.supplierName,
    this.orderConfirmationNo,
    this.orderConfirmationDate,
    this.transactionDate,
    this.scheduleDate,
    this.company,
    this.applyTds,
    this.taxWithholdingCategory,
    this.isSubcontracted,
    this.supplierWarehouse,
    this.amendedFrom,
    this.costCenter,
    this.project,
    this.currency,
    this.conversionRate,
    this.buyingPriceList,
    this.priceListCurrency,
    this.plcConversionRate,
    this.ignorePricingRule,
    this.scanBarcode,
    this.setFromWarehouse,
    this.setWarehouse,
    this.totalQty,
    this.totalNetWeight,
    this.baseTotal,
    this.baseNetTotal,
    this.total,
    this.netTotal,
    this.taxWithholdingNetTotal,
    this.baseTaxWithholdingNetTotal,
    this.setReserveWarehouse,
    this.taxCategory,
    this.taxesAndCharges,
    this.shippingRule,
    this.incoterm,
    this.namedPlace,
    this.baseTaxesAndChargesAdded,
    this.baseTaxesAndChargesDeducted,
    this.baseTotalTaxesAndCharges,
    this.taxesAndChargesAdded,
    this.taxesAndChargesDeducted,
    this.totalTaxesAndCharges,
    this.baseGrandTotal,
    this.baseRoundingAdjustment,
    this.baseInWords,
    this.baseRoundedTotal,
    this.grandTotal,
    this.roundingAdjustment,
    this.roundedTotal,
    this.disableRoundedTotal,
    this.inWords,
    this.advancePaid,
    this.applyDiscountOn,
    this.baseDiscountAmount,
    this.additionalDiscountPercentage,
    this.discountAmount,
    this.otherChargesCalculation,
    this.supplierAddress,
    this.addressDisplay,
    this.contactPerson,
    this.contactDisplay,
    this.contactMobile,
    this.contactEmail,
    this.shippingAddress,
    this.shippingAddressDisplay,
    this.billingAddress,
    this.billingAddressDisplay,
    this.customer,
    this.customerName,
    this.customerContactPerson,
    this.customerContactDisplay,
    this.customerContactMobile,
    this.customerContactEmail,
    this.paymentTermsTemplate,
    this.tcName,
    this.terms,
    this.status,
    this.perBilled,
    this.perReceived,
    this.letterHead,
    this.groupSameItems,
    this.selectPrintHeading,
    this.language,
    this.fromDate,
    this.toDate,
    this.autoRepeat,
    this.isInternalSupplier,
    this.representsCompany,
    this.refSq,
    this.partyAccountCurrency,
    this.interCompanyOrderReference,
    this.isOldSubcontractingFlow,
  });

  factory PurchaseOrderDataList.fromJson(Map<String, dynamic> json) => PurchaseOrderDataList(
    name: json["name"],
    docstatus: json['docstatus'],
    owner: json["owner"],
    creation: json["creation"] == null ? null : DateTime.tryParse(json["creation"]),
    modified: json["modified"] == null ? null : DateTime.tryParse(json["modified"]),
    modifiedBy: json["modified_by"],
    title: json["title"],
    baseNetTotal: json['base_net_total'],
    namingSeries: json["naming_series"],
    supplier: json["supplier"],
    supplierName: json["supplier_name"],
    transactionDate: json["transaction_date"] == null ? null : DateTime.tryParse(json["transaction_date"]),
    scheduleDate: json["schedule_date"] == null ? null : DateTime.tryParse(json["schedule_date"]),
    company: json["company"],
    currency: json["currency"],
    grandTotal: json["grand_total"],
    buyingPriceList: json["buying_price_list"],
    priceListCurrency: json["price_list_currency"],
    taxCategory: json["tax_category"],
    applyDiscountOn: json["apply_discount_on"],
    status: json["status"],
    language: json["language"],
    partyAccountCurrency: json["party_account_currency"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "docstatus":docstatus,
    "owner": owner,
    "creation": creation?.toIso8601String(),
    "modified": modified?.toIso8601String(),
    "modified_by": modifiedBy,
    "title": title,
    "naming_series": namingSeries,
    "supplier": supplier,
    "supplier_name": supplierName,
    "transaction_date": transactionDate?.toIso8601String(),
    "schedule_date": scheduleDate?.toIso8601String(),
    "company": company,
    "currency": currency,
    "base_net_total":baseNetTotal,
    "buying_price_list": buyingPriceList,
    "price_list_currency": priceListCurrency,
    "tax_category": taxCategory,
    "apply_discount_on": applyDiscountOn,
    "status": status,
    "grand_total": grandTotal,
    "language": language,
    "party_account_currency": partyAccountCurrency,
  };
}
