import 'package:amax_hr/manager/api_service.dart';
import 'package:get/get.dart';

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
}
