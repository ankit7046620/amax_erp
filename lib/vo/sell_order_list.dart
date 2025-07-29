
import 'sales_order.dart';


class SellOrderList {
  final List<SellOrderDataList> orders;

  SellOrderList({required this.orders});

  factory SellOrderList.fromJson(Map<String, dynamic> json) {
    return SellOrderList(
      orders: (json['data'] as List)
          .map((e) => SellOrderDataList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}



class SellOrderDataList {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  var docstatus;
  var idx;
  String? title;
  String? namingSeries;
  String? customer;
  String? customerName;
  String? taxId;
  String? orderType;
  String? transactionDate;
  String? deliveryDate;
  String? poNo;
  String? poDate;
  String? company;
  var skipDeliveryNote;
  String? amendedFrom;
  String? costCenter;
  String? project;
  String? currency;
  var conversionRate;
  String? sellingPriceList;
  String? priceListCurrency;
  var plcConversionRate;
  var ignorePricingRule;
  String? scanBarcode;
  String? setWarehouse;
  var reserveStock;
  var totalQty;
  var totalNetWeight;
  var baseTotal;
  var baseNetTotal;
  var total;
  var netTotal;
  String? taxCategory;
  String? taxesAndCharges;
  String? shippingRule;
  String? incoterm;
  String? namedPlace;
  var baseTotalTaxesAndCharges;
  var totalTaxesAndCharges;
  var baseGrandTotal;
  var baseRoundingAdjustment;
  var baseRoundedTotal;
  String? baseInWords;
  var grandTotal;
  var roundingAdjustment;
  var roundedTotal;
  String? inWords;
  var advancePaid;
  var disableRoundedTotal;
  String? applyDiscountOn;
  var baseDiscountAmount;
  String? couponCode;
  var additionalDiscountPercentage;
  var discountAmount;
  String? otherChargesCalculation;
  String? customerAddress;
  String? addressDisplay;
  String? customerGroup;
  String? territory;
  String? contactPerson;
  String? contactDisplay;
  String? contactPhone;
  String? contactMobile;
  String? contactEmail;
  String? shippingAddressName;
  String? shippingAddress;
  String? dispatchAddressName;
  String? dispatchAddress;
  String? companyAddress;
  String? companyAddressDisplay;
  String? paymentTermsTemplate;
  String? tcName;
  String? terms;
  String? status;
  String? deliveryStatus;
  var perDelivered;
  var perBilled;
  var perPicked;
  String? billingStatus;
  String? salesPartner;
  var amountEligibleForCommission;
  var commissionRate;
  var totalCommission;
  var loyaltyPoints;
  var loyaltyAmount;
  String? fromDate;
  String? toDate;
  String? autoRepeat;
  String? letterHead;
  var groupSameItems;
  String? selectPrintHeading;
  String? language;
  var isInternalCustomer;
  String? representsCompany;
  String? source;
  String? interCompanyOrderReference;
  String? campaign;
  String? partyAccountCurrency;

  SellOrderDataList(      {this.name,
        this.owner,
        this.creation,
        this.modified,
        this.modifiedBy,
        this.docstatus,
        this.idx,
        this.title,
        this.namingSeries,
        this.customer,
        this.customerName,
        this.taxId,
        this.orderType,
        this.transactionDate,
        this.deliveryDate,
        this.poNo,
        this.poDate,
        this.company,
        this.skipDeliveryNote,
        this.amendedFrom,
        this.costCenter,
        this.project,
        this.currency,
        this.conversionRate,
        this.sellingPriceList,
        this.priceListCurrency,
        this.plcConversionRate,
        this.ignorePricingRule,
        this.scanBarcode,
        this.setWarehouse,
        this.reserveStock,
        this.totalQty,
        this.totalNetWeight,
        this.baseTotal,
        this.baseNetTotal,
        this.total,
        this.netTotal,
        this.taxCategory,
        this.taxesAndCharges,
        this.shippingRule,
        this.incoterm,
        this.namedPlace,
        this.baseTotalTaxesAndCharges,
        this.totalTaxesAndCharges,
        this.baseGrandTotal,
        this.baseRoundingAdjustment,
        this.baseRoundedTotal,
        this.baseInWords,
        this.grandTotal,
        this.roundingAdjustment,
        this.roundedTotal,
        this.inWords,
        this.advancePaid,
        this.disableRoundedTotal,
        this.applyDiscountOn,
        this.baseDiscountAmount,
        this.couponCode,
        this.additionalDiscountPercentage,
        this.discountAmount,
        this.otherChargesCalculation,
        this.customerAddress,
        this.addressDisplay,
        this.customerGroup,
        this.territory,
        this.contactPerson,
        this.contactDisplay,
        this.contactPhone,
        this.contactMobile,
        this.contactEmail,
        this.shippingAddressName,
        this.shippingAddress,
        this.dispatchAddressName,
        this.dispatchAddress,
        this.companyAddress,
        this.companyAddressDisplay,
        this.paymentTermsTemplate,
        this.tcName,
        this.terms,
        this.status,
        this.deliveryStatus,
        this.perDelivered,
        this.perBilled,
        this.perPicked,
        this.billingStatus,
        this.salesPartner,
        this.amountEligibleForCommission,
        this.commissionRate,
        this.totalCommission,
        this.loyaltyPoints,
        this.loyaltyAmount,
        this.fromDate,
        this.toDate,
        this.autoRepeat,
        this.letterHead,
        this.groupSameItems,
        this.selectPrintHeading,
        this.language,
        this.isInternalCustomer,
        this.representsCompany,
        this.source,
        this.interCompanyOrderReference,
        this.campaign,
        this.partyAccountCurrency});

  SellOrderDataList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    title = json['title'];
    namingSeries = json['naming_series'];
    customer = json['customer'];
    customerName = json['customer_name'];
    taxId = json['tax_id'];
    orderType = json['order_type'];
    transactionDate = json['transaction_date'];
    deliveryDate = json['delivery_date'];
    poNo = json['po_no'];
    poDate = json['po_date'];
    company = json['company'];
    skipDeliveryNote = json['skip_delivery_note'];
    amendedFrom = json['amended_from'];
    costCenter = json['cost_center'];
    project = json['project'];
    currency = json['currency'];
    conversionRate = json['conversion_rate'];
    sellingPriceList = json['selling_price_list'];
    priceListCurrency = json['price_list_currency'];
    plcConversionRate = json['plc_conversion_rate'];
    ignorePricingRule = json['ignore_pricing_rule'];
    scanBarcode = json['scan_barcode'];
    setWarehouse = json['set_warehouse'];
    reserveStock = json['reserve_stock'];
    totalQty = json['total_qty'];
    totalNetWeight = json['total_net_weight'];
    baseTotal = json['base_total'];
    baseNetTotal = json['base_net_total'];
    total = json['total'];
    netTotal = json['net_total'];
    taxCategory = json['tax_category'];
    taxesAndCharges = json['taxes_and_charges'];
    shippingRule = json['shipping_rule'];
    incoterm = json['incoterm'];
    namedPlace = json['named_place'];
    baseTotalTaxesAndCharges = json['base_total_taxes_and_charges'];
    totalTaxesAndCharges = json['total_taxes_and_charges'];
    baseGrandTotal = json['base_grand_total'];
    baseRoundingAdjustment = json['base_rounding_adjustment'];
    baseRoundedTotal = json['base_rounded_total'];
    baseInWords = json['base_in_words'];
    grandTotal = json['grand_total'];
    roundingAdjustment = json['rounding_adjustment'];
    roundedTotal = json['rounded_total'];
    inWords = json['in_words'];
    advancePaid = json['advance_paid'];
    disableRoundedTotal = json['disable_rounded_total'];
    applyDiscountOn = json['apply_discount_on'];
    baseDiscountAmount = json['base_discount_amount'];
    couponCode = json['coupon_code'];
    additionalDiscountPercentage = json['additional_discount_percentage'];
    discountAmount = json['discount_amount'];
    otherChargesCalculation = json['other_charges_calculation'];
    customerAddress = json['customer_address'];
    addressDisplay = json['address_display'];
    customerGroup = json['customer_group'];
    territory = json['territory'];
    contactPerson = json['contact_person'];
    contactDisplay = json['contact_display'];
    contactPhone = json['contact_phone'];
    contactMobile = json['contact_mobile'];
    contactEmail = json['contact_email'];
    shippingAddressName = json['shipping_address_name'];
    shippingAddress = json['shipping_address'];
    dispatchAddressName = json['dispatch_address_name'];
    dispatchAddress = json['dispatch_address'];
    companyAddress = json['company_address'];
    companyAddressDisplay = json['company_address_display'];
    paymentTermsTemplate = json['payment_terms_template'];
    tcName = json['tc_name'];
    terms = json['terms'];
    status = json['status'];
    deliveryStatus = json['delivery_status'];
    perDelivered = json['per_delivered'];
    perBilled = json['per_billed'];
    perPicked = json['per_picked'];
    billingStatus = json['billing_status'];
    salesPartner = json['sales_partner'];
    amountEligibleForCommission = json['amount_eligible_for_commission'];
    commissionRate = json['commission_rate'];
    totalCommission = json['total_commission'];
    loyaltyPoints = json['loyalty_points'];
    loyaltyAmount = json['loyalty_amount'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    autoRepeat = json['auto_repeat'];
    letterHead = json['letter_head'];
    groupSameItems = json['group_same_items'];
    selectPrintHeading = json['select_print_heading'];
    language = json['language'];
    isInternalCustomer = json['is_internal_customer'];
    representsCompany = json['represents_company'];
    source = json['source'];
    interCompanyOrderReference = json['inter_company_order_reference'];
    campaign = json['campaign'];
    partyAccountCurrency = json['party_account_currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['owner'] = owner;
    data['creation'] = creation;
    data['modified'] = modified;
    data['modified_by'] = modifiedBy;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['title'] = title;
    data['naming_series'] = namingSeries;
    data['customer'] = customer;
    data['customer_name'] = customerName;
    data['tax_id'] = taxId;
    data['order_type'] = orderType;
    data['transaction_date'] = transactionDate;
    data['delivery_date'] = deliveryDate;
    data['po_no'] = poNo;
    data['po_date'] = poDate;
    data['company'] = company;
    data['skip_delivery_note'] = skipDeliveryNote;
    data['amended_from'] = amendedFrom;
    data['cost_center'] = costCenter;
    data['project'] = project;
    data['currency'] = currency;
    data['conversion_rate'] = conversionRate;
    data['selling_price_list'] = sellingPriceList;
    data['price_list_currency'] = priceListCurrency;
    data['plc_conversion_rate'] = plcConversionRate;
    data['ignore_pricing_rule'] = ignorePricingRule;
    data['scan_barcode'] = scanBarcode;
    data['set_warehouse'] = setWarehouse;
    data['reserve_stock'] = reserveStock;
    data['total_qty'] = totalQty;
    data['total_net_weight'] = totalNetWeight;
    data['base_total'] = baseTotal;
    data['base_net_total'] = baseNetTotal;
    data['total'] = total;
    data['net_total'] = netTotal;
    data['tax_category'] = taxCategory;
    data['taxes_and_charges'] = taxesAndCharges;
    data['shipping_rule'] = shippingRule;
    data['incoterm'] = incoterm;
    data['named_place'] = namedPlace;
    data['base_total_taxes_and_charges'] = baseTotalTaxesAndCharges;
    data['total_taxes_and_charges'] = totalTaxesAndCharges;
    data['base_grand_total'] = baseGrandTotal;
    data['base_rounding_adjustment'] = baseRoundingAdjustment;
    data['base_rounded_total'] = baseRoundedTotal;
    data['base_in_words'] = baseInWords;
    data['grand_total'] = grandTotal;
    data['rounding_adjustment'] = roundingAdjustment;
    data['rounded_total'] = roundedTotal;
    data['in_words'] = inWords;
    data['advance_paid'] = advancePaid;
    data['disable_rounded_total'] = disableRoundedTotal;
    data['apply_discount_on'] = applyDiscountOn;
    data['base_discount_amount'] = baseDiscountAmount;
    data['coupon_code'] = couponCode;
    data['additional_discount_percentage'] = additionalDiscountPercentage;
    data['discount_amount'] = discountAmount;
    data['other_charges_calculation'] = otherChargesCalculation;
    data['customer_address'] = customerAddress;
    data['address_display'] = addressDisplay;
    data['customer_group'] = customerGroup;
    data['territory'] = territory;
    data['contact_person'] = contactPerson;
    data['contact_display'] = contactDisplay;
    data['contact_phone'] = contactPhone;
    data['contact_mobile'] = contactMobile;
    data['contact_email'] = contactEmail;
    data['shipping_address_name'] = shippingAddressName;
    data['shipping_address'] = shippingAddress;
    data['dispatch_address_name'] = dispatchAddressName;
    data['dispatch_address'] = dispatchAddress;
    data['company_address'] = companyAddress;
    data['company_address_display'] = companyAddressDisplay;
    data['payment_terms_template'] = paymentTermsTemplate;
    data['tc_name'] = tcName;
    data['terms'] = terms;
    data['status'] = status;
    data['delivery_status'] = deliveryStatus;
    data['per_delivered'] = perDelivered;
    data['per_billed'] = perBilled;
    data['per_picked'] = perPicked;
    data['billing_status'] = billingStatus;
    data['sales_partner'] = salesPartner;
    data['amount_eligible_for_commission'] = amountEligibleForCommission;
    data['commission_rate'] = commissionRate;
    data['total_commission'] = totalCommission;
    data['loyalty_points'] = loyaltyPoints;
    data['loyalty_amount'] = loyaltyAmount;
    data['from_date'] = fromDate;
    data['to_date'] = toDate;
    data['auto_repeat'] = autoRepeat;
    data['letter_head'] = letterHead;
    data['group_same_items'] = groupSameItems;
    data['select_print_heading'] = selectPrintHeading;
    data['language'] = language;
    data['is_internal_customer'] = isInternalCustomer;
    data['represents_company'] = representsCompany;
    data['source'] = source;
    data['inter_company_order_reference'] = interCompanyOrderReference;
    data['campaign'] = campaign;
    data['party_account_currency'] = partyAccountCurrency;
    return data;
  }
}