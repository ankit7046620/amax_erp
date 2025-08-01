  
class Pinvoice {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  dynamic  docstatus;
  dynamic  idx;
  String? title;
  String? namingSeries;
  String? supplier;
  String? supplierName;
  dynamic taxId;
  String? company;
  String? postingDate;
  String? postingTime;
  dynamic  setPostingTime;
  String? dueDate;
  dynamic  isPaid;
  dynamic  isReturn;
  dynamic returnAgainst;
  dynamic  updateOutstandingForSelf;
  dynamic  updateBilledAmountInPurchaseOrder;
  dynamic  updateBilledAmountInPurchaseReceipt;
  dynamic  applyTds;
  dynamic taxWithholdingCategory;
  String? amendedFrom;
  dynamic billNo;
  String? billDate;
  dynamic costCenter;
  dynamic project;
  String? currency;
  dynamic  conversionRate;
  dynamic  useTransactionDateExchangeRate;
  String? buyingPriceList;
  String? priceListCurrency;
  dynamic  plcConversionRate;
  dynamic  ignorePricingRule;
  dynamic scanBarcode;
  dynamic  updateStock;
  String? setWarehouse;
  dynamic setFromWarehouse;
  dynamic  isSubcontracted;
  dynamic rejectedWarehouse;
  dynamic supplierWarehouse;
  dynamic  totalQty;
  dynamic  totalNetWeight;
  dynamic  baseTotal;
  dynamic  baseNetTotal;
  dynamic  total;
  dynamic  netTotal;
  dynamic  taxWithholdingNetTotal;
  dynamic  baseTaxWithholdingNetTotal;
  String? taxCategory;
  String? taxesAndCharges;
  dynamic shippingRule;
  dynamic incoterm;
  dynamic namedPlace;
  dynamic  baseTaxesAndChargesAdded;
  dynamic  baseTaxesAndChargesDeducted;
  dynamic  baseTotalTaxesAndCharges;
  dynamic  taxesAndChargesAdded;
  dynamic  taxesAndChargesDeducted;
  dynamic  totalTaxesAndCharges;
  dynamic  baseGrandTotal;
  dynamic  baseRoundingAdjustment;
  dynamic  baseRoundedTotal;
  String? baseInWords;
  dynamic  grandTotal;
  dynamic  roundingAdjustment;
  dynamic  useCompanyRoundoffCostCenter;
  dynamic  roundedTotal;
  String? inWords;
  dynamic  totalAdvance;
  dynamic  outstandingAmount;
  dynamic  disableRoundedTotal;
  String? applyDiscountOn;
  dynamic  baseDiscountAmount;
  dynamic  additionalDiscountPercentage;
  dynamic  discountAmount;
  String? otherChargesCalculation;
  dynamic modeOfPayment;
  dynamic  basePaidAmount;
  dynamic clearanceDate;
  dynamic cashBankAccount;
  dynamic  paidAmount;
  dynamic  allocateAdvancesAutomatically;
  dynamic  onlyIncludeAllocatedPayments;
  dynamic  writeOffAmount;
  dynamic  baseWriteOffAmount;
  dynamic writeOffAccount;
  dynamic writeOffCostCenter;
  String? supplierAddress;
  String? addressDisplay;
  dynamic contactPerson;
  dynamic contactDisplay;
  dynamic contactMobile;
  dynamic contactEmail;
  String? shippingAddress;
  String? shippingAddressDisplay;
  String? billingAddress;
  String? billingAddressDisplay;
  String? paymentTermsTemplate;
  dynamic  ignoreDefaultPaymentTermsTemplate;
  String? tcName;
  String? terms;
  String? status;
  dynamic  perReceived;
  String? creditTo;
  String? partyAccountCurrency;
  String? isOpening;
  String? againstExpenseAccount;
  dynamic  unrealizedProfitLossAccount;
  dynamic subscription;
  dynamic autoRepeat;
  dynamic fromDate;
  dynamic toDate;
  String? letterHead;
  dynamic  groupSameItems;
  dynamic selectPrintHeading;
  String? language;
  dynamic  onHold;
  dynamic releaseDate;
  dynamic holdComment;
  dynamic  isInternalSupplier;
  String? representsCompany;
  String? supplierGroup;
  dynamic interCompanyInvoiceReference;
  dynamic  isOldSubcontractingFlow;
  String? remarks;

  Pinvoice(
      {this.name,
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
        this.taxId,
        this.company,
        this.postingDate,
        this.postingTime,
        this.setPostingTime,
        this.dueDate,
        this.isPaid,
        this.isReturn,
        this.returnAgainst,
        this.updateOutstandingForSelf,
        this.updateBilledAmountInPurchaseOrder,
        this.updateBilledAmountInPurchaseReceipt,
        this.applyTds,
        this.taxWithholdingCategory,
        this.amendedFrom,
        this.billNo,
        this.billDate,
        this.costCenter,
        this.project,
        this.currency,
        this.conversionRate,
        this.useTransactionDateExchangeRate,
        this.buyingPriceList,
        this.priceListCurrency,
        this.plcConversionRate,
        this.ignorePricingRule,
        this.scanBarcode,
        this.updateStock,
        this.setWarehouse,
        this.setFromWarehouse,
        this.isSubcontracted,
        this.rejectedWarehouse,
        this.supplierWarehouse,
        this.totalQty,
        this.totalNetWeight,
        this.baseTotal,
        this.baseNetTotal,
        this.total,
        this.netTotal,
        this.taxWithholdingNetTotal,
        this.baseTaxWithholdingNetTotal,
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
        this.baseRoundedTotal,
        this.baseInWords,
        this.grandTotal,
        this.roundingAdjustment,
        this.useCompanyRoundoffCostCenter,
        this.roundedTotal,
        this.inWords,
        this.totalAdvance,
        this.outstandingAmount,
        this.disableRoundedTotal,
        this.applyDiscountOn,
        this.baseDiscountAmount,
        this.additionalDiscountPercentage,
        this.discountAmount,
        this.otherChargesCalculation,
        this.modeOfPayment,
        this.basePaidAmount,
        this.clearanceDate,
        this.cashBankAccount,
        this.paidAmount,
        this.allocateAdvancesAutomatically,
        this.onlyIncludeAllocatedPayments,
        this.writeOffAmount,
        this.baseWriteOffAmount,
        this.writeOffAccount,
        this.writeOffCostCenter,
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
        this.paymentTermsTemplate,
        this.ignoreDefaultPaymentTermsTemplate,
        this.tcName,
        this.terms,
        this.status,
        this.perReceived,
        this.creditTo,
        this.partyAccountCurrency,
        this.isOpening,
        this.againstExpenseAccount,
        this.unrealizedProfitLossAccount,
        this.subscription,
        this.autoRepeat,
        this.fromDate,
        this.toDate,
        this.letterHead,
        this.groupSameItems,
        this.selectPrintHeading,
        this.language,
        this.onHold,
        this.releaseDate,
        this.holdComment,
        this.isInternalSupplier,
        this.representsCompany,
        this.supplierGroup,
        this.interCompanyInvoiceReference,
        this.isOldSubcontractingFlow,
        this.remarks});

  Pinvoice.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    title = json['title'];
    namingSeries = json['naming_series'];
    supplier = json['supplier'];
    supplierName = json['supplier_name'];
    taxId = json['tax_id'];
    company = json['company'];
    postingDate = json['posting_date'];
    postingTime = json['posting_time'];
    setPostingTime = json['set_posting_time'];
    dueDate = json['due_date'];
    isPaid = json['is_paid'];
    isReturn = json['is_return'];
    returnAgainst = json['return_against'];
    updateOutstandingForSelf = json['update_outstanding_for_self'];
    updateBilledAmountInPurchaseOrder =
    json['update_billed_amount_in_purchase_order'];
    updateBilledAmountInPurchaseReceipt =
    json['update_billed_amount_in_purchase_receipt'];
    applyTds = json['apply_tds'];
    taxWithholdingCategory = json['tax_withholding_category'];
    amendedFrom = json['amended_from'];
    billNo = json['bill_no'];
    billDate = json['bill_date'];
    costCenter = json['cost_center'];
    project = json['project'];
    currency = json['currency'];
    conversionRate = json['conversion_rate'];
    useTransactionDateExchangeRate = json['use_transaction_date_exchange_rate'];
    buyingPriceList = json['buying_price_list'];
    priceListCurrency = json['price_list_currency'];
    plcConversionRate = json['plc_conversion_rate'];
    ignorePricingRule = json['ignore_pricing_rule'];
    scanBarcode = json['scan_barcode'];
    updateStock = json['update_stock'];
    setWarehouse = json['set_warehouse'];
    setFromWarehouse = json['set_from_warehouse'];
    isSubcontracted = json['is_subcontracted'];
    rejectedWarehouse = json['rejected_warehouse'];
    supplierWarehouse = json['supplier_warehouse'];
    totalQty = json['total_qty'];
    totalNetWeight = json['total_net_weight'];
    baseTotal = json['base_total'];
    baseNetTotal = json['base_net_total'];
    total = json['total'];
    netTotal = json['net_total'];
    taxWithholdingNetTotal = json['tax_withholding_net_total'];
    baseTaxWithholdingNetTotal = json['base_tax_withholding_net_total'];
    taxCategory = json['tax_category'];
    taxesAndCharges = json['taxes_and_charges'];
    shippingRule = json['shipping_rule'];
    incoterm = json['incoterm'];
    namedPlace = json['named_place'];
    baseTaxesAndChargesAdded = json['base_taxes_and_charges_added'];
    baseTaxesAndChargesDeducted = json['base_taxes_and_charges_deducted'];
    baseTotalTaxesAndCharges = json['base_total_taxes_and_charges'];
    taxesAndChargesAdded = json['taxes_and_charges_added'];
    taxesAndChargesDeducted = json['taxes_and_charges_deducted'];
    totalTaxesAndCharges = json['total_taxes_and_charges'];
    baseGrandTotal = json['base_grand_total'];
    baseRoundingAdjustment = json['base_rounding_adjustment'];
    baseRoundedTotal = json['base_rounded_total'];
    baseInWords = json['base_in_words'];
    grandTotal = json['grand_total'];
    roundingAdjustment = json['rounding_adjustment'];
    useCompanyRoundoffCostCenter = json['use_company_roundoff_cost_center'];
    roundedTotal = json['rounded_total'];
    inWords = json['in_words'];
    totalAdvance = json['total_advance'];
    outstandingAmount = json['outstanding_amount'];
    disableRoundedTotal = json['disable_rounded_total'];
    applyDiscountOn = json['apply_discount_on'];
    baseDiscountAmount = json['base_discount_amount'];
    additionalDiscountPercentage = json['additional_discount_percentage'];
    discountAmount = json['discount_amount'];
    otherChargesCalculation = json['other_charges_calculation'];
    modeOfPayment = json['mode_of_payment'];
    basePaidAmount = json['base_paid_amount'];
    clearanceDate = json['clearance_date'];
    cashBankAccount = json['cash_bank_account'];
    paidAmount = json['paid_amount'];
    allocateAdvancesAutomatically = json['allocate_advances_automatically'];
    onlyIncludeAllocatedPayments = json['only_include_allocated_payments'];
    writeOffAmount = json['write_off_amount'];
    baseWriteOffAmount = json['base_write_off_amount'];
    writeOffAccount = json['write_off_account'];
    writeOffCostCenter = json['write_off_cost_center'];
    supplierAddress = json['supplier_address'];
    addressDisplay = json['address_display'];
    contactPerson = json['contact_person'];
    contactDisplay = json['contact_display'];
    contactMobile = json['contact_mobile'];
    contactEmail = json['contact_email'];
    shippingAddress = json['shipping_address'];
    shippingAddressDisplay = json['shipping_address_display'];
    billingAddress = json['billing_address'];
    billingAddressDisplay = json['billing_address_display'];
    paymentTermsTemplate = json['payment_terms_template'];
    ignoreDefaultPaymentTermsTemplate =
    json['ignore_default_payment_terms_template'];
    tcName = json['tc_name'];
    terms = json['terms'];
    status = json['status'];
    perReceived = json['per_received'];
    creditTo = json['credit_to'];
    partyAccountCurrency = json['party_account_currency'];
    isOpening = json['is_opening'];
    againstExpenseAccount = json['against_expense_account'];
    unrealizedProfitLossAccount = json['unrealized_profit_loss_account'];
    subscription = json['subscription'];
    autoRepeat = json['auto_repeat'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    letterHead = json['letter_head'];
    groupSameItems = json['group_same_items'];
    selectPrintHeading = json['select_print_heading'];
    language = json['language'];
    onHold = json['on_hold'];
    releaseDate = json['release_date'];
    holdComment = json['hold_comment'];
    isInternalSupplier = json['is_internal_supplier'];
    representsCompany = json['represents_company'];
    supplierGroup = json['supplier_group'];
    interCompanyInvoiceReference = json['inter_company_invoice_reference'];
    isOldSubcontractingFlow = json['is_old_subcontracting_flow'];
    remarks = json['remarks'];
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
    data['supplier'] = supplier;
    data['supplier_name'] = supplierName;
    data['tax_id'] = taxId;
    data['company'] = company;
    data['posting_date'] = postingDate;
    data['posting_time'] = postingTime;
    data['set_posting_time'] = setPostingTime;
    data['due_date'] = dueDate;
    data['is_paid'] = isPaid;
    data['is_return'] = isReturn;
    data['return_against'] = returnAgainst;
    data['update_outstanding_for_self'] = updateOutstandingForSelf;
    data['update_billed_amount_in_purchase_order'] =
        updateBilledAmountInPurchaseOrder;
    data['update_billed_amount_in_purchase_receipt'] =
        updateBilledAmountInPurchaseReceipt;
    data['apply_tds'] = applyTds;
    data['tax_withholding_category'] = taxWithholdingCategory;
    data['amended_from'] = amendedFrom;
    data['bill_no'] = billNo;
    data['bill_date'] = billDate;
    data['cost_center'] = costCenter;
    data['project'] = project;
    data['currency'] = currency;
    data['conversion_rate'] = conversionRate;
    data['use_transaction_date_exchange_rate'] =
        useTransactionDateExchangeRate;
    data['buying_price_list'] = buyingPriceList;
    data['price_list_currency'] = priceListCurrency;
    data['plc_conversion_rate'] = plcConversionRate;
    data['ignore_pricing_rule'] = ignorePricingRule;
    data['scan_barcode'] = scanBarcode;
    data['update_stock'] = updateStock;
    data['set_warehouse'] = setWarehouse;
    data['set_from_warehouse'] = setFromWarehouse;
    data['is_subcontracted'] = isSubcontracted;
    data['rejected_warehouse'] = rejectedWarehouse;
    data['supplier_warehouse'] = supplierWarehouse;
    data['total_qty'] = totalQty;
    data['total_net_weight'] = totalNetWeight;
    data['base_total'] = baseTotal;
    data['base_net_total'] = baseNetTotal;
    data['total'] = total;
    data['net_total'] = netTotal;
    data['tax_withholding_net_total'] = taxWithholdingNetTotal;
    data['base_tax_withholding_net_total'] = baseTaxWithholdingNetTotal;
    data['tax_category'] = taxCategory;
    data['taxes_and_charges'] = taxesAndCharges;
    data['shipping_rule'] = shippingRule;
    data['incoterm'] = incoterm;
    data['named_place'] = namedPlace;
    data['base_taxes_and_charges_added'] = baseTaxesAndChargesAdded;
    data['base_taxes_and_charges_deducted'] = baseTaxesAndChargesDeducted;
    data['base_total_taxes_and_charges'] = baseTotalTaxesAndCharges;
    data['taxes_and_charges_added'] = taxesAndChargesAdded;
    data['taxes_and_charges_deducted'] = taxesAndChargesDeducted;
    data['total_taxes_and_charges'] = totalTaxesAndCharges;
    data['base_grand_total'] = baseGrandTotal;
    data['base_rounding_adjustment'] = baseRoundingAdjustment;
    data['base_rounded_total'] = baseRoundedTotal;
    data['base_in_words'] = baseInWords;
    data['grand_total'] = grandTotal;
    data['rounding_adjustment'] = roundingAdjustment;
    data['use_company_roundoff_cost_center'] =
        useCompanyRoundoffCostCenter;
    data['rounded_total'] = roundedTotal;
    data['in_words'] = inWords;
    data['total_advance'] = totalAdvance;
    data['outstanding_amount'] = outstandingAmount;
    data['disable_rounded_total'] = disableRoundedTotal;
    data['apply_discount_on'] = applyDiscountOn;
    data['base_discount_amount'] = baseDiscountAmount;
    data['additional_discount_percentage'] = additionalDiscountPercentage;
    data['discount_amount'] = discountAmount;
    data['other_charges_calculation'] = otherChargesCalculation;
    data['mode_of_payment'] = modeOfPayment;
    data['base_paid_amount'] = basePaidAmount;
    data['clearance_date'] = clearanceDate;
    data['cash_bank_account'] = cashBankAccount;
    data['paid_amount'] = paidAmount;
    data['allocate_advances_automatically'] =
        allocateAdvancesAutomatically;
    data['only_include_allocated_payments'] = onlyIncludeAllocatedPayments;
    data['write_off_amount'] = writeOffAmount;
    data['base_write_off_amount'] = baseWriteOffAmount;
    data['write_off_account'] = writeOffAccount;
    data['write_off_cost_center'] = writeOffCostCenter;
    data['supplier_address'] = supplierAddress;
    data['address_display'] = addressDisplay;
    data['contact_person'] = contactPerson;
    data['contact_display'] = contactDisplay;
    data['contact_mobile'] = contactMobile;
    data['contact_email'] = contactEmail;
    data['shipping_address'] = shippingAddress;
    data['shipping_address_display'] = shippingAddressDisplay;
    data['billing_address'] = billingAddress;
    data['billing_address_display'] = billingAddressDisplay;
    data['payment_terms_template'] = paymentTermsTemplate;
    data['ignore_default_payment_terms_template'] =
        ignoreDefaultPaymentTermsTemplate;
    data['tc_name'] = tcName;
    data['terms'] = terms;
    data['status'] = status;
    data['per_received'] = perReceived;
    data['credit_to'] = creditTo;
    data['party_account_currency'] = partyAccountCurrency;
    data['is_opening'] = isOpening;
    data['against_expense_account'] = againstExpenseAccount;
    data['unrealized_profit_loss_account'] = unrealizedProfitLossAccount;
    data['subscription'] = subscription;
    data['auto_repeat'] = autoRepeat;
    data['from_date'] = fromDate;
    data['to_date'] = toDate;
    data['letter_head'] = letterHead;
    data['group_same_items'] = groupSameItems;
    data['select_print_heading'] = selectPrintHeading;
    data['language'] = language;
    data['on_hold'] = onHold;
    data['release_date'] = releaseDate;
    data['hold_comment'] = holdComment;
    data['is_internal_supplier'] = isInternalSupplier;
    data['represents_company'] = representsCompany;
    data['supplier_group'] = supplierGroup;
    data['inter_company_invoice_reference'] = interCompanyInvoiceReference;
    data['is_old_subcontracting_flow'] = isOldSubcontractingFlow;
    data['remarks'] = remarks;
    return data;
  }
}
