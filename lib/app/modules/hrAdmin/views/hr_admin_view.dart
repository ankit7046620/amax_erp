import 'package:amax_hr/constant/localel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hr_admin_controller.dart';

class HrAdminView extends GetView<HrAdminController> {
  const HrAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HrAdminController());

    final List<Map<String, dynamic>> cardData = [
      {
        'title': LabelConstants.totalEmployee,
        'value': "Ankit Patel",
        'subtitle': "Flutter Dev",
        'icon': Icons.person,
        'iconColor': Colors.teal
      },
      {
        'title': "Employee ID",
        'value': "EMP1234",
        'subtitle': "Amax HR",
        'icon': Icons.badge,
        'iconColor': Colors.blue
      },
      {
        'title': "Joining Date",
        'value': "12 Aug 2022",
        'subtitle': "2 Years",
        'icon': Icons.date_range,
        'iconColor': Colors.orange
      },
      {
        'title': "Contact",
        'value': "+91-9876543210",
        'subtitle': "Mobile",
        'icon': Icons.phone,
        'iconColor': Colors.indigo
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Employee Details',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00695C),
              ),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cardData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,           // ✅ 2 columns
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.3,       // ✅ Rectangular shape
              ),
              itemBuilder: (context, index) {
                final item = cardData[index];
                return _buildDashboardCard(
                  title: item['title'],
                  value: item['value'],
                  subtitle: item['subtitle'],
                  icon: item['icon'],
                  iconColor: item['iconColor'],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          /// Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 10),

          /// Text Content
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min, // 🔧 Prevent overflow
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
