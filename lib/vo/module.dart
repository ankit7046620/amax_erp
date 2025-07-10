class Module {
  final String moduleName;

  Module({required this.moduleName});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(moduleName: json['module_name']);
  }
}
