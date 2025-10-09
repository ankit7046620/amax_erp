import 'package:amax_hr/app/modules/EmployeeCheckin/controllers/employee_checkin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Enhanced Employee Checkin Popup Widget with Geofencing
class NewEmployeeCheckinPopup extends GetView<EmployeeCheckinController> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: Get.width * 0.95,
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.9,
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with location status
              _buildHeader(),
              const SizedBox(height: 20),

              // Location Status Card
              _buildLocationStatusCard(),
              const SizedBox(height: 20),

              // Employee Selection
              _buildEmployeeSelection(),
              const SizedBox(height: 20),

              // Time Selection
              _buildTimeSelection(context),
              const SizedBox(height: 20),

              // Log Type Selection
              _buildLogTypeSelection(),
              const SizedBox(height: 20),

              // Location Details
              _buildLocationDetails(),
              const SizedBox(height: 16),

              // Map Toggle Button
              _buildMapToggleButton(),
              const SizedBox(height: 16),

              // Google Map (conditionally shown)
              Obx(() => controller.showMap.value
                  ? _buildGoogleMap()
                  : const SizedBox.shrink()),

              const SizedBox(height: 24),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          color: Colors.indigo.shade600,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Employee Checkin (Geofenced)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.indigo.shade700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildLocationStatusCard() {
    return Obx(() {
      if (controller.isLocationLoading.value) {
        return _buildLoadingLocationCard();
      }

      if (controller.locationError.value.isNotEmpty) {
        return _buildLocationErrorCard();
      }

      if (controller.currentPosition.value == null) {
        return _buildNoLocationCard();
      }

      return _buildLocationStatusDetailsCard();
    });
  }

  Widget _buildLoadingLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.blue.shade600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Getting your location...',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationErrorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error, color: Colors.red.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Location Error',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            controller.locationError.value,
            style: TextStyle(
              color: Colors.red.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => controller.refreshLocation(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_off, color: Colors.orange.shade600),
              const SizedBox(width: 8),
              Text(
                'Location Required',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Please enable location services to proceed',
            style: TextStyle(
              color: Colors.orange.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStatusDetailsCard() {
    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: controller.isWithinGeofence.value
            ? Colors.green.shade50
            : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: controller.isWithinGeofence.value
              ? Colors.green.shade200
              : Colors.red.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                controller.isWithinGeofence.value
                    ? Icons.check_circle
                    : Icons.error,
                color: controller.isWithinGeofence.value
                    ? Colors.green.shade600
                    : Colors.red.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.isWithinGeofence.value
                      ? 'Location Verified ✓'
                      : 'Outside Office Area',
                  style: TextStyle(
                    color: controller.isWithinGeofence.value
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => controller.refreshLocation(),
                icon: Icon(
                  Icons.refresh,
                  color: controller.isWithinGeofence.value
                      ? Colors.green.shade600
                      : Colors.red.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (controller.nearestOffice.value != null) ...[
            _buildLocationDetail(
              'Office',
              controller.nearestOffice.value!.name,
              Icons.business,
            ),
            _buildLocationDetail(
              'Distance',
              '${controller.distanceFromOffice.value.round()}m',
              Icons.straighten,
            ),
            _buildLocationDetail(
              'Required',
              'Within ${controller.nearestOffice.value!.radiusInMeters.round()}m',
              Icons.radio_button_unchecked,
            ),
          ],
          if (!controller.isWithinGeofence.value) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Please move closer to the office location to proceed with check-in/out.',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    ));
  }

  Widget _buildLocationDetail(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Employee *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Type to search employee...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                onChanged: (value) {
                  controller.filterEmployees(value);
                  controller.showEmployeeDropdown.value = true;
                },
                onTap: () {
                  controller.showEmployeeDropdown.value = true;
                  if (controller.searchController.text.isEmpty) {
                    controller.filteredEmployeeList.value = controller.employeeList;
                  }
                  if (controller.filteredEmployeeList.isEmpty && controller.employeeList.isNotEmpty) {
                    controller.filteredEmployeeList.value = controller.employeeList;
                  }
                },
              ),
              Obx(() {
                if (controller.showEmployeeDropdown.value && controller.filteredEmployeeList.isNotEmpty) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey[300]!)),
                    ),
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.filteredEmployeeList.length,
                      itemBuilder: (context, index) {
                        final employee = controller.filteredEmployeeList[index];
                        return ListTile(
                          dense: true,
                          title: Text(
                            employee.employee,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            employee.employeeName,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          onTap: () => controller.selectEmployee(employee),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => controller.selectDateTime(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => Text(
                    DateFormat('dd-MM-yyyy HH:mm:ss').format(controller.selectedDateTime.value),
                    style: const TextStyle(fontSize: 14),
                  )),
                ),
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Log Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: controller.selectedLogType.value,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.selectedLogType.value = newValue;
                }
              },
              items: const [
                DropdownMenuItem(
                  value: 'IN',
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(Icons.login, color: Colors.green, size: 18),
                        SizedBox(width: 8),
                        Text('Check IN'),
                      ],
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 'OUT',
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red, size: 18),
                        SizedBox(width: 8),
                        Text('Check OUT'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildLocationDetails() {
    return Obx(() {
      if (controller.currentPosition.value == null) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location Details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            _buildLocationDetail(
              'Latitude',
              controller.currentPosition.value!.latitude.toStringAsFixed(6),
              Icons.my_location,
            ),
            _buildLocationDetail(
              'Longitude',
              controller.currentPosition.value!.longitude.toStringAsFixed(6),
              Icons.my_location,
            ),
            _buildLocationDetail(
              'Accuracy',
              '${controller.currentPosition.value!.accuracy.round()}m',
              Icons.gps_fixed,
            ),
            _buildLocationDetail(
              'Device ID',
              'WEB_APP_GEOFENCED',
              Icons.devices,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMapToggleButton() {
    return Center(
      child: Obx(() => ElevatedButton.icon(
        onPressed: () {
          controller.showMap.value = !controller.showMap.value;
        },
        icon: Icon(
          controller.showMap.value ? Icons.map_outlined : Icons.map,
          size: 18,
        ),
        label: Text(controller.showMap.value ? 'Hide Map' : 'Show Map'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      )),
    );
  }

  Widget _buildGoogleMap() {
    return Obx(() {
      if (controller.currentPosition.value == null) {
        return const SizedBox.shrink();
      }

      return Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GoogleMap(
            onMapCreated: (GoogleMapController mapController) {
              controller.mapController.value = mapController;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                controller.currentPosition.value!.latitude,
                controller.currentPosition.value!.longitude,
              ),
              zoom: 16.0,
            ),
            markers: controller.markers,
            circles: controller.circles,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
          ),
        ),
      );
    });
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(() => ElevatedButton(
            onPressed: controller.isSubmitting.value
                ? null
                : controller.isWithinGeofence.value
                ? () => controller.createEmployeeCheckin()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.isWithinGeofence.value
                  ? Colors.green
                  : Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: controller.isSubmitting.value
                ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.selectedLogType.value == 'IN'
                      ? Icons.login
                      : Icons.logout,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text('${controller.selectedLogType.value == 'IN' ? 'Check In' : 'Check Out'}'),
              ],
            ),
          )),
        ),
      ],
    );
  }
}