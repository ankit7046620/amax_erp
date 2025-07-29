import 'package:amax_hr/vo/crm_model.dart';
import 'package:get/get.dart';

class LeadDetailsController extends GetxController {
  var leads = <CrmModel>[].obs;
  var status = 'Open'.obs;
 RxBool   isLoading= true.obs;
  final count = 0.obs;
  @override
  void onInit() {
    isLoading.value= true;
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    status.value = args['status'] ?? 'Unknown';
    leads.value = List<CrmModel>.from(args['leads'] ?? []);
    isLoading.value= false;
    super.onInit();
  }





  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
