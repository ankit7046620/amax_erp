import 'dart:convert';

import 'package:amax_hr/constant/url.dart';
import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/vo/crm_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LeadDetailsController extends GetxController {
  var leads = <CrmModel>[].obs;
  var status = 'Open'.obs;
  RxBool isLoading = true.obs;
  final count = 0.obs;

  final List<String> statusList = [ 'Open',
    'Lead',
    'Opportunity',
    'Quotation',
    'Converted',
    'Do Not Contact',
    'Interested',
    'Won',
    'Lost'];

  @override
  void onInit() {
    isLoading.value = true;
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    status.value = args['status'] ?? 'Unknown';
    leads.value = List<CrmModel>.from(args['leads'] ?? []);
    isLoading.value = false;
    super.onInit();
  }



  Future<void> updateLeadStatus({
    required CrmModel crm,
    required String newStatus,
    required String mobile_no,
    required int index,
  }) async {
    final leadName = crm.name;
    final mobileNo =mobile_no;
    logger.d("message:::=mobile_no========>>>>$mobile_no:");
    logger.d("message:::=========>>>>$mobile_no:");
    if (leadName.isEmpty) {
      print('❌ Invalid lead name');
      return;
    }

    // Ensure both mobile_no and phone have values (server requires both)
    final phoneNumber = mobileNo ?? '';
    logger.d("message:::=========>>>>$phoneNumber:");
    logger.d("message:::=========>>>>$phoneNumber:");

    if (phoneNumber.isEmpty) {
      print('❌ Mobile number is required for lead update');
      return;
    }

    final endpoint = '/api/resource/Lead/$leadName';

    final data = {
      'status': newStatus,
      'mobile_no': phoneNumber,
      'phone':phoneNumber, // Use same value for both fields
    };
    Get.back();


    try {
      EasyLoading.show(status: 'Updating lead "$leadName"...');
      final response = await ApiService.put(endpoint, data: data);

      if (response != null && response.statusCode == 200) {
        print('✅ Lead "$leadName" updated successfully: ${response.data}');
        crm.status=newStatus;
        leads[index].status=newStatus; // Update the lead in the list
        update();
        EasyLoading.dismiss();
        Get.showSnackbar(
          GetSnackBar(
            title: 'Success',
            message: 'Lead "$leadName" updated to "$newStatus"',
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
          ),
        );
      } else {
        EasyLoading.dismiss();
         Get.showSnackbar(
          GetSnackBar(
            title: 'Error',
            message: 'Failed to update lead "$leadName"',
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
          ),
        );
        print('❌ Failed to update lead "$leadName" - Status: ${response?.statusCode}');
        if (response?.data != null) {
          print('📄 Response data: ${response!.data}');
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      print('❌ Exception while updating lead "$leadName": $e');
    }
  }

  void increment() => count.value++;
}
