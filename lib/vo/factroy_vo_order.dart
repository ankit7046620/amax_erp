class SalesOrder {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  dynamic docstatus;
  dynamic idx;
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
  dynamic skipDeliveryNote;
  String? amendedFrom;
  String? costCenter;
  String? project;
  String? currency;
  dynamic conversionRate;
  String? sellingPriceList;
  String? priceListCurrency;
  dynamic plcConversionRate;
  dynamic ignorePricingRule;
  String? scanBarcode;
  String? setWarehouse;
  dynamic reserveStock;
  dynamic totalQty;
  dynamic totalNetWeight;
  dynamic baseTotal;
  dynamic baseNetTotal;
  dynamic total;
  dynamic netTotal;
  String? taxCategory;
  String? taxesAndCharges;
  String? shippingRule;
  String? incoterm;
  String? namedPlace;
  dynamic baseTotalTaxesAndCharges;
  dynamic totalTaxesAndCharges;
  dynamic baseGrandTotal;
  dynamic baseRoundingAdjustment;
  dynamic baseRoundedTotal;
  String? baseInWords;
  dynamic grandTotal;
  dynamic roundingAdjustment;
  dynamic roundedTotal;
  String? inWords;
  dynamic advancePaid;
  dynamic disableRoundedTotal;
  String? applyDiscountOn;
  dynamic baseDiscountAmount;
  String? couponCode;
  dynamic additionalDiscountPercentage;
  dynamic discountAmount;
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
  dynamic perDelivered;
  dynamic perBilled;
  dynamic perPicked;
  String? billingStatus;
  String? salesPartner;
  dynamic amountEligibleForCommission;
  dynamic commissionRate;
  dynamic totalCommission;
  dynamic loyaltyPoints;
  dynamic loyaltyAmount;
  String? fromDate;
  String? toDate;
  String? autoRepeat;
  String? letterHead;
  dynamic groupSameItems;
  String? selectPrintHeading;
  String? language;
  dynamic isInternalCustomer;
  String? representsCompany;
  String? source;
  String? interCompanyOrderReference;
  String? campaign;
  String? partyAccountCurrency;

  SalesOrder({
    this.name,
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
    this.partyAccountCurrency,
  });

  String? get transaction_date_key => transactionDate;
  double? get base_net_total_key => (baseNetTotal is double) ? baseNetTotal : double.tryParse(baseNetTotal.toString());

  factory SalesOrder.fromJson(Map<String, dynamic> json) {
    return SalesOrder(
      name: json['name'],
      owner: json['owner'],
      creation: json['creation'],
      modified: json['modified'],
      modifiedBy: json['modified_by'],
      docstatus: json['docstatus'],
      idx: json['idx'],
      title: json['title'],
      namingSeries: json['naming_series'],
      customer: json['customer'],
      customerName: json['customer_name'],
      taxId: json['tax_id'],
      orderType: json['order_type'],
      transactionDate: json['transaction_date'],
      deliveryDate: json['delivery_date'],
      poNo: json['po_no'],
      poDate: json['po_date'],
      company: json['company'],
      skipDeliveryNote: json['skip_delivery_note'],
      amendedFrom: json['amended_from'],
      costCenter: json['cost_center'],
      project: json['project'],
      currency: json['currency'],
      conversionRate: json['conversion_rate'],
      sellingPriceList: json['selling_price_list'],
      priceListCurrency: json['price_list_currency'],
      plcConversionRate: json['plc_conversion_rate'],
      ignorePricingRule: json['ignore_pricing_rule'],
      scanBarcode: json['scan_barcode'],
      setWarehouse: json['set_warehouse'],
      reserveStock: json['reserve_stock'],
      totalQty: json['total_qty'],
      totalNetWeight: json['total_net_weight'],
      baseTotal: json['base_total'],
      baseNetTotal: json['base_net_total'],
      total: json['total'],
      netTotal: json['net_total'],
      taxCategory: json['tax_category'],
      taxesAndCharges: json['taxes_and_charges'],
      shippingRule: json['shipping_rule'],
      incoterm: json['incoterm'],
      namedPlace: json['named_place'],
      baseTotalTaxesAndCharges: json['base_total_taxes_and_charges'],
      totalTaxesAndCharges: json['total_taxes_and_charges'],
      baseGrandTotal: json['base_grand_total'],
      baseRoundingAdjustment: json['base_rounding_adjustment'],
      baseRoundedTotal: json['base_rounded_total'],
      baseInWords: json['base_in_words'],
      grandTotal: json['grand_total'],
      roundingAdjustment: json['rounding_adjustment'],
      roundedTotal: json['rounded_total'],
      inWords: json['in_words'],
      advancePaid: json['advance_paid'],
      disableRoundedTotal: json['disable_rounded_total'],
      applyDiscountOn: json['apply_discount_on'],
      baseDiscountAmount: json['base_discount_amount'],
      couponCode: json['coupon_code'],
      additionalDiscountPercentage: json['additional_discount_percentage'],
      discountAmount: json['discount_amount'],
      otherChargesCalculation: json['other_charges_calculation'],
      customerAddress: json['customer_address'],
      addressDisplay: json['address_display'],
      customerGroup: json['customer_group'],
      territory: json['territory'],
      contactPerson: json['contact_person'],
      contactDisplay: json['contact_display'],
      contactPhone: json['contact_phone'],
      contactMobile: json['contact_mobile'],
      contactEmail: json['contact_email'],
      shippingAddressName: json['shipping_address_name'],
      shippingAddress: json['shipping_address'],
      dispatchAddressName: json['dispatch_address_name'],
      dispatchAddress: json['dispatch_address'],
      companyAddress: json['company_address'],
      companyAddressDisplay: json['company_address_display'],
      paymentTermsTemplate: json['payment_terms_template'],
      tcName: json['tc_name'],
      terms: json['terms'],
      status: json['status'],
      deliveryStatus: json['delivery_status'],
      perDelivered: json['per_delivered'],
      perBilled: json['per_billed'],
      perPicked: json['per_picked'],
      billingStatus: json['billing_status'],
      salesPartner: json['sales_partner'],
      amountEligibleForCommission: json['amount_eligible_for_commission'],
      commissionRate: json['commission_rate'],
      totalCommission: json['total_commission'],
      loyaltyPoints: json['loyalty_points'],
      loyaltyAmount: json['loyalty_amount'],
      fromDate: json['from_date'],
      toDate: json['to_date'],
      autoRepeat: json['auto_repeat'],
      letterHead: json['letter_head'],
      groupSameItems: json['group_same_items'],
      selectPrintHeading: json['select_print_heading'],
      language: json['language'],
      isInternalCustomer: json['is_internal_customer'],
      representsCompany: json['represents_company'],
      source: json['source'],
      interCompanyOrderReference: json['inter_company_order_reference'],
      campaign: json['campaign'],
      partyAccountCurrency: json['party_account_currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'owner': owner,
      'creation': creation,
      'modified': modified,
      'modified_by': modifiedBy,
      'docstatus': docstatus,
      'idx': idx,
      'title': title,
      'naming_series': namingSeries,
      'customer': customer,
      'customer_name': customerName,
      'tax_id': taxId,
      'order_type': orderType,
      'transaction_date': transactionDate,
      'delivery_date': deliveryDate,
      'po_no': poNo,
      'po_date': poDate,
      'company': company,
      'skip_delivery_note': skipDeliveryNote,
      'amended_from': amendedFrom,
      'cost_center': costCenter,
      'project': project,
      'currency': currency,
      'conversion_rate': conversionRate,
      'selling_price_list': sellingPriceList,
      'price_list_currency': priceListCurrency,
      'plc_conversion_rate': plcConversionRate,
      'ignore_pricing_rule': ignorePricingRule,
      'scan_barcode': scanBarcode,
      'set_warehouse': setWarehouse,
      'reserve_stock': reserveStock,
      'total_qty': totalQty,
      'total_net_weight': totalNetWeight,
      'base_total': baseTotal,
      'base_net_total': baseNetTotal,
      'total': total,
      'net_total': netTotal,
      'tax_category': taxCategory,
      'taxes_and_charges': taxesAndCharges,
      'shipping_rule': shippingRule,
      'incoterm': incoterm,
      'named_place': namedPlace,
      'base_total_taxes_and_charges': baseTotalTaxesAndCharges,
      'total_taxes_and_charges': totalTaxesAndCharges,
      'base_grand_total': baseGrandTotal,
      'base_rounding_adjustment': baseRoundingAdjustment,
      'base_rounded_total': baseRoundedTotal,
      'base_in_words': baseInWords,
      'grand_total': grandTotal,
      'rounding_adjustment': roundingAdjustment,
      'rounded_total': roundedTotal,
      'in_words': inWords,
      'advance_paid': advancePaid,
      'disable_rounded_total': disableRoundedTotal,
      'apply_discount_on': applyDiscountOn,
      'base_discount_amount': baseDiscountAmount,
      'coupon_code': couponCode,
      'additional_discount_percentage': additionalDiscountPercentage,
      'discount_amount': discountAmount,
      'other_charges_calculation': otherChargesCalculation,
      'customer_address': customerAddress,
      'address_display': addressDisplay,
      'customer_group': customerGroup,
      'territory': territory,
      'contact_person': contactPerson,
      'contact_display': contactDisplay,
      'contact_phone': contactPhone,
      'contact_mobile': contactMobile,
      'contact_email': contactEmail,
      'shipping_address_name': shippingAddressName,
      'shipping_address': shippingAddress,
      'dispatch_address_name': dispatchAddressName,
      'dispatch_address': dispatchAddress,
      'company_address': companyAddress,
      'company_address_display': companyAddressDisplay,
      'payment_terms_template': paymentTermsTemplate,
      'tc_name': tcName,
      'terms': terms,
      'status': status,
      'delivery_status': deliveryStatus,
      'per_delivered': perDelivered,
      'per_billed': perBilled,
      'per_picked': perPicked,
      'billing_status': billingStatus,
      'sales_partner': salesPartner,
      'amount_eligible_for_commission': amountEligibleForCommission,
      'commission_rate': commissionRate,
      'total_commission': totalCommission,
      'loyalty_points': loyaltyPoints,
      'loyalty_amount': loyaltyAmount,
      'from_date': fromDate,
      'to_date': toDate,
      'auto_repeat': autoRepeat,
      'letter_head': letterHead,
      'group_same_items': groupSameItems,
      'select_print_heading': selectPrintHeading,
      'language': language,
      'is_internal_customer': isInternalCustomer,
      'represents_company': representsCompany,
      'source': source,
      'inter_company_order_reference': interCompanyOrderReference,
      'campaign': campaign,
      'party_account_currency': partyAccountCurrency,
    };
  }
}
