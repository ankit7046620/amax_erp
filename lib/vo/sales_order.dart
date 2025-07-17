class SalesOrder {
  List<Data>? data;

  SalesOrder({this.data});

  SalesOrder.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? name;
  double? baseNetTotal;
  String? transactionDate;

  Data({this.name, this.baseNetTotal, this.transactionDate});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    baseNetTotal = json['base_net_total'];
    transactionDate = json['transaction_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['base_net_total'] = this.baseNetTotal;
    data['transaction_date'] = this.transactionDate;
    return data;
  }
}
