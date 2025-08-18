import 'dart:convert';

import 'package:amax_hr/constant/url.dart';
import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/vo/crm_model.dart';
import 'package:amax_hr/vo/user_vo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LeadDetailsController extends GetxController {
  var leads = <CrmModel>[].obs;
  List<UserModel> userList = [];
  List<String> assignees = [];
  var status = 'Open'.obs;
  RxBool isLoading = true.obs;
  final count = 0.obs;

  // Status-based lists for local management
  var openLeads = <CrmModel>[].obs;
  var leadLeads = <CrmModel>[].obs;
  var opportunityLeads = <CrmModel>[].obs;
  var quotationLeads = <CrmModel>[].obs;
  var convertedLeads = <CrmModel>[].obs;
  var doNotContactLeads = <CrmModel>[].obs;
  var interestedLeads = <CrmModel>[].obs;
  var wonLeads = <CrmModel>[].obs;
  var lostLeads = <CrmModel>[].obs;

  final List<String> statusList = [
    'Open',
    'Lead',
    'Opportunity',
    'Quotation',
    'Converted',
    'Do Not Contact',
    'Interested',
    'Won',
    'Lost'
  ];

  @override
  void onInit() {
    isLoading.value = true;
    fetchUser();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    status.value = args['status'] ?? 'Unknown';
    leads.value = List<CrmModel>.from(args['leads'] ?? []);

    // Organize leads by status on initialization
    _organizeLeadsByStatus();

    isLoading.value = false;
    super.onInit();
  }

  // Method to organize leads into status-based lists
  void _organizeLeadsByStatus() {
    // Clear all status lists
    openLeads.clear();
    leadLeads.clear();
    opportunityLeads.clear();
    quotationLeads.clear();
    convertedLeads.clear();
    doNotContactLeads.clear();
    interestedLeads.clear();
    wonLeads.clear();
    lostLeads.clear();

    // Organize leads by their current status
    for (var lead in leads) {
      _addLeadToStatusList(lead);
    }
  }

  // Helper method to add lead to appropriate status list
  void _addLeadToStatusList(CrmModel lead) {
    switch (lead.status?.toLowerCase()) {
      case 'open':
        if (!openLeads.contains(lead)) openLeads.add(lead);
        break;
      case 'lead':
        if (!leadLeads.contains(lead)) leadLeads.add(lead);
        break;
      case 'opportunity':
        if (!opportunityLeads.contains(lead)) opportunityLeads.add(lead);
        break;
      case 'quotation':
        if (!quotationLeads.contains(lead)) quotationLeads.add(lead);
        break;
      case 'converted':
        if (!convertedLeads.contains(lead)) convertedLeads.add(lead);
        break;
      case 'do not contact':
        if (!doNotContactLeads.contains(lead)) doNotContactLeads.add(lead);
        break;
      case 'interested':
        if (!interestedLeads.contains(lead)) interestedLeads.add(lead);
        break;
      case 'won':
        if (!wonLeads.contains(lead)) wonLeads.add(lead);
        break;
      case 'lost':
        if (!lostLeads.contains(lead)) lostLeads.add(lead);
        break;
    }
  }

  // Method to remove lead from current list
  void removeLeadFromCurrentList(int index) {
    try {
      if (index >= 0 && index < leads.length) {
        final removedLead = leads[index];
        leads.removeAt(index);

        logger.d('Lead removed from current list at index $index');
        logger.d('Remaining leads count: ${leads.length}');

        // Also remove from status-specific lists
        _removeFromAllStatusLists(removedLead);

        update(); // Update UI immediately
      }
    } catch (e) {
      logger.e('Error removing lead from current list: $e');
    }
  }

  // Method to remove lead from all status lists
  void _removeFromAllStatusLists(CrmModel lead) {
    openLeads.remove(lead);
    leadLeads.remove(lead);
    opportunityLeads.remove(lead);
    quotationLeads.remove(lead);
    convertedLeads.remove(lead);
    doNotContactLeads.remove(lead);
    interestedLeads.remove(lead);
    wonLeads.remove(lead);
    lostLeads.remove(lead);
  }

  // Method to move lead to appropriate status list
  void moveLeadToStatusList(CrmModel lead, String newStatus) {
    try {
      logger.d('Moving lead to $newStatus list');

      // Remove from all lists first
      _removeFromAllStatusLists(lead);

      // Add to appropriate status list
      _addLeadToStatusList(lead);

      logger.d('Lead successfully moved to $newStatus list');
      update();

    } catch (e) {
      logger.e('Error moving lead to status list: $e');
    }
  }

  // Method to get leads by status
  List<CrmModel> getLeadsByStatus(String statusName) {
    switch (statusName.toLowerCase()) {
      case 'open':
        return openLeads;
      case 'lead':
        return leadLeads;
      case 'opportunity':
        return opportunityLeads;
      case 'quotation':
        return quotationLeads;
      case 'converted':
        return convertedLeads;
      case 'do not contact':
        return doNotContactLeads;
      case 'interested':
        return interestedLeads;
      case 'won':
        return wonLeads;
      case 'lost':
        return lostLeads;
      default:
        return leads.where((lead) =>
        lead.status?.toLowerCase() == statusName.toLowerCase()).toList();
    }
  }

  // Method to get status count
  int getStatusCount(String statusName) {
    return getLeadsByStatus(statusName).length;
  }

  // Method to filter current leads by status
  void filterLeadsByStatus(String? statusName) {
    if (statusName == null || statusName.isEmpty || statusName == 'All') {
      // Show all leads
      leads.assignAll(_getAllLeads());
    } else {
      // Filter by specific status
      final filteredLeads = getLeadsByStatus(statusName);
      leads.assignAll(filteredLeads);
    }
    status.value = statusName ?? 'All';
    update();
  }


  //add event call
  Future<void> addEventApicall({required String title,required String date,required String assign,required String summry,required String desc}) async {
Get.back();
    Map<String, dynamic> eventData = {
      //
      // 'title': title,
      // 'date': date,
      // 'description': desc,
      // 'summary': summry,
      // 'assign': assign,

      "subject": "Event for Lead",
      "starts_on": "2025-08-27 10:00:00",
      "ends_on": "2025-08-27 11:00:00",
      "description": "Follow-up call",
      "event_type": "Private",
      "reference_doctype": "Lead",
      "reference_docname": "LEAD-0001"
    };

    try {
      final response = await ApiService.post(
        ApiUri.addEvents, data:eventData
      );

      if (response != null && response.statusCode == 200) {


        update();
      } else {
        print('❌ Failed to fetch leads');
      }
    } catch (e) {
      print("❌ Error fetching leads: $e");
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> fetchUser() async {
    try {
      final response = await ApiService.get(
        ApiUri.getAllUser,
        params: {
          'fields':
          '["*"]',
          'limit_page_length': '1000',
        },
      );

      if (response != null && response.statusCode == 200) {

        userList = (response.data['data'] as List)
            .map((e) => UserModel.fromJson(e))
            .toList();

        assignees= userList.map((user) => user.name ?? '').toList();
        logger.d('userList===>#${userList.length}');


        update();
      } else {
        print('❌ Failed to fetch leads');
      }
    } catch (e) {
      print("❌ Error fetching leads: $e");
    } finally {
      isLoading.value = false;
    }
  }


  // Method to get all leads from all status lists
  List<CrmModel> _getAllLeads() {
    List<CrmModel> allLeads = [];
    allLeads.addAll(openLeads);
    allLeads.addAll(leadLeads);
    allLeads.addAll(opportunityLeads);
    allLeads.addAll(quotationLeads);
    allLeads.addAll(convertedLeads);
    allLeads.addAll(doNotContactLeads);
    allLeads.addAll(interestedLeads);
    allLeads.addAll(wonLeads);
    allLeads.addAll(lostLeads);
    return allLeads;
  }

  // Method to refresh leads
  void refreshLeads() async {
    try {
      isLoading.value = true;
      update();

      // Simulate refresh - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Re-organize leads by status
      _organizeLeadsByStatus();

      isLoading.value = false;
      update();

      Get.showSnackbar(
        GetSnackBar(
          title: 'Success',
          message: 'Leads refreshed successfully',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        ),
      );

    } catch (e) {
      logger.e('Error refreshing leads: $e');
      isLoading.value = false;
      update();

      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Failed to refresh leads',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        ),
      );
    }
  }

  Future<void> updateLeadStatus({
    required CrmModel crm,
    required String newStatus,
    required String mobile_no,
    required int index,
  }) async {
    final leadName = crm.name;
    final mobileNo = mobile_no;

    // Store original status for rollback if needed
    final originalStatus = crm.status;

    logger.d("message:::=mobile_no========>>>>$mobile_no:");
    logger.d("message:::=========>>>>$mobile_no:");

    if (leadName.isEmpty) {
      logger.e('❌ Invalid lead name');
      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Invalid lead name',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Ensure both mobile_no and phone have values (server requires both)
    final phoneNumber = mobileNo ?? '';
    logger.d("message:::=========>>>>$phoneNumber:");

    if (phoneNumber.isEmpty) {
      logger.e('❌ Mobile number is required for lead update');
      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Mobile number is required',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final endpoint = '/api/resource/Lead/$leadName';
    final data = {
      'status': newStatus,
      'mobile_no': phoneNumber,
      'phone': phoneNumber, // Use same value for both fields
    };

    try {
      // Set updating state for this lead
      if (index < leads.length) {
        leads[index].isUpdating = true;
        update();
      }

      EasyLoading.show(status: 'Updating lead "$leadName"...');
      final response = await ApiService.put(endpoint, data: data);

      if (response != null && response.statusCode == 200) {
        logger.d('✅ Lead "$leadName" updated successfully: ${response.data}');

        // Update lead status
        crm.status = newStatus;
        if (index < leads.length) {
          leads[index].status = newStatus;
          leads[index].isUpdating = false;
        }

        // Handle local list management only if status actually changed
        if (originalStatus != newStatus) {
          // Remove from current list
          removeLeadFromCurrentList(index);

          // Move to appropriate status list
          moveLeadToStatusList(crm, newStatus);

          logger.d('Lead moved from $originalStatus to $newStatus');
        }

        EasyLoading.dismiss();

        String message = originalStatus != newStatus
            ? 'Lead "$leadName" moved from "$originalStatus" to "$newStatus"'
            : 'Lead "$leadName" updated successfully';

        Get.showSnackbar(
          GetSnackBar(
            title: 'Success',
            message: message,
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          ),
        );

        update();

      } else {
        // API call failed - rollback changes
        if (originalStatus != null) {
          crm.status = originalStatus;
          if (index < leads.length) {
            leads[index].status = originalStatus;
            leads[index].isUpdating = false;
          }
        }

        EasyLoading.dismiss();
        Get.showSnackbar(
          GetSnackBar(
            title: 'Error',
            message: 'Failed to update lead "$leadName"',
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
          ),
        );

        logger.e('❌ Failed to update lead "$leadName" - Status: ${response?.statusCode}');
        if (response?.data != null) {
          logger.d('📄 Response data: ${response!.data}');
        }

        update();
      }
    } catch (e) {
      // Exception occurred - rollback changes
      if (originalStatus != null) {
        crm.status = originalStatus;
        if (index < leads.length) {
          leads[index].status = originalStatus;
          leads[index].isUpdating = false;
        }
      }

      EasyLoading.dismiss();
      logger.e('❌ Exception while updating lead "$leadName": $e');

      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Exception occurred while updating lead: $e',
          duration: Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        ),
      );

      update();
    }
  }

  void increment() => count.value++;
}