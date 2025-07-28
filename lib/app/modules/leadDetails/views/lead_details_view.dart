import 'package:amax_hr/vo/crm_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:shimmer_animation/shimmer_animation.dart';
import '../controllers/lead_details_controller.dart';

class LeadDetailsView extends GetView<LeadDetailsController> {
  LeadDetailsView({super.key});
  final LeadDetailsController leadDetailsController = Get.put(LeadDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("Leads - ${controller.status}")),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerList(); // 🔄 Show shimmer while loading
        }

        if (controller.leads.isEmpty) {
          return const Center(
            child: Text(
              "No leads found.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.leads.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final lead = controller.leads[index];
            return _buildLeadCard(context, lead);
          },
        );
      }),
    );
  }

  /// 🔄 Shimmer UI
  Widget _buildShimmerList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Shimmer(

        child: Container(
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadCard(BuildContext context, CrmModel lead) {
    final date = _formatDate(lead.creation);
    final backgroundColor = _statusBackground(lead.status);
    final chipColor = _chipColor(lead.status);
    final textColor = Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: chipColor.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.grey.shade800),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    lead.leadName ?? 'No Name',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    lead.status ?? 'N/A',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: chipColor,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.business, size: 20, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    lead.companyName ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  date,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat.yMMMEd().format(date);
    } catch (_) {
      return dateStr;
    }
  }

  Color _statusBackground(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
        return Colors.green.shade50;
      case 'lost':
        return Colors.red.shade50;
      case 'converted':
        return Colors.purple.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _chipColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
        return Colors.green.shade600;
      case 'lost':
        return Colors.red.shade600;
      case 'converted':
        return Colors.purple.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
