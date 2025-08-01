

class PayrollModel {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  dynamic  docstatus;
  dynamic  idx;
  String? employee;
  String? employeeName;
  String? company;
  String? department;
  String? designation;
  String? branch;
  String? postingDate;
  String? letterHead;
  String? status;
  dynamic  salaryWithholding;
  dynamic  salaryWithholdingCycle;
  String? currency;
  dynamic  exchangeRate;
  String? payrollFrequency;
  String? startDate;
  String? endDate;
  String? salaryStructure;
  dynamic  payrollEntry;
  String? modeOfPayment;
  dynamic  salarySlipBasedOnTimesheet;
  dynamic  deductTaxForUnclaimedEmployeeBenefits;
  dynamic  deductTaxForUnsubmittedTaxExemptionProof;
  dynamic  totalWorkingDays;
  dynamic  unmarkedDays;
  dynamic  leaveWithoutPay;
  dynamic  absentDays;
  dynamic  paymentDays;
  dynamic  totalWorkingHours;
  dynamic  hourRate;
  dynamic  baseHourRate;
  dynamic  grossPay;
  dynamic  baseGrossPay;
  dynamic  grossYearToDate;
  dynamic  baseGrossYearToDate;
  dynamic  totalDeduction;
  dynamic  baseTotalDeduction;
  dynamic  netPay;
  dynamic  baseNetPay;
  dynamic  roundedTotal;
  dynamic  baseRoundedTotal;
  dynamic  yearToDate;
  dynamic  baseYearToDate;
  dynamic  monthToDate;
  dynamic  baseMonthToDate;
  String? totalInWords;
  String? baseTotalInWords;
  dynamic  ctc;
  dynamic  incomeFromOtherSources;
  dynamic  totalEarnings;
  dynamic  nonTaxableEarnings;
  dynamic  standardTaxExemptionAmount;
  dynamic  taxExemptionDeclaration;
  dynamic  deductionsBeforeTaxCalculation;
  dynamic  annualTaxableAmount;
  dynamic  incomeTaxDeductedTillDate;
  dynamic  currentMonthIncomeTax;
  dynamic  futureIncomeTaxDeductions;
  dynamic  totalIncomeTax;
  String? journalEntry;
  dynamic  amendedFrom;
  dynamic  bankName;
  dynamic  bankAccountNo;

  PayrollModel(
      {this.name,
        this.owner,
        this.creation,
        this.modified,
        this.modifiedBy,
        this.docstatus,
        this.idx,
        this.employee,
        this.employeeName,
        this.company,
        this.department,
        this.designation,
        this.branch,
        this.postingDate,
        this.letterHead,
        this.status,
        this.salaryWithholding,
        this.salaryWithholdingCycle,
        this.currency,
        this.exchangeRate,
        this.payrollFrequency,
        this.startDate,
        this.endDate,
        this.salaryStructure,
        this.payrollEntry,
        this.modeOfPayment,
        this.salarySlipBasedOnTimesheet,
        this.deductTaxForUnclaimedEmployeeBenefits,
        this.deductTaxForUnsubmittedTaxExemptionProof,
        this.totalWorkingDays,
        this.unmarkedDays,
        this.leaveWithoutPay,
        this.absentDays,
        this.paymentDays,
        this.totalWorkingHours,
        this.hourRate,
        this.baseHourRate,
        this.grossPay,
        this.baseGrossPay,
        this.grossYearToDate,
        this.baseGrossYearToDate,
        this.totalDeduction,
        this.baseTotalDeduction,
        this.netPay,
        this.baseNetPay,
        this.roundedTotal,
        this.baseRoundedTotal,
        this.yearToDate,
        this.baseYearToDate,
        this.monthToDate,
        this.baseMonthToDate,
        this.totalInWords,
        this.baseTotalInWords,
        this.ctc,
        this.incomeFromOtherSources,
        this.totalEarnings,
        this.nonTaxableEarnings,
        this.standardTaxExemptionAmount,
        this.taxExemptionDeclaration,
        this.deductionsBeforeTaxCalculation,
        this.annualTaxableAmount,
        this.incomeTaxDeductedTillDate,
        this.currentMonthIncomeTax,
        this.futureIncomeTaxDeductions,
        this.totalIncomeTax,
        this.journalEntry,
        this.amendedFrom,
        this.bankName,
        this.bankAccountNo});

  PayrollModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    employee = json['employee'];
    employeeName = json['employee_name'];
    company = json['company'];
    department = json['department'];
    designation = json['designation'];
    branch = json['branch'];
    postingDate = json['posting_date'];
    letterHead = json['letter_head'];
    status = json['status'];
    salaryWithholding = json['salary_withholding'];
    salaryWithholdingCycle = json['salary_withholding_cycle'];
    currency = json['currency'];
    exchangeRate = json['exchange_rate'];
    payrollFrequency = json['payroll_frequency'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    salaryStructure = json['salary_structure'];
    payrollEntry = json['payroll_entry'];
    modeOfPayment = json['mode_of_payment'];
    salarySlipBasedOnTimesheet = json['salary_slip_based_on_timesheet'];
    deductTaxForUnclaimedEmployeeBenefits =
    json['deduct_tax_for_unclaimed_employee_benefits'];
    deductTaxForUnsubmittedTaxExemptionProof =
    json['deduct_tax_for_unsubmitted_tax_exemption_proof'];
    totalWorkingDays = json['total_working_days'];
    unmarkedDays = json['unmarked_days'];
    leaveWithoutPay = json['leave_without_pay'];
    absentDays = json['absent_days'];
    paymentDays = json['payment_days'];
    totalWorkingHours = json['total_working_hours'];
    hourRate = json['hour_rate'];
    baseHourRate = json['base_hour_rate'];
    grossPay = json['gross_pay'];
    baseGrossPay = json['base_gross_pay'];
    grossYearToDate = json['gross_year_to_date'];
    baseGrossYearToDate = json['base_gross_year_to_date'];
    totalDeduction = json['total_deduction'];
    baseTotalDeduction = json['base_total_deduction'];
    netPay = json['net_pay'];
    baseNetPay = json['base_net_pay'];
    roundedTotal = json['rounded_total'];
    baseRoundedTotal = json['base_rounded_total'];
    yearToDate = json['year_to_date'];
    baseYearToDate = json['base_year_to_date'];
    monthToDate = json['month_to_date'];
    baseMonthToDate = json['base_month_to_date'];
    totalInWords = json['total_in_words'];
    baseTotalInWords = json['base_total_in_words'];
    ctc = json['ctc'];
    incomeFromOtherSources = json['income_from_other_sources'];
    totalEarnings = json['total_earnings'];
    nonTaxableEarnings = json['non_taxable_earnings'];
    standardTaxExemptionAmount = json['standard_tax_exemption_amount'];
    taxExemptionDeclaration = json['tax_exemption_declaration'];
    deductionsBeforeTaxCalculation = json['deductions_before_tax_calculation'];
    annualTaxableAmount = json['annual_taxable_amount'];
    incomeTaxDeductedTillDate = json['income_tax_deducted_till_date'];
    currentMonthIncomeTax = json['current_month_income_tax'];
    futureIncomeTaxDeductions = json['future_income_tax_deductions'];
    totalIncomeTax = json['total_income_tax'];
    journalEntry = json['journal_entry'];
    amendedFrom = json['amended_from'];
    bankName = json['bank_name'];
    bankAccountNo = json['bank_account_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['owner'] = owner;
    data['creation'] = creation;
    data['modified'] = modified;
    data['modified_by'] = modifiedBy;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['employee'] = employee;
    data['employee_name'] = employeeName;
    data['company'] = company;
    data['department'] = department;
    data['designation'] = designation;
    data['branch'] = branch;
    data['posting_date'] = postingDate;
    data['letter_head'] = letterHead;
    data['status'] = status;
    data['salary_withholding'] = salaryWithholding;
    data['salary_withholding_cycle'] = salaryWithholdingCycle;
    data['currency'] = currency;
    data['exchange_rate'] = exchangeRate;
    data['payroll_frequency'] = payrollFrequency;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['salary_structure'] = salaryStructure;
    data['payroll_entry'] = payrollEntry;
    data['mode_of_payment'] = modeOfPayment;
    data['salary_slip_based_on_timesheet'] = salarySlipBasedOnTimesheet;
    data['deduct_tax_for_unclaimed_employee_benefits'] =
        deductTaxForUnclaimedEmployeeBenefits;
    data['deduct_tax_for_unsubmitted_tax_exemption_proof'] =
        deductTaxForUnsubmittedTaxExemptionProof;
    data['total_working_days'] = totalWorkingDays;
    data['unmarked_days'] = unmarkedDays;
    data['leave_without_pay'] = leaveWithoutPay;
    data['absent_days'] = absentDays;
    data['payment_days'] = paymentDays;
    data['total_working_hours'] = totalWorkingHours;
    data['hour_rate'] = hourRate;
    data['base_hour_rate'] = baseHourRate;
    data['gross_pay'] = grossPay;
    data['base_gross_pay'] = baseGrossPay;
    data['gross_year_to_date'] = grossYearToDate;
    data['base_gross_year_to_date'] = baseGrossYearToDate;
    data['total_deduction'] = totalDeduction;
    data['base_total_deduction'] = baseTotalDeduction;
    data['net_pay'] = netPay;
    data['base_net_pay'] = baseNetPay;
    data['rounded_total'] = roundedTotal;
    data['base_rounded_total'] = baseRoundedTotal;
    data['year_to_date'] = yearToDate;
    data['base_year_to_date'] = baseYearToDate;
    data['month_to_date'] = monthToDate;
    data['base_month_to_date'] = baseMonthToDate;
    data['total_in_words'] = totalInWords;
    data['base_total_in_words'] = baseTotalInWords;
    data['ctc'] = ctc;
    data['income_from_other_sources'] = incomeFromOtherSources;
    data['total_earnings'] = totalEarnings;
    data['non_taxable_earnings'] = nonTaxableEarnings;
    data['standard_tax_exemption_amount'] = standardTaxExemptionAmount;
    data['tax_exemption_declaration'] = taxExemptionDeclaration;
    data['deductions_before_tax_calculation'] =
        deductionsBeforeTaxCalculation;
    data['annual_taxable_amount'] = annualTaxableAmount;
    data['income_tax_deducted_till_date'] = incomeTaxDeductedTillDate;
    data['current_month_income_tax'] = currentMonthIncomeTax;
    data['future_income_tax_deductions'] = futureIncomeTaxDeductions;
    data['total_income_tax'] = totalIncomeTax;
    data['journal_entry'] = journalEntry;
    data['amended_from'] = amendedFrom;
    data['bank_name'] = bankName;
    data['bank_account_no'] = bankAccountNo;
    return data;
  }
}
