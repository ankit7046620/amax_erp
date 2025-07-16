import 'package:amax_hr/vo/crm_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadDetailsView extends StatelessWidget {
  const LeadDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments;
    final String status = args['status'] ?? 'Unknown';
    final List<Data> leads = List<Data>.from(args['leads'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text("Leads - $status"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: leads.isEmpty
          ? const Center(child: Text("No leads found."))
          : ListView.separated(
        itemCount: leads.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final lead = leads[index];
          return ListTile(
            title: Text(lead.leadName ?? 'No Name'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Company: ${lead.companyName ?? 'N/A'}"),
                Text("Created: ${lead.creation ?? 'N/A'}"),
                Text("Status: ${lead.status ?? 'N/A'}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
