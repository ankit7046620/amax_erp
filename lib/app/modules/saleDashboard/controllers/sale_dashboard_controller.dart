import 'package:amax_hr/vo/customer_list_model.dart';
import 'package:amax_hr/vo/sales_order.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../manager/api_service.dart';

class SaleDashboardController extends GetxController {
  //TODO: Implement SaleDashboardController
  var salesOrders = <SalesOrder>[].obs;
  var customerCount = 0.obs;
  var quarterlySalesTotal = 0.0.obs;
  final isLoading = true.obs;

    int customerListLenth=0;
  final count = 0.obs;
  @override
  void onInit() {
  //  fetchSalesOrders();
    fetchCustomerData();
    super.onInit();

  }

  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchCustomerData() async {
    try {
      final response = await ApiService.get(
        '/api/resource/Customer?',
        params: {
          'fields':
          '["name","customer_name","customer_type","customer_group","territory","mobile_no","email_id","tax_id","creation","modified"]',
          'limit_page_length': '1000',
        },
      );

      if (response != null && response.statusCode == 200) {
        final List modules = response.data['data'];

         CustomerList customerList = CustomerList.fromJson({'data': modules});

        logger.d('customerListModel===>#${customerList.data?.length}');
        logger.d('customerListJason===>#${customerList.toJson()}');
        customerListLenth=customerList.data!.length;
        update();
        //  Get.to(()=>CrmView(), arguments: {'module': 'crm', 'model': sale});
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
