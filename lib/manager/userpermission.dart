import 'package:amax_hr/utils/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRoleService {
  static final UserRoleService _instance = UserRoleService._internal();
  factory UserRoleService() => _instance;
  UserRoleService._internal();

  List<String>? _roles;

  Future<List<String>> getRoles() async {
    if (_roles != null) {
      return _roles!;
    }
    final prefs = await SharedPreferences.getInstance();
    _roles = prefs.getStringList(LocalKeys.userRoles) ?? [];
    return _roles!;
  }

  Future<void> saveRoles(List<String> roles) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(LocalKeys.userRoles, roles);
    _roles = roles; // Update cache
  }

  void setRoles(List<String> roles) {
    _roles = roles;
  }

  bool hasRole(String role) {
    if (_roles == null) return false;
    return _roles!.any((r) => r.toLowerCase() == role.toLowerCase());
  }
}
