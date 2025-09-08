// import 'dart:math';
// import 'package:amax_hr/app/modules/leadDetails/views/lead_details_view.dart';
// import 'package:amax_hr/common/component/custom_appbar.dart';
// import 'package:amax_hr/constant/assets_constant.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:amax_hr/app/modules/crm/controllers/crm_controller.dart';
// import 'package:amax_hr/app/modules/crmGraph/views/crm_graph_view.dart';
// import 'package:shimmer_animation/shimmer_animation.dart';
//
// class CrmView extends GetView<CrmController> {
//   CrmView({super.key});
//
//   final CrmController crmController = Get.put(CrmController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: CommonAppBar(
//         imagePath: AssetsConstant.tech_logo,
//         showBack: true,
//       ),
//       body: GetBuilder<CrmController>(
//         builder: (controller) {
//           if (controller.isLoading.value) {
//             return _buildLoadingState();
//           }
//
//           return CustomScrollView(
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               SliverToBoxAdapter(child: _buildHeaderSection(controller)),
//               SliverToBoxAdapter(child: _buildGridSection(controller)),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(child: _buildShimmerTopCard()),
//               const SizedBox(width: 16),
//               Expanded(child: _buildShimmerTopCard()),
//             ],
//           ),
//           const SizedBox(height: 32),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Shimmer(
//               child: Container(
//                 width: 150,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: _buildShimmerStatusCard(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeaderSection(CrmController controller) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "CRM Dashboard",
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.grey.shade800,
//                         letterSpacing: -1,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       "Manage your leads effectively",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey.shade600,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.indigo.shade400,
//                       Colors.purple.shade400,
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.indigo.withOpacity(0.3),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.analytics_outlined,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 32),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildEnhancedTopCard(
//                   title: "Total Leads",
//                   value: controller.allLeads.length.toString(),
//                   subtitle: "Active leads in pipeline",
//                   icon: Icons.people_outline,
//                   gradient: [Colors.blue.shade400, Colors.blue.shade600],
//                   onTap: () => controller.gotoLeadDetailsView()
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildEnhancedTopCard(
//                   title: "Analytics",
//                   value: "View",
//                   subtitle: "Detailed insights & graphs",
//                   icon: Icons.show_chart,
//                   gradient: [Colors.purple.shade400, Colors.purple.shade600],
//                   onTap: () => Get.to(() => CrmGraphView(),
//                       arguments: controller.allLeads),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGridSection(CrmController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 4,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.indigo.shade400, Colors.purple.shade400],
//                   ),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 "Lead Status Overview",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.grey.shade800,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           // ✅ Single Card With All Status Counts
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'All Lead Status Counts',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.grey.shade800,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Wrap(
//                     spacing: 12,
//                     runSpacing: 12,
//                     children: controller.leadsGroupedByStatus.entries
//                         .map((entry) => Chip(
//                       label: Text(
//                         '${_formatTitle(entry.key)}: ${entry.value.length}',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.w600),
//                       ),
//                       backgroundColor: Colors.grey.shade100,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ))
//                         .toList(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 32),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEnhancedTopCard({
//     required String title,
//     required String value,
//     required String subtitle,
//     required IconData icon,
//     required List<Color> gradient,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 140,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(colors: gradient),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: gradient[0].withOpacity(0.3),
//               blurRadius: 20,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: Stack(
//             children: [
//               Positioned(
//                 right: -20,
//                 top: -20,
//                 child: Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 right: -30,
//                 bottom: -30,
//                 child: Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.05),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(18),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Icon(icon, color: Colors.white, size: 20),
//                         ),
//                         const Spacer(),
//                         Icon(Icons.arrow_forward_ios,
//                             color: Colors.white.withOpacity(0.7), size: 14),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       value,
//                       style: const TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.white,
//                         height: 1.1,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Expanded(
//                       child: Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: Colors.white.withOpacity(0.85),
//                           fontWeight: FontWeight.w500,
//                           height: 1.3,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildShimmerTopCard() {
//     return Shimmer(
//       child: Container(
//         height: 120,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade300,
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildShimmerStatusCard() {
//     return Shimmer(
//       child: Container(
//         height: 300,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade300,
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//     );
//   }
//
//   String _formatTitle(String title) {
//     return title.split(' ').map((word) {
//       if (word.isEmpty) return word;
//       return word[0].toUpperCase() + word.substring(1).toLowerCase();
//     }).join(' ');
//   }
// }

import 'dart:math';
import 'package:amax_hr/app/modules/leadDetails/views/lead_details_view.dart';
import 'package:amax_hr/common/component/custom_appbar.dart';
import 'package:amax_hr/constant/assets_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amax_hr/app/modules/crm/controllers/crm_controller.dart';
import 'package:amax_hr/app/modules/crmGraph/views/crm_graph_view.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CrmView extends GetView<CrmController> {
  CrmView({super.key});

  final CrmController crmController = Get.put(CrmController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CommonAppBar(
        imagePath: AssetsConstant.tech_logo,
        showBack: true,
      ),
      body: GetBuilder<CrmController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return _buildLoadingState();
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeaderSection(controller)),
              SliverToBoxAdapter(child: _buildStatsCards(controller)),
              SliverToBoxAdapter(child: _buildQuickActions(controller)),
              SliverToBoxAdapter(child: _buildStatusOverview(controller)),
              SliverToBoxAdapter(child: _buildRecentActivity(controller)),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Header shimmer
          Shimmer(
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Stats cards shimmer
          Row(
            children: [
              Expanded(child: _buildShimmerCard(120)),
              const SizedBox(width: 16),
              Expanded(child: _buildShimmerCard(120)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildShimmerCard(120)),
              const SizedBox(width: 16),
              Expanded(child: _buildShimmerCard(120)),
            ],
          ),
          const SizedBox(height: 24),

          // Status overview shimmer
          Expanded(
            child: Shimmer(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCard(double height) {
    return Shimmer(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(CrmController controller) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.dashboard_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Live",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "CRM Dashboard",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Transform leads into revenue with intelligent insights",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(CrmController controller) {
    final totalLeads = controller.allLeads.length;
    final activeLeads = controller.allLeads.where((lead) =>
    lead.status?.toLowerCase() != 'closed' &&
        lead.status?.toLowerCase() != 'lost' &&
        lead.status?.toLowerCase() != 'converted'
    ).length;

    final conversionRate = totalLeads > 0 ? ((activeLeads / totalLeads) * 100).toInt() : 0;
    final estimatedRevenue = totalLeads * 15000;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildGlassStatsCard(
                  title: "Total Leads",
                  value: totalLeads.toString(),
                  subtitle: "+12% from last month",
                  icon: Icons.people_outline,
                  color: const Color(0xFF3B82F6),
                  onTap: () => controller.gotoLeadDetailsView(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGlassStatsCard(
                  title: "Active Leads",
                  value: activeLeads.toString(),
                  subtitle: "In pipeline",
                  icon: Icons.trending_up,
                  color: const Color(0xFF10B981),
                  onTap: () => controller.gotoLeadDetailsView(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildGlassStatsCard(
                  title: "Conversion",
                  value: "${conversionRate}%",
                  subtitle: "Success rate",
                  icon: Icons.analytics_outlined,
                  color: const Color(0xFF8B5CF6),
                  onTap: () => Get.to(() => CrmGraphView(), arguments: controller.allLeads),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGlassStatsCard(
                  title: "Revenue",
                  value: "₹${_formatCurrency(estimatedRevenue)}",
                  subtitle: "This quarter",
                  icon: Icons.currency_rupee,
                  color: const Color(0xFFF59E0B),
                  onTap: () => Get.to(() => CrmGraphView(), arguments: controller.allLeads),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassStatsCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_outward,
                  color: color.withOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.grey.shade800,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(CrmController controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  title: "Add Lead",
                  icon: Icons.person_add_outlined,
                  color: const Color(0xFF3B82F6),
                  onTap: () => controller.gotoLeadDetailsView(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  title: "Analytics",
                  icon: Icons.bar_chart,
                  color: const Color(0xFF8B5CF6),
                  onTap: () => Get.to(() => CrmGraphView(), arguments: controller.allLeads),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  title: "Reports",
                  icon: Icons.description_outlined,
                  color: const Color(0xFF10B981),
                  onTap: () => Get.to(() => CrmGraphView(), arguments: controller.allLeads),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOverview(CrmController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Lead Status Distribution",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.shade800,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Real-time",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildStatusGrid(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusGrid(CrmController controller) {
    final statusColors = {
      'open': const Color(0xFF3B82F6),
      'lead': const Color(0xFF10B981),
      'opportunity': const Color(0xFF8B5CF6),
      'quotation': const Color(0xFFF59E0B),
      'converted': const Color(0xFF059669),
      'do not contact': const Color(0xFFEF4444),
      'interested': const Color(0xFF06B6D4),
      'won': const Color(0xFF65A30D),
      'lost': const Color(0xFF9CA3AF),
    };

    final statusIcons = {
      'open': Icons.fiber_new,
      'lead': Icons.call_made,
      'opportunity': Icons.trending_up,
      'quotation': Icons.description,
      'converted': Icons.check_circle,
      'do not contact': Icons.block,
      'interested': Icons.favorite,
      'won': Icons.emoji_events,
      'lost': Icons.cancel,
    };

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: controller.leadsGroupedByStatus.entries
          .map((entry) {
        final status = entry.key.toLowerCase();
        final count = entry.value.length;
        final color = statusColors[status] ?? const Color(0xFF6B7280);
        final icon = statusIcons[status] ?? Icons.circle;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                  Text(
                    _formatTitle(entry.key),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      })
          .toList(),
    );
  }

  Widget _buildRecentActivity(CrmController controller) {
    // Get recent leads for activity display
    final recentLeads = controller.allLeads.take(5).toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.history,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Recent Activity",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.shade800,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => controller.gotoLeadDetailsView(),
                  child: Text(
                    "View All",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (recentLeads.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "No recent activities",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...recentLeads.take(3).map((lead) => _buildActivityItem(
                title: "Lead: ${lead.leadName ?? 'Unknown'}",
                subtitle: "Status: ${_formatTitle(lead.status ?? 'Open')} • ${lead.companyName ?? 'No Company'}",
                time: _getTimeAgo(lead.creation),
                icon: _getIconForStatus(lead.status ?? ''),
                color: _getColorForStatus(lead.status ?? ''),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatTitle(String title) {
    return title.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},'
    );
  }

  String _getTimeAgo(String? creation) {
    if (creation == null || creation.isEmpty) return "Recent";

    try {
      final createdDate = DateTime.parse(creation);
      final now = DateTime.now();
      final difference = now.difference(createdDate);

      if (difference.inDays > 0) {
        return "${difference.inDays}d ago";
      } else if (difference.inHours > 0) {
        return "${difference.inHours}h ago";
      } else if (difference.inMinutes > 0) {
        return "${difference.inMinutes}m ago";
      } else {
        return "Just now";
      }
    } catch (e) {
      return "Recent";
    }
  }

  IconData _getIconForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'open': return Icons.fiber_new;
      case 'lead': return Icons.call_made;
      case 'opportunity': return Icons.trending_up;
      case 'quotation': return Icons.description;
      case 'converted': return Icons.check_circle;
      case 'do not contact': return Icons.block;
      case 'interested': return Icons.favorite;
      case 'won': return Icons.emoji_events;
      case 'lost': return Icons.cancel;
      default: return Icons.circle;
    }
  }

  Color _getColorForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'open': return const Color(0xFF3B82F6);
      case 'lead': return const Color(0xFF10B981);
      case 'opportunity': return const Color(0xFF8B5CF6);
      case 'quotation': return const Color(0xFFF59E0B);
      case 'converted': return const Color(0xFF059669);
      case 'do not contact': return const Color(0xFFEF4444);
      case 'interested': return const Color(0xFF06B6D4);
      case 'won': return const Color(0xFF65A30D);
      case 'lost': return const Color(0xFF9CA3AF);
      default: return const Color(0xFF6B7280);
    }
  }
}