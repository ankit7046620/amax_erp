import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/bottam_controller.dart';

class BottamView extends GetView<BottamController> {
  const BottamView({super.key});

  Map<String, dynamic> getModuleConfig(String moduleName) {
    final configs = {
      'Accounts': {'color': Colors.green, 'icon': FontAwesomeIcons.moneyBillTrendUp},
      'Assets': {'color': Colors.blue, 'icon': FontAwesomeIcons.building},
      'Automation': {'color': Colors.purple, 'icon': FontAwesomeIcons.robot},
      'BAPS': {'color': Colors.orange, 'icon': FontAwesomeIcons.chartColumn},
      'Bulk Transacti': {'color': Colors.indigo, 'icon': FontAwesomeIcons.truckRampBox},
      'Buying': {'color': Colors.teal, 'icon': FontAwesomeIcons.cartShopping},
      'CIS': {'color': Colors.cyan, 'icon': FontAwesomeIcons.idCard},
      'Communication': {'color': Colors.pink, 'icon': FontAwesomeIcons.comments},
      'Contacts': {'color': Colors.amber, 'icon': FontAwesomeIcons.addressBook},
      'Core': {'color': Colors.red, 'icon': FontAwesomeIcons.gear},
      'CRM': {'color': Colors.deepPurple, 'icon': FontAwesomeIcons.userTie},
      'Custom': {'color': Colors.brown, 'icon': FontAwesomeIcons.puzzlePiece},
      'Desk': {'color': Colors.lightGreen, 'icon': FontAwesomeIcons.desktop},
      'Email': {'color': Colors.blueGrey, 'icon': FontAwesomeIcons.envelope},
      'ERPNext Integr': {'color': Colors.deepOrange, 'icon': FontAwesomeIcons.plug},
      'File': {'color': Colors.grey, 'icon': FontAwesomeIcons.fileLines},
      'Geo': {'color': Colors.lightBlue, 'icon': FontAwesomeIcons.mapLocationDot},
      'HR': {'color': Colors.pinkAccent, 'icon': FontAwesomeIcons.usersGear},
      'Integrations': {'color': Colors.yellowAccent, 'icon': FontAwesomeIcons.link},
      'Maintenance': {'color': Colors.redAccent, 'icon': FontAwesomeIcons.screwdriverWrench},
      'Manufactoring': {'color': Colors.brown, 'icon': FontAwesomeIcons.industry},
      'Manufacturing': {'color': Colors.blueAccent, 'icon': FontAwesomeIcons.industry},
      'Payment Gatewa': {'color': Colors.green, 'icon': FontAwesomeIcons.creditCard},
      'Payments': {'color': Colors.greenAccent, 'icon': FontAwesomeIcons.wallet},
      'Payroll': {'color': Colors.tealAccent, 'icon': FontAwesomeIcons.moneyCheckDollar},
      'Portal': {'color': Colors.purpleAccent, 'icon': FontAwesomeIcons.globe},
      'Printing': {'color': Colors.orangeAccent, 'icon': FontAwesomeIcons.print},
      'Prods': {'color': Colors.lime, 'icon': FontAwesomeIcons.boxesStacked},
      'Projects': {'color': Colors.indigo, 'icon': FontAwesomeIcons.diagramProject},
      'Quality Manage': {'color': Colors.cyan, 'icon': FontAwesomeIcons.checkDouble},
      'Regional': {'color': Colors.amber, 'icon': FontAwesomeIcons.earthAsia},
      'Selling': {'color': Colors.pink, 'icon': FontAwesomeIcons.tags},
      'Setup': {'color': Colors.grey, 'icon': FontAwesomeIcons.tools},
      'Social': {'color': Colors.blue, 'icon': FontAwesomeIcons.shareNodes},
      'Stock': {'color': Colors.orange, 'icon': FontAwesomeIcons.boxesPacking},
      'Subcontracting': {'color': Colors.deepPurple, 'icon': FontAwesomeIcons.handshake},
      'Support': {'color': Colors.green, 'icon': FontAwesomeIcons.headset},
      'Telephony': {'color': Colors.red, 'icon': FontAwesomeIcons.phoneVolume},
      'Utilities': {'color': Colors.brown, 'icon': FontAwesomeIcons.toolbox},
      'Website': {'color': Colors.blue, 'icon': FontAwesomeIcons.windowMaximize},
      'Workflow': {'color': Colors.purple, 'icon': FontAwesomeIcons.diagramSuccessor},
      'X fieldss': {'color': Colors.grey, 'icon': FontAwesomeIcons.shapes},
    };

    return configs[moduleName] ?? {'color': Colors.grey, 'icon': FontAwesomeIcons.cubes};
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottamController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Modules"),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            itemCount: controller.moduleNames.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final moduleName = controller.moduleNames[index];
              final config = getModuleConfig(moduleName);

              return InkWell(
                onTap: () => controller.handleModule(moduleName),
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        config['color'].withOpacity(0.85),
                        config['color'].withOpacity(0.65),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: config['color'].withOpacity(0.35),
                        blurRadius: 6,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        config['icon'],
                        size: 28,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          moduleName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
