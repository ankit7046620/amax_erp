import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/purchase_orders_dashboard_controller.dart';

class PurchaseOrdersDashboardView extends StatelessWidget {
  const PurchaseOrdersDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PurchaseOrdersDashboardController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Orders Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final items = [
          {
            "title": "ANNUAL PURCHASES",
            "icon": Icons.attach_money,
            "color": Colors.blue,
            "count": controller.totalPurchaseAmount.value,
            "currency": true,
            "key": 'PURCHASES'
          },
          {
            "title": "Purchase Orders to Receive",
            "icon": Icons.inbox,
            "color": Colors.orange,
            "count": controller.pOrdersToReceive,
            "currency": false,
            "key": 'Purchase Orders to Receive'
          },
          {
            "title": "Purchase Orders to Bill",
            "icon": Icons.receipt_long,
            "color": Colors.purple,
            "count": controller.pOrdersToBill,
            "currency": false,
            "key": 'Purchase Orders to Bill'
          },
          {
            "title": "Active Suppliers",
            "icon": Icons.people,
            "color": Colors.green,
            "count": 1,
            "currency": false,
            "key": 'Active Suppliers'
          },
        ];

        return Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.95, // Adjust this value for card height
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              final key = item['key'] as String;

              return _buildCard(
                context: context,
                title: item['title'] as String,
                icon: item['icon'] as IconData,
                color: item['color'] as Color,
                count: item['count'],
                currency: item['currency'] as bool,
                selectedItem: controller.filterTypeMap[key]!,
                onChanged: (val) {
                  controller.filterTypeMap[key]!.value = val!;
                  controller.updateChartTypeFor(key, val);
                },
              );
            },
          ),
        );
      }),
    );
  }
}

Widget _buildCard({
  required BuildContext context,
  required String title,
  required IconData icon,
  required Color color,
  required dynamic count,
  bool currency = false,
  required RxString selectedItem,
  required Function(String?) onChanged,
}) {
  final size = MediaQuery.of(context).size;

  String format(dynamic value) {
    if (currency) {
      final parsed = value is num ? value : double.tryParse(value.toString()) ?? 0.0;
      return "₹ ${parsed.toStringAsFixed(2)}";
    }
    return value.toString();
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      final iconSize = constraints.maxWidth * 0.15;
      final titleSize = constraints.maxWidth * 0.07;
      final valueSize = constraints.maxWidth * 0.1;

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.85), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, size: iconSize, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      format(count),
                      style: TextStyle(
                        fontSize: valueSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Obx(() => Align(
                      alignment: Alignment.bottomRight,
                      child: DropdownButton<String>(
                        value: selectedItem.value,
                        iconEnabledColor: Colors.white,
                        dropdownColor: color,
                        style: const TextStyle(color: Colors.white),
                        underline: const SizedBox(),
                        onChanged: onChanged,
                        items: PurchaseOrdersDashboardController.chartFilters
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                            .toList(),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
