// lead_details_view.dart

import 'package:amax_hr/main.dart';
import 'package:amax_hr/vo/crm_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../controllers/lead_details_controller.dart';

class LeadDetailsView extends GetView<LeadDetailsController> {
  LeadDetailsView({super.key});

  final LeadDetailsController leadDetailsController = Get.put(
    LeadDetailsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: GetBuilder<LeadDetailsController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return _buildLoadingList();
          }
          if (controller.leads.isEmpty) {
            return _buildEmptyState();
          }
          return _buildLeadList();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        "Lead Management",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade700,
              Colors.indigo.shade500,
              Colors.blue.shade400,
            ],
          ),
        ),
      ),
      leading: IconButton(
        icon: _iconContainer(Icons.arrow_back_ios),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(icon: _iconContainer(Icons.refresh), onPressed: () {}),
      ],
    );
  }

  Widget _iconContainer(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildLoadingList() => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 5,
    itemBuilder: (context, index) => _buildShimmerCard(),
  );

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.people_outline, size: 64, color: Colors.indigo.shade300),
        const SizedBox(height: 16),
        Text(
          "No Leads Found",
          style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.refresh),
          label: const Text("Refresh"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo.shade600,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    ),
  );

  Widget _buildLeadList() => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: controller.leads.length,
    itemBuilder: (context, index) {
      final lead = controller.leads[index];
      return GestureDetector(
        onTap: () => _showEditLeadDialog(context, lead, index),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOutBack,
          margin: EdgeInsets.only(bottom: 16),
          child: _buildModernLeadCard(lead),
        ),
      );
    },
  );

  Widget _buildShimmerCard() => Container(
    margin: const EdgeInsets.only(bottom: 16),
    child: Shimmer(
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),
  );

  Widget _buildModernLeadCard(CrmModel lead) {
    if (lead.isUpdating) return _buildShimmerCard();

    final date = _formatDate(lead.creation);
    final statusColor = _getStatusColor(lead.status);
    final statusIcon = _getStatusIcon(lead.status);

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [statusColor, statusColor.withOpacity(0.6)],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: statusColor,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lead.leadName ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                lead.name ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (lead.companyName?.isNotEmpty ?? false)
                      _buildInfoCard(
                        Icons.business_outlined,
                        "Company",
                        lead.companyName!,
                        Colors.blue.shade600,
                      ),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      Icons.calendar_today_outlined,
                      "Created",
                      date,
                      Colors.orange.shade600,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      statusIcon,
                      "Status",
                      lead.status ?? 'N/A',
                      statusColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditLeadDialog(BuildContext context, CrmModel lead, int index) {
    final nameController = TextEditingController(text: lead.leadName);
    final companyController = TextEditingController(text: lead.companyName);
    final mobileController = TextEditingController(text: lead.mobile_no);
    String selectedStatus = lead.status ?? 'Open';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Lead"),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  "Lead Name",
                  nameController,
                  validator: _requiredValidator,
                  enabled: false,
                ),
                _buildTextField(
                  "Company",
                  companyController,
                  validator: _requiredValidator,
                  enabled: false,
                ),
                _buildTextField(
                  "Mobile",
                  mobileController,
                  keyboard: TextInputType.phone,
                  validator: _requiredValidator,
                ),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: controller.statusList.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (val) => selectedStatus = val ?? selectedStatus,
                  decoration: const InputDecoration(labelText: "Status"),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                lead.leadName = nameController.text.trim();
                lead.companyName = companyController.text.trim();
                lead.mobile_no = mobileController.text.trim();
                lead.status = selectedStatus;
                controller.update();
                controller.updateLeadStatus(
                  newStatus: selectedStatus,
                  crm: lead,
                  mobile_no: mobileController.text.trim(),
                  index: index,
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) =>
      value == null || value.trim().isEmpty ? 'Required' : null;

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat.yMMMd().format(date);
    } catch (_) {
      return dateStr;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
        return Colors.green.shade600;
      case 'lost':
        return Colors.red.shade600;
      case 'converted':
        return Colors.purple.shade600;
      case 'qualified':
        return Colors.blue.shade600;
      case 'interested':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
        return Icons.radio_button_unchecked;
      case 'lost':
        return Icons.close_rounded;
      case 'converted':
        return Icons.check_circle_outline;
      case 'qualified':
        return Icons.verified_outlined;
      case 'interested':
        return Icons.favorite_outline;
      default:
        return Icons.help_outline;
    }
  }
}
