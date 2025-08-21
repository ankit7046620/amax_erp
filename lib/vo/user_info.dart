class UserInfo {
  Message? message;
  String? homePage;
  String? fullName;

  UserInfo({this.message, this.homePage, this.fullName});

  UserInfo.fromJson(Map<String, dynamic> json) {
    message =
    json['message'] != null ? Message.fromJson(json['message']) : null;
    homePage = json['home_page'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    data['home_page'] = homePage;
    data['full_name'] = fullName;
    return data;
  }
}

class Message {
  String? status;
  User? user;
  List<String>? modules;
  List<Doctypes>? doctypes;

  Message({this.status, this.user, this.modules, this.doctypes});

  Message.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    modules = json['modules'].cast<String>();
    if (json['doctypes'] != null) {
      doctypes = <Doctypes>[];
      json['doctypes'].forEach((v) {
        doctypes!.add(Doctypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['modules'] = modules;
    if (doctypes != null) {
      data['doctypes'] = doctypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? id;
  String? fullName;
  String? email;
  List<String>? roles;

  User({this.id, this.fullName, this.email, this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['email'] = email;
    data['roles'] = roles;
    return data;
  }
}

class Doctypes {
  String? doctype;
  int? permlevel;
  int? read;
  int? write;
  int? create;
  int? delete;
  int? submit;
  int? cancel;
  int? amend;

  Doctypes(
      {this.doctype,
        this.permlevel,
        this.read,
        this.write,
        this.create,
        this.delete,
        this.submit,
        this.cancel,
        this.amend});

  Doctypes.fromJson(Map<String, dynamic> json) {
    doctype = json['doctype'];
    permlevel = json['permlevel'];
    read = json['read'];
    write = json['write'];
    create = json['create'];
    delete = json['delete'];
    submit = json['submit'];
    cancel = json['cancel'];
    amend = json['amend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctype'] = doctype;
    data['permlevel'] = permlevel;
    data['read'] = read;
    data['write'] = write;
    data['create'] = create;
    data['delete'] = delete;
    data['submit'] = submit;
    data['cancel'] = cancel;
    data['amend'] = amend;
    return data;
  }
}
