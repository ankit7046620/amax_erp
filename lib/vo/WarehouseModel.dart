// models/warehouse_model.dart
class WarehouseModel {
  final String name;
  final String owner;
  final String creation;
  final String modified;
  final String modifiedBy;
  final int docstatus;
  final int idx;
  final int disabled;
  final String warehouseName;
  final int isGroup;
  final String? parentWarehouse;
  final int isRejectedWarehouse;
  final String? account;
  final String company;
  final String? emailId;
  final String? phoneNo;
  final String? mobileNo;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? pin;
  final String? warehouseType;
  final String? defaultInTransitWarehouse;
  final int lft;
  final int rgt;
  final String oldParent;

  WarehouseModel({
    required this.name,
    required this.owner,
    required this.creation,
    required this.modified,
    required this.modifiedBy,
    required this.docstatus,
    required this.idx,
    required this.disabled,
    required this.warehouseName,
    required this.isGroup,
    this.parentWarehouse,
    required this.isRejectedWarehouse,
    this.account,
    required this.company,
    this.emailId,
    this.phoneNo,
    this.mobileNo,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.pin,
    this.warehouseType,
    this.defaultInTransitWarehouse,
    required this.lft,
    required this.rgt,
    required this.oldParent,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      name: json['name'] ?? '',
      owner: json['owner'] ?? '',
      creation: json['creation'] ?? '',
      modified: json['modified'] ?? '',
      modifiedBy: json['modified_by'] ?? '',
      docstatus: json['docstatus'] ?? 0,
      idx: json['idx'] ?? 0,
      disabled: json['disabled'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
      isGroup: json['is_group'] ?? 0,
      parentWarehouse: json['parent_warehouse'],
      isRejectedWarehouse: json['is_rejected_warehouse'] ?? 0,
      account: json['account'],
      company: json['company'] ?? '',
      emailId: json['email_id'],
      phoneNo: json['phone_no'],
      mobileNo: json['mobile_no'],
      addressLine1: json['address_line_1'],
      addressLine2: json['address_line_2'],
      city: json['city'],
      state: json['state'],
      pin: json['pin'],
      warehouseType: json['warehouse_type'],
      defaultInTransitWarehouse: json['default_in_transit_warehouse'],
      lft: json['lft'] ?? 0,
      rgt: json['rgt'] ?? 0,
      oldParent: json['old_parent'] ?? '',
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
      'disabled': disabled,
      'warehouse_name': warehouseName,
      'is_group': isGroup,
      'parent_warehouse': parentWarehouse,
      'is_rejected_warehouse': isRejectedWarehouse,
      'account': account,
      'company': company,
      'email_id': emailId,
      'phone_no': phoneNo,
      'mobile_no': mobileNo,
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'city': city,
      'state': state,
      'pin': pin,
      'warehouse_type': warehouseType,
      'default_in_transit_warehouse': defaultInTransitWarehouse,
      'lft': lft,
      'rgt': rgt,
      'old_parent': oldParent,
    };
  }
}