// import 'package:flutter/material.dart';
//
// import 'package:get/get.dart';
//
// import '../controllers/bottam_controller.dart';
//
// class BottamView extends GetView<BottamController> {
//   const BottamView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     Get.put(BottamController());
//     return Scaffold(
//       appBar: AppBar(title: Text("Modules")),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         return GridView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: controller.moduleNames.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2, // 2 columns
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 3, // adjust height
//           ),
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: (){
//                 controller.handleModule(controller.moduleNames[index]);
//               },
//               child: Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 child: Center(
//                   child: Text(
//                     controller.moduleNames[index],
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottam_controller.dart';

class BottamView extends GetView<BottamController> {
  const BottamView({super.key});

  // Method to get module configuration (color and icon)
  Map<String, dynamic> getModuleConfig(String moduleName) {
    final configs = {
      'Accounts': {'color': Colors.green, 'icon': Icons.account_balance},
      'Assets': {'color': Colors.blue, 'icon': Icons.business_center},
      'Automation': {'color': Colors.purple, 'icon': Icons.auto_mode},
      'BAPS': {'color': Colors.orange, 'icon': Icons.analytics},
      'Bulk Transacti': {'color': Colors.indigo, 'icon': Icons.batch_prediction},
      'Buying': {'color': Colors.teal, 'icon': Icons.shopping_cart},
      'CIS': {'color': Colors.cyan, 'icon': Icons.info},
      'Communication': {'color': Colors.pink, 'icon': Icons.contacts},
      'Contacts': {'color': Colors.amber, 'icon': Icons.contacts},
      'Core': {'color': Colors.red, 'icon': Icons.settings},
      'CRM': {'color': Colors.deepPurple, 'icon': Icons.people},
      'Custom': {'color': Colors.brown, 'icon': Icons.build},
      'Desk': {'color': Colors.lightGreen, 'icon': Icons.desktop_windows},
      'Email': {'color': Colors.blueGrey, 'icon': Icons.email},
      'ERPNext Integr': {'color': Colors.deepOrange, 'icon': Icons.integration_instructions},
      'File': {'color': Colors.grey, 'icon': Icons.folder},
      'Geo': {'color': Colors.lightBlue, 'icon': Icons.location_on},
      'HR': {'color': Colors.pinkAccent, 'icon': Icons.person},
      'Integrations': {'color': Colors.yellowAccent, 'icon': Icons.link},
      'Maintenance': {'color': Colors.redAccent, 'icon': Icons.build_circle},
      'Manufactoring': {'color': Colors.brown, 'icon': Icons.precision_manufacturing},
      'Manufacturing': {'color': Colors.blueAccent, 'icon': Icons.factory},
      'Payment Gatewa': {'color': Colors.green, 'icon': Icons.payment},
      'Payments': {'color': Colors.greenAccent, 'icon': Icons.account_balance_wallet},
      'Payroll': {'color': Colors.tealAccent, 'icon': Icons.money},
      'Portal': {'color': Colors.purpleAccent, 'icon': Icons.web},
      'Printing': {'color': Colors.orangeAccent, 'icon': Icons.print},
      'Prods': {'color': Colors.lime, 'icon': Icons.inventory},
      'Projects': {'color': Colors.indigo, 'icon': Icons.work},
      'Quality Manage': {'color': Colors.cyan, 'icon': Icons.verified},
      'Regional': {'color': Colors.amber, 'icon': Icons.public},
      'Selling': {'color': Colors.pink, 'icon': Icons.sell},
      'Setup': {'color': Colors.grey, 'icon': Icons.settings_applications},
      'Social': {'color': Colors.blue, 'icon': Icons.share},
      'Stock': {'color': Colors.orange, 'icon': Icons.inventory_2},
      'Subcontracting': {'color': Colors.deepPurple, 'icon': Icons.handshake},
      'Support': {'color': Colors.green, 'icon': Icons.support_agent},
      'Telephony': {'color': Colors.red, 'icon': Icons.phone},
      'Utilities': {'color': Colors.brown, 'icon': Icons.construction},
      'Website': {'color': Colors.blue, 'icon': Icons.language},
      'Workflow': {'color': Colors.purple, 'icon': Icons.alt_route},
      'X fieldss': {'color': Colors.grey, 'icon': Icons.extension},
    };

    return configs[moduleName] ?? {'color': Colors.grey, 'icon': Icons.apps};
  }

  @override
  Widget build(BuildContext context) {
    Get.put(BottamController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Modules"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.moduleNames.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.5, // adjusted for icon + text
          ),
          itemBuilder: (context, index) {
            final moduleName = controller.moduleNames[index];
            final config = getModuleConfig(moduleName);

            return GestureDetector(
              onTap: () {
                controller.handleModule(moduleName);
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        config['color'].withOpacity(0.8),
                        config['color'].withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        config['icon'],
                        size: 32,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          moduleName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}