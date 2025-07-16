import 'package:amax_hr/app/routes/app_pages.dart';
import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:amax_hr/utils/app_funcation.dart';
import 'package:amax_hr/vo/crm_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class BottamController extends GetxController {
  final count = 0.obs;
  List<String> moduleNames = [];
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAndStoreModules();
  }

  void increment() => count.value++;

  Module? moduleFromString(String value) {
    return Module.values.firstWhere(
          (e) => e.value == value,
    );
  }



  void handleModule(String moduleName) {
    final module = moduleFromString(moduleName);
    if (module == null) {
      print("Unknown module: $moduleName");
      return;
    }

    switch (module) {
      case Module.crm:
        fetchLeadData();
        break;

    // Add remaining cases as needed
      default:
        print("Module ${module.value} is not yet handled.");
    }
  }








  Future<void> fetchAndStoreModules() async {
    try {
      final response = await ApiService.get('/api/resource/Module Def', params: {
        'fields': '["module_name"]',
        'limit_page_length': '1000',
      });

      if (response != null && response.statusCode == 200) {
        final List modules = response.data['data'];
        moduleNames = modules.map((e) => e['module_name'].toString()).toList();

        // Print all module names
        moduleNames.forEach(print);
      } else {
        print('❌ Failed to fetch modules');
      }
    } catch (e) {
      print("❌ Error fetching modules: $e");
    } finally {
      isLoading.value = false; // ✅ Stop loader in any case
    }
  }
  Future<void> fetchLeadData() async {
    try {
      final response = await ApiService.get('/api/resource/Lead', params: {
        'fields': '["name","lead_name","email_id","company_name","status","creation","modified","source"]',
        'limit_page_length': '1000',
      });

      if (response != null && response.statusCode == 200) {
        final List modules = response.data['data'];


        final CrmModel crmModel = CrmModel.fromJson({'data': modules});

        logger.d('crmModel===>#${crmModel.data.length}');


        AppFunction.goToNextScreen(Routes.CRM, arguments: {
          'module': 'crm',
          'model': crmModel,
        });
      } else {
        print('❌ Failed to fetch leads');
      }
    } catch (e) {
      print("❌ Error fetching leads: $e");
    } finally {
      isLoading.value = false;
    }
  }





}
