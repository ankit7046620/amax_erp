// To parse this JSON data, do
//
//     final purchaseOrder = purchaseOrderFromJson(jsonString);

import 'dart:convert';

PurchaseOrder purchaseOrderFromJson(String str) => PurchaseOrder.fromJson(json.decode(str));

String purchaseOrderToJson(PurchaseOrder data) => json.encode(data.toJson());

class PurchaseOrder {
  List<Datum>? data;

  PurchaseOrder({
    this.data,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) => PurchaseOrder(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? name;
  ModifiedBy? owner;
  DateTime? creation;
  DateTime? modified;
  ModifiedBy? modifiedBy;
  int? docstatus;
  int? idx;
  Title? title;
  NamingSeries? namingSeries;
  String? supplier;
  String? supplierName;
  dynamic orderConfirmationNo;
  dynamic orderConfirmationDate;
  DateTime? transactionDate;
  DateTime? scheduleDate;
  Company? company;
  int? applyTds;
  dynamic taxWithholdingCategory;
  int? isSubcontracted;
  dynamic supplierWarehouse;
  dynamic amendedFrom;
  dynamic costCenter;
  dynamic project;
  Currency? currency;
  int? conversionRate;
  BuyingPriceList? buyingPriceList;
  Currency? priceListCurrency;
  int? plcConversionRate;
  int? ignorePricingRule;
  dynamic scanBarcode;
  dynamic setFromWarehouse;
  String? setWarehouse;
  int? totalQty;
  int? totalNetWeight;
  int? baseTotal;
  int? baseNetTotal;
  int? total;
  int? netTotal;
  int? taxWithholdingNetTotal;
  int? baseTaxWithholdingNetTotal;
  dynamic setReserveWarehouse;
  TaxCategory? taxCategory;
  String? taxesAndCharges;
  dynamic shippingRule;
  dynamic incoterm;
  dynamic namedPlace;
  int? baseTaxesAndChargesAdded;
  int? baseTaxesAndChargesDeducted;
  int? baseTotalTaxesAndCharges;
  int? taxesAndChargesAdded;
  int? taxesAndChargesDeducted;
  int? totalTaxesAndCharges;
  int? baseGrandTotal;
  int? baseRoundingAdjustment;
  String? baseInWords;
  int? baseRoundedTotal;
  int? grandTotal;
  int? roundingAdjustment;
  int? roundedTotal;
  int? disableRoundedTotal;
  String? inWords;
  int? advancePaid;
  ApplyDiscountOn? applyDiscountOn;
  int? baseDiscountAmount;
  int? additionalDiscountPercentage;
  int? discountAmount;
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
  Status? status;
  int? perBilled;
  int? perReceived;
  String? letterHead;
  int? groupSameItems;
  dynamic selectPrintHeading;
  Language? language;
  dynamic fromDate;
  dynamic toDate;
  dynamic autoRepeat;
  int? isInternalSupplier;
  String? representsCompany;
  dynamic refSq;
  Currency? partyAccountCurrency;
  dynamic interCompanyOrderReference;
  int? isOldSubcontractingFlow;

  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    owner: modifiedByValues.map[json["owner"]]!,
    creation: json["creation"] == null ? null : DateTime.parse(json["creation"]),
    modified: json["modified"] == null ? null : DateTime.parse(json["modified"]),
    modifiedBy: modifiedByValues.map[json["modified_by"]]!,
    docstatus: json["docstatus"],
    idx: json["idx"],
    title: titleValues.map[json["title"]]!,
    namingSeries: namingSeriesValues.map[json["naming_series"]]!,
    supplier: json["supplier"],
    supplierName: json["supplier_name"],
    orderConfirmationNo: json["order_confirmation_no"],
    orderConfirmationDate: json["order_confirmation_date"],
    transactionDate: json["transaction_date"] == null ? null : DateTime.parse(json["transaction_date"]),
    scheduleDate: json["schedule_date"] == null ? null : DateTime.parse(json["schedule_date"]),
    company: companyValues.map[json["company"]]!,
    applyTds: json["apply_tds"],
    taxWithholdingCategory: json["tax_withholding_category"],
    isSubcontracted: json["is_subcontracted"],
    supplierWarehouse: json["supplier_warehouse"],
    amendedFrom: json["amended_from"],
    costCenter: json["cost_center"],
    project: json["project"],
    currency: currencyValues.map[json["currency"]]!,
    conversionRate: json["conversion_rate"],
    buyingPriceList: buyingPriceListValues.map[json["buying_price_list"]]!,
    priceListCurrency: currencyValues.map[json["price_list_currency"]]!,
    plcConversionRate: json["plc_conversion_rate"],
    ignorePricingRule: json["ignore_pricing_rule"],
    scanBarcode: json["scan_barcode"],
    setFromWarehouse: json["set_from_warehouse"],
    setWarehouse: json["set_warehouse"],
    totalQty: json["total_qty"],
    totalNetWeight: json["total_net_weight"],
    baseTotal: json["base_total"],
    baseNetTotal: json["base_net_total"],
    total: json["total"],
    netTotal: json["net_total"],
    taxWithholdingNetTotal: json["tax_withholding_net_total"],
    baseTaxWithholdingNetTotal: json["base_tax_withholding_net_total"],
    setReserveWarehouse: json["set_reserve_warehouse"],
    taxCategory: taxCategoryValues.map[json["tax_category"]]!,
    taxesAndCharges: json["taxes_and_charges"],
    shippingRule: json["shipping_rule"],
    incoterm: json["incoterm"],
    namedPlace: json["named_place"],
    baseTaxesAndChargesAdded: json["base_taxes_and_charges_added"],
    baseTaxesAndChargesDeducted: json["base_taxes_and_charges_deducted"],
    baseTotalTaxesAndCharges: json["base_total_taxes_and_charges"],
    taxesAndChargesAdded: json["taxes_and_charges_added"],
    taxesAndChargesDeducted: json["taxes_and_charges_deducted"],
    totalTaxesAndCharges: json["total_taxes_and_charges"],
    baseGrandTotal: json["base_grand_total"],
    baseRoundingAdjustment: json["base_rounding_adjustment"],
    baseInWords: json["base_in_words"],
    baseRoundedTotal: json["base_rounded_total"],
    grandTotal: json["grand_total"],
    roundingAdjustment: json["rounding_adjustment"],
    roundedTotal: json["rounded_total"],
    disableRoundedTotal: json["disable_rounded_total"],
    inWords: json["in_words"],
    advancePaid: json["advance_paid"],
    applyDiscountOn: applyDiscountOnValues.map[json["apply_discount_on"]]!,
    baseDiscountAmount: json["base_discount_amount"],
    additionalDiscountPercentage: json["additional_discount_percentage"],
    discountAmount: json["discount_amount"],
    otherChargesCalculation: json["other_charges_calculation"],
    supplierAddress: json["supplier_address"],
    addressDisplay: json["address_display"],
    contactPerson: json["contact_person"],
    contactDisplay: json["contact_display"],
    contactMobile: json["contact_mobile"],
    contactEmail: json["contact_email"],
    shippingAddress: json["shipping_address"],
    shippingAddressDisplay: json["shipping_address_display"],
    billingAddress: json["billing_address"],
    billingAddressDisplay: json["billing_address_display"],
    customer: json["customer"],
    customerName: json["customer_name"],
    customerContactPerson: json["customer_contact_person"],
    customerContactDisplay: json["customer_contact_display"],
    customerContactMobile: json["customer_contact_mobile"],
    customerContactEmail: json["customer_contact_email"],
    paymentTermsTemplate: json["payment_terms_template"],
    tcName: json["tc_name"],
    terms: json["terms"],
    status: statusValues.map[json["status"]]!,
    perBilled: json["per_billed"],
    perReceived: json["per_received"],
    letterHead: json["letter_head"],
    groupSameItems: json["group_same_items"],
    selectPrintHeading: json["select_print_heading"],
    language: languageValues.map[json["language"]]!,
    fromDate: json["from_date"],
    toDate: json["to_date"],
    autoRepeat: json["auto_repeat"],
    isInternalSupplier: json["is_internal_supplier"],
    representsCompany: json["represents_company"],
    refSq: json["ref_sq"],
    partyAccountCurrency: currencyValues.map[json["party_account_currency"]]!,
    interCompanyOrderReference: json["inter_company_order_reference"],
    isOldSubcontractingFlow: json["is_old_subcontracting_flow"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner": modifiedByValues.reverse[owner],
    "creation": creation?.toIso8601String(),
    "modified": modified?.toIso8601String(),
    "modified_by": modifiedByValues.reverse[modifiedBy],
    "docstatus": docstatus,
    "idx": idx,
    "title": titleValues.reverse[title],
    "naming_series": namingSeriesValues.reverse[namingSeries],
    "supplier": supplier,
    "supplier_name": supplierName,
    "order_confirmation_no": orderConfirmationNo,
    "order_confirmation_date": orderConfirmationDate,
    "transaction_date": "${transactionDate!.year.toString().padLeft(4, '0')}-${transactionDate!.month.toString().padLeft(2, '0')}-${transactionDate!.day.toString().padLeft(2, '0')}",
    "schedule_date": "${scheduleDate!.year.toString().padLeft(4, '0')}-${scheduleDate!.month.toString().padLeft(2, '0')}-${scheduleDate!.day.toString().padLeft(2, '0')}",
    "company": companyValues.reverse[company],
    "apply_tds": applyTds,
    "tax_withholding_category": taxWithholdingCategory,
    "is_subcontracted": isSubcontracted,
    "supplier_warehouse": supplierWarehouse,
    "amended_from": amendedFrom,
    "cost_center": costCenter,
    "project": project,
    "currency": currencyValues.reverse[currency],
    "conversion_rate": conversionRate,
    "buying_price_list": buyingPriceListValues.reverse[buyingPriceList],
    "price_list_currency": currencyValues.reverse[priceListCurrency],
    "plc_conversion_rate": plcConversionRate,
    "ignore_pricing_rule": ignorePricingRule,
    "scan_barcode": scanBarcode,
    "set_from_warehouse": setFromWarehouse,
    "set_warehouse": setWarehouse,
    "total_qty": totalQty,
    "total_net_weight": totalNetWeight,
    "base_total": baseTotal,
    "base_net_total": baseNetTotal,
    "total": total,
    "net_total": netTotal,
    "tax_withholding_net_total": taxWithholdingNetTotal,
    "base_tax_withholding_net_total": baseTaxWithholdingNetTotal,
    "set_reserve_warehouse": setReserveWarehouse,
    "tax_category": taxCategoryValues.reverse[taxCategory],
    "taxes_and_charges": taxesAndCharges,
    "shipping_rule": shippingRule,
    "incoterm": incoterm,
    "named_place": namedPlace,
    "base_taxes_and_charges_added": baseTaxesAndChargesAdded,
    "base_taxes_and_charges_deducted": baseTaxesAndChargesDeducted,
    "base_total_taxes_and_charges": baseTotalTaxesAndCharges,
    "taxes_and_charges_added": taxesAndChargesAdded,
    "taxes_and_charges_deducted": taxesAndChargesDeducted,
    "total_taxes_and_charges": totalTaxesAndCharges,
    "base_grand_total": baseGrandTotal,
    "base_rounding_adjustment": baseRoundingAdjustment,
    "base_in_words": baseInWords,
    "base_rounded_total": baseRoundedTotal,
    "grand_total": grandTotal,
    "rounding_adjustment": roundingAdjustment,
    "rounded_total": roundedTotal,
    "disable_rounded_total": disableRoundedTotal,
    "in_words": inWords,
    "advance_paid": advancePaid,
    "apply_discount_on": applyDiscountOnValues.reverse[applyDiscountOn],
    "base_discount_amount": baseDiscountAmount,
    "additional_discount_percentage": additionalDiscountPercentage,
    "discount_amount": discountAmount,
    "other_charges_calculation": otherChargesCalculation,
    "supplier_address": supplierAddress,
    "address_display": addressDisplay,
    "contact_person": contactPerson,
    "contact_display": contactDisplay,
    "contact_mobile": contactMobile,
    "contact_email": contactEmail,
    "shipping_address": shippingAddress,
    "shipping_address_display": shippingAddressDisplay,
    "billing_address": billingAddress,
    "billing_address_display": billingAddressDisplay,
    "customer": customer,
    "customer_name": customerName,
    "customer_contact_person": customerContactPerson,
    "customer_contact_display": customerContactDisplay,
    "customer_contact_mobile": customerContactMobile,
    "customer_contact_email": customerContactEmail,
    "payment_terms_template": paymentTermsTemplate,
    "tc_name": tcName,
    "terms": terms,
    "status": statusValues.reverse[status],
    "per_billed": perBilled,
    "per_received": perReceived,
    "letter_head": letterHead,
    "group_same_items": groupSameItems,
    "select_print_heading": selectPrintHeading,
    "language": languageValues.reverse[language],
    "from_date": fromDate,
    "to_date": toDate,
    "auto_repeat": autoRepeat,
    "is_internal_supplier": isInternalSupplier,
    "represents_company": representsCompany,
    "ref_sq": refSq,
    "party_account_currency": currencyValues.reverse[partyAccountCurrency],
    "inter_company_order_reference": interCompanyOrderReference,
    "is_old_subcontracting_flow": isOldSubcontractingFlow,
  };
}

enum ApplyDiscountOn {
  GRAND_TOTAL
}

final applyDiscountOnValues = EnumValues({
  "Grand Total": ApplyDiscountOn.GRAND_TOTAL
});

enum BuyingPriceList {
  STANDARD_BUYING
}

final buyingPriceListValues = EnumValues({
  "Standard Buying": BuyingPriceList.STANDARD_BUYING
});

enum Company {
  AKSHAR_PLASTIC_FOR_GRANUAL,
  AMAX_CONSULTANCY_SERVICES_DEMO,
  AMAX_POLYMERS,
  VASANI_POLYMERS
}

final companyValues = EnumValues({
  "Akshar plastic for granual": Company.AKSHAR_PLASTIC_FOR_GRANUAL,
  "Amax Consultancy Services (Demo)": Company.AMAX_CONSULTANCY_SERVICES_DEMO,
  "Amax Polymers": Company.AMAX_POLYMERS,
  "Vasani Polymers": Company.VASANI_POLYMERS
});

enum Currency {
  INR
}

final currencyValues = EnumValues({
  "INR": Currency.INR
});

enum Language {
  EN
}

final languageValues = EnumValues({
  "en": Language.EN
});

enum ModifiedBy {
  VIGNESH_AMAXCONSULTANCYSERVICES_COM
}

final modifiedByValues = EnumValues({
  "vignesh@amaxconsultancyservices.com": ModifiedBy.VIGNESH_AMAXCONSULTANCYSERVICES_COM
});

enum NamingSeries {
  PUR_ORD_YYYY
}

final namingSeriesValues = EnumValues({
  "PUR-ORD-.YYYY.-": NamingSeries.PUR_ORD_YYYY
});

enum Status {
  CANCELLED,
  COMPLETED,
  DRAFT,
  TO_RECEIVE_AND_BILL
}

final statusValues = EnumValues({
  "Cancelled": Status.CANCELLED,
  "Completed": Status.COMPLETED,
  "Draft": Status.DRAFT,
  "To Receive and Bill": Status.TO_RECEIVE_AND_BILL
});

enum TaxCategory {
  CGST,
  EMPTY,
  IN_STATE
}

final taxCategoryValues = EnumValues({
  "CGST": TaxCategory.CGST,
  "": TaxCategory.EMPTY,
  "In State": TaxCategory.IN_STATE
});

enum Title {
  SUPPLIER_NAME
}

final titleValues = EnumValues({
  "{supplier_name}": Title.SUPPLIER_NAME
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
