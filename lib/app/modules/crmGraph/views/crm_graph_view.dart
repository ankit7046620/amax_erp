import 'package:amax_hr/common/component/custom_appbar.dart';
import 'package:amax_hr/constant/assets_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controllers/crm_graph_controller.dart';

class CrmGraphView extends GetView<CrmGraphController> {
  const CrmGraphView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CrmGraphController());

    return Scaffold(
      appBar:CommonAppBar(imagePath: AssetsConstant.tech_logo,showBack: true,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LINE CHART SECTION
            sectionHeaderWithFilter(
              title: 'Lead Trends',
              selectedValue: controller.chartTypeMap['Line Chart']!,
              onFilterTap: (type) {
                controller.updateChartTypeFor('Line Chart', type);
              },
            ),
            const SizedBox(height: 10),
            Obx(() {
              final List<ChartData> leadChartData = controller
                  .monthWiseLeadCounts.entries
                  .map((entry) => ChartData(entry.key, entry.value))
                  .toList();

              return SizedBox(
                height: 250,
                child: leadChartData.isEmpty
                    ? const Center(child: Text("No lead data available"))
                    : SfCartesianChart(
                  title: ChartTitle(
                    text:
                    'Leads Per ${controller.chartTypeMap['Line Chart']!.value}',
                  ),
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Time'),
                    labelRotation: -45,
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Lead Count'),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<ChartData, String>>[
                    LineSeries<ChartData, String>(
                      dataSource: leadChartData,
                      xValueMapper: (ChartData data, _) => data.month,
                      yValueMapper: (ChartData data, _) => data.count,
                      name: 'Leads',
                      markerSettings: const MarkerSettings(
                          isVisible: true),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 16),

            // BAR CHART SECTION
            sectionHeaderWithFilter(
              title: 'Won Opportunities',
              selectedValue: controller.chartTypeMap['Bar Chart']!,
              onFilterTap: (type) {
                controller.updateChartTypeFor('Bar Chart', type);
              },
            ),
            const SizedBox(height: 10),
            Obx(() {
              final List<ChartData> wonChartData = controller.wonChartData;

              return SizedBox(
                height: 250,
                child: wonChartData.isEmpty
                    ? const Center(child: Text("No 'Won' data available"))
                    : SfCartesianChart(
                  title: ChartTitle(
                    text:
                    'Won Per ${controller.chartTypeMap['Bar Chart']!.value}',
                  ),
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Time'),
                    labelRotation: -45,
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Won Count'),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  palette: const <Color>[Colors.green],
                  series: <CartesianSeries<ChartData, String>>[
                    ColumnSeries<ChartData, String>(
                      dataSource: wonChartData,
                      xValueMapper: (ChartData data, _) => data.month,
                      yValueMapper: (ChartData data, _) => data.count,
                      name: 'Won',
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true),
                    ),
                  ],
                ),
              );
            }),

            sectionHeaderWithFilter(
              title: 'Territory Distribution',
              selectedValue: controller.chartTypeMap['Territory Chart']!,
              onFilterTap: (type) {
                controller.updateChartTypeFor('Territory Chart', type);
              },
            ),
            const SizedBox(height: 10),
            Obx(() {
              final data = controller.territoryChartData;

              return SizedBox(
                height: 300,
                child: data.isEmpty
                    ? const Center(child: Text("No territory data"))
                    : SfCircularChart(
                  title: ChartTitle(
                    text:
                    'Territory Chart (${ controller.chartTypeMap['Territory Chart']!})',
                  ),
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  series: <DoughnutSeries<ChartData, String>>[
                    DoughnutSeries<ChartData, String>(
                      dataSource: data,
                      xValueMapper: (ChartData data, _) => data.month,
                      yValueMapper: (ChartData data, _) => data.count,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                      enableTooltip: true,
                      explode: true,
                      radius: '80%',
                    )
                  ],
                ),
              );
            }),


            sectionHeaderWithFilter(
              title: 'Source Distribution',
              selectedValue: controller.chartTypeMap['Source Chart']!,
              onFilterTap: (type) {
                controller.updateChartTypeFor('Source Chart', type);
              },
            ),
            const SizedBox(height: 10),
            Obx(() {
              final data = controller.sourceChartData;

              return SizedBox(
                height: 300,
                child: data.isEmpty
                    ? const Center(child: Text("No territory data"))
                    : SfCircularChart(
                  title: ChartTitle(
                    text:
                    'Source Chart (${ controller.chartTypeMap['Source Chart']!})',
                  ),
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  series: <DoughnutSeries<ChartData, String>>[
                    DoughnutSeries<ChartData, String>(
                      dataSource: data,
                      xValueMapper: (ChartData data, _) => data.month,
                      yValueMapper: (ChartData data, _) => data.count,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                      enableTooltip: true,
                      explode: true,
                      radius: '80%',
                    )
                  ],
                ),
              );
            }),

            sectionHeaderWithFilter(
              title: 'Sales Performance',
              selectedValue: controller.chartTypeMap['Sales Performance']!,
              onFilterTap: (type) {
                controller.updateChartTypeFor('Sales Performance', type);
              },
            ),
            const SizedBox(height: 10),
            Obx(() {
              final data = controller.barChartData;

              return SizedBox(
                height: 350,
                child: data.isEmpty
                    ? const Center(child: Text("No Sales Performance data"))
                    : SfCartesianChart(
                  title: ChartTitle(
                    text:
                    'Sales Performance (${controller.chartTypeMap['Sales Performance']!.value.capitalizeFirst})',
                  ),
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Time Period'),
                    labelRotation: 45,
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Lead Count'),
                  ),
                  series: controller.buildSalesBarSeries(),
                ),
              );
            }),



          ],
        ),
      ),
    );
  }

  /// Common Header with Dropdown Filter
  Widget sectionHeaderWithFilter({
    required String title,
    required RxString selectedValue,
    required ValueChanged<String> onFilterTap,
  }) {
    final CrmGraphController controller = Get.find();

    return Obx(() {
      final currentValue = controller.chartTypes.contains(selectedValue.value)
          ? selectedValue.value
          : 'Monthly';

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              '$title ($currentValue)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          DropdownButton<String>(
            value: currentValue,
            icon: const Icon(Icons.arrow_drop_down),
            underline: Container(height: 1, color: Colors.transparent),
            style: const TextStyle(fontSize: 14, color: Colors.black),
            items: controller.chartTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onFilterTap(value);
                print('$title - $value');
              }
            },
          ),
        ],
      );
    });
  }
}
