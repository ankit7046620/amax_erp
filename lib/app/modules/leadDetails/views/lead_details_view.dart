// lead_details_view.dart

import 'package:amax_hr/common/component/custom_appbar.dart';
import 'package:amax_hr/constant/assets_constant.dart';
import 'package:amax_hr/main.dart';
import 'package:amax_hr/vo/crm_model.dart';
import 'package:dropdown_search/dropdown_search.dart';

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
      body: Column(
        children: [
          _buildStatusTabs(),
          Expanded(
            child: GetBuilder<LeadDetailsController>(
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
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CommonAppBar(
      imagePath: AssetsConstant.tech_logo,
      showBack: true,
      actions: [
        IconButton(
          icon: _iconContainer(Icons.refresh),
          onPressed: () {
            leadDetailsController.refreshLeads();
          },
        ),
        IconButton(
          icon: _iconContainer(Icons.filter_list),
          onPressed: () => _showStatusFilterDialog(),
        ),
      ],
    );
  }

  Widget _buildStatusTabs() {
    return GetBuilder<LeadDetailsController>(
      builder: (controller) => Container(
        height: 60,
        margin: const EdgeInsets.all(8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.statusList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildStatusChip(
                'All',
                controller.leads.length,
                controller.status.value == 'All' ||
                    controller.status.value == 'Unknown',
                () => controller.filterLeadsByStatus('All'),
              );
            }

            final statusName = controller.statusList[index - 1];
            final count = controller.getStatusCount(statusName);
            final isSelected = controller.status.value == statusName;

            return _buildStatusChip(
              statusName,
              count,
              isSelected,
              () => controller.filterLeadsByStatus(statusName),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusChip(
    String status,
    int count,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final color = _getStatusColor(status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getStatusIcon(status),
                size: 16,
                color: isSelected ? Colors.white : color,
              ),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
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
        GetBuilder<LeadDetailsController>(
          builder: (controller) => Text(
            "No ${controller.status.value} Leads Found",
            style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            controller.refreshLeads();
          },
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
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildModernLeadCard(lead, index),
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

  Widget _buildModernLeadCard(CrmModel lead, int index) {
    // Check if this specific lead is updating
    final isUpdating = lead.isUpdating ?? false;

    if (isUpdating) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Shimmer(
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: Text(
                'Updating...',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    }

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
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        lead.status ?? 'N/A',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
                          child: Text(
                            (lead.leadName ?? lead.name ?? 'N')
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lead.leadName ?? lead.name ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (lead.leadName != null &&
                                  lead.name != null &&
                                  lead.leadName != lead.name)
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
                        const SizedBox(width: 40), // Space for status badge
                      ],
                    ),

                    const SizedBox(height: 12),

                    _eventButton(),
                    const SizedBox(height: 16),
                    if (lead.companyName?.isNotEmpty ?? false)
                      _buildInfoCard(
                        Icons.business_outlined,
                        "Company",
                        lead.companyName!,
                        Colors.blue.shade600,
                      ),
                    if (lead.companyName?.isNotEmpty ?? false)
                      const SizedBox(height: 10),
                    if (lead.mobile_no?.isNotEmpty ?? false)
                      _buildInfoCard(
                        Icons.phone_outlined,
                        "Mobile",
                        lead.mobile_no!,
                        Colors.green.shade600,
                      ),
                    if (lead.mobile_no?.isNotEmpty ?? false)
                      const SizedBox(height: 10),
                    _buildInfoCard(
                      Icons.calendar_today_outlined,
                      "Created",
                      date,
                      Colors.orange.shade600,
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

  Widget _eventButton() {
    return Row(
      children: [
        _actionButton(
          label: "Add Event",
          color: Colors.red,
          icon: Icons.add,
          onTap: () {
            logger.d("Add Event button tapped");
            showNewEventDialog(controller.assignees);


          },
        ),
        const SizedBox(width: 16),
        _actionButton(
          label: "Add Task",
          color: Colors.blue,
          icon: Icons.add_task,
          onTap: () {
    logger.d("Add Task button tapped");
            // Handle second event button tap
            // You can implement your task creation logic here
            Get.snackbar(
              "Coming Soon",
              "Add Task feature is not yet implemented.",
            );
            logger.w("Add Task feature is not yet implemented.");
          },
        ),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color.withOpacity(0.7), size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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

  void _showStatusFilterDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Status'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.statusList.length + 1,
            itemBuilder: (context, index) {
              String statusName;
              int count;

              if (index == 0) {
                statusName = 'All';
                count = controller.leads.length;
              } else {
                statusName = controller.statusList[index - 1];
                count = controller.getStatusCount(statusName);
              }

              final isSelected =
                  controller.status.value == statusName ||
                  (statusName == 'All' &&
                      (controller.status.value == 'All' ||
                          controller.status.value == 'Unknown'));

              return ListTile(
                leading: Icon(
                  _getStatusIcon(statusName),
                  color: _getStatusColor(statusName),
                ),
                title: Text(statusName),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(statusName).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: _getStatusColor(statusName),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                selected: isSelected,
                onTap: () {
                  Get.back();
                  controller.filterLeadsByStatus(
                    statusName == 'All' ? null : statusName,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showEditLeadDialog(BuildContext context, CrmModel lead, int index) {
    final nameController = TextEditingController(
      text: lead.leadName ?? lead.name,
    );
    final companyController = TextEditingController(text: lead.companyName);
    final mobileController = TextEditingController(text: lead.mobile_no);
    String selectedStatus = lead.status ?? 'Open';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.edit, color: Colors.indigo.shade600),
              const SizedBox(width: 8),
              const Text("Edit Lead"),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                    "Lead Name",
                    nameController,
                    Icons.person_outline,
                    validator: _requiredValidator,
                    enabled: false,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    "Company",
                    companyController,
                    Icons.business_outlined,
                    enabled: false,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    "Mobile",
                    mobileController,
                    Icons.phone_outlined,
                    keyboard: TextInputType.phone,
                    validator: _mobileValidator,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(
                        labelText: "Status",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.flag_outlined),
                      ),
                      items: controller.statusList.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Row(
                            children: [
                              Icon(
                                _getStatusIcon(status),
                                color: _getStatusColor(status),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(status),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            selectedStatus = val;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // Close the edit dialog first
                  Get.back();

                  try {
                    // Update the lead object locally first
                    lead.leadName = nameController.text.trim();
                    lead.companyName = companyController.text.trim();
                    lead.mobile_no = mobileController.text.trim();

                    // Call the controller method - it will handle everything
                    await controller.updateLeadStatus(
                      newStatus: selectedStatus,
                      crm: lead,
                      mobile_no: mobileController.text.trim(),
                      index: index,
                    );
                  } catch (e) {
                    logger.e('Error in UI: $e');
                    // Controller already handles error display
                  }
                } else {
                  // Show validation error using controller's snackbar style
                  Get.showSnackbar(
                    GetSnackBar(
                      title: 'Validation Error',
                      message: 'Please fill in all required fields correctly',
                      duration: const Duration(seconds: 3),
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.orange.shade600,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.save, size: 18),
                  SizedBox(width: 8),
                  Text("Save Changes"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: validator,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo.shade600, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        filled: !enabled,
        fillColor: enabled ? null : Colors.grey.shade50,
        isDense: true,
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _mobileValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    if (value.trim().length < 10) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'all':
        return Colors.indigo.shade600;
      case 'open':
        return Colors.green.shade600;
      case 'lead':
        return Colors.blue.shade600;
      case 'opportunity':
        return Colors.purple.shade600;
      case 'quotation':
        return Colors.orange.shade600;
      case 'converted':
        return Colors.teal.shade600;
      case 'do not contact':
        return Colors.red.shade600;
      case 'interested':
        return Colors.amber.shade700;
      case 'won':
        return Colors.green.shade700;
      case 'lost':
        return Colors.grey.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'all':
        return Icons.list_alt;
      case 'open':
        return Icons.radio_button_unchecked;
      case 'lead':
        return Icons.person_outline;
      case 'opportunity':
        return Icons.trending_up;
      case 'quotation':
        return Icons.description_outlined;
      case 'converted':
        return Icons.check_circle_outline;
      case 'do not contact':
        return Icons.block;
      case 'interested':
        return Icons.favorite_outline;
      case 'won':
        return Icons.emoji_events_outlined;
      case 'lost':
        return Icons.close_rounded;
      default:
        return Icons.help_outline;
    }
  }


  void showNewEventDialog(List<String> assignees) {
    final _formKey = GlobalKey<FormState>();

    String selectedCategory = "Event";
    String? selectedAssignee;
    String summary = "";
    String description = "";
    DateTime? selectedDate;
    bool isPublic = false;

    List<String> categories = [
      "Event",
      "Meeting",
      "Call",
      "Sent/Received Email",
      "Other",
    ];

    showDialog(
      context: Get.context!,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: StatefulBuilder(
                builder: (context, setState) {
                  final dateController = TextEditingController(
                    text: selectedDate == null
                        ? ""
                        : "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}",
                  );

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "New Event",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Category Dropdown
                            DropdownButtonFormField<String>(
                              value: selectedCategory,
                              decoration: const InputDecoration(
                                labelText: "Category",
                                border: OutlineInputBorder(),
                              ),
                              items: categories
                                  .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 14),

                            // Date Picker
                            TextFormField(
                              readOnly: true,
                              controller: dateController,
                              decoration: const InputDecoration(
                                labelText: "Date *",
                                suffixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(),
                              ),
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    selectedDate = pickedDate;
                                  });
                                }
                              },
                              validator: (value) => (value ?? "").isEmpty
                                  ? "Please select a date"
                                  : null,
                            ),
                            const SizedBox(height: 14),

                            // Public Checkbox
                            CheckboxListTile(
                              title: const Text("Public"),
                              value: isPublic,
                              onChanged: (value) {
                                setState(() {
                                  isPublic = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                            const SizedBox(height: 14),

                            // Assignee DropdownSearch
                            DropdownSearch<String>(
                              selectedItem: selectedAssignee,
                              items: (filter, infiniteScrollProps) => assignees,
                              onChanged: (value) {
                                setState(() {
                                  selectedAssignee = value;
                                });
                              },
                              decoratorProps: const DropDownDecoratorProps(
                                decoration: InputDecoration(
                                  labelText: 'Assign To',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                                fit: FlexFit.loose,
                                constraints: BoxConstraints(
                                  maxHeight: 400,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Summary
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Summary *",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) => (value ?? "").isEmpty
                                  ? "Please enter a summary"
                                  : null,
                              onChanged: (value) => summary = value,
                            ),
                            const SizedBox(height: 14),

                            // Description
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Description",
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 4,
                              onChanged: (value) => description = value,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
controller.addEventApicall(title:selectedCategory , date: dateController.text, assign: selectedAssignee??'', summry: summary, desc: description);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            child: const Text(
                              "Create",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }








}
