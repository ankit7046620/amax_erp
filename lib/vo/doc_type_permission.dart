

import 'dart:convert';

import 'package:amax_hr/utils/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PermissionType { read, write, create, delete, submit, cancel, amend }

class DocTypePermission {
  final String doctype;
  final int permlevel;
  final bool canRead;
  final bool canWrite;
  final bool canCreate;
  final bool canDelete;
  final bool canSubmit;
  final bool canCancel;
  final bool canAmend;

  DocTypePermission({
    required this.doctype,
    required this.permlevel,
    required this.canRead,
    required this.canWrite,
    required this.canCreate,
    required this.canDelete,
    required this.canSubmit,
    required this.canCancel,
    required this.canAmend,
  });

  factory DocTypePermission.fromJson(Map<String, dynamic> json) {
    return DocTypePermission(
      doctype: json['doctype'],
      permlevel: json['permlevel'],
      canRead: json['read'] == 1,
      canWrite: json['write'] == 1,
      canCreate: json['create'] == 1,
      canDelete: json['delete'] == 1,
      canSubmit: json['submit'] == 1,
      canCancel: json['cancel'] == 1,
      canAmend: json['amend'] == 1,
    );
  }
}

// Global function you can use anywhere:
Future<bool> hasPermissionGlobal(String doctype, PermissionType type, {int permlevel = 0}) async {
  final prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString(LocalKeys.userPermissions);
  if (jsonString == null) return false;
  final parsed = jsonDecode(jsonString);
  final permsJson = parsed['doctypes'] as List;
  List<DocTypePermission> perms = permsJson.map((e) => DocTypePermission.fromJson(e)).toList();

  final match = perms.firstWhere(
        (p) => p.doctype == doctype && p.permlevel == permlevel,
    orElse: () => DocTypePermission(
      doctype: doctype,
      permlevel: permlevel,
      canRead: false,
      canWrite: false,
      canCreate: false,
      canDelete: false,
      canSubmit: false,
      canCancel: false,
      canAmend: false,
    ),
  );
  switch (type) {
    case PermissionType.read:
      return match.canRead;
    case PermissionType.write:
      return match.canWrite;
    case PermissionType.create:
      return match.canCreate;
    case PermissionType.delete:
      return match.canDelete;
    case PermissionType.submit:
      return match.canSubmit;
    case PermissionType.cancel:
      return match.canCancel;
    case PermissionType.amend:
      return match.canAmend;
  }
}
