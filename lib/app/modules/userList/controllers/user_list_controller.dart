import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserListController extends GetxController {
  final users = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  GoogleMapController? mapController;
  final markers = <Marker>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }

  void fetchUsers() {
    isLoading.value = true;

    // Simulate API delay
    Future.delayed(const Duration(seconds: 1), () {
      users.value = [
        {
          "username": "rahul_patel",
          "email": "rahul.patel@example.com",
          "location": "Asaram Road, Padli, Ahmedabad, India",
          "lat": 23.0300,
          "long": 72.5800
        },
        {
          "username": "neha_shah",
          "email": "neha.shah@example.com",
          "location": "Asaram Road, Padli, Ahmedabad, India",
          "lat": 23.0312,
          "long": 72.5815
        },
        {
          "username": "amit_trivedi",
          "email": "amit.trivedi@example.com",
          "location": "Asaram Road, Padli, Ahmedabad, India",
          "lat": 23.0325,
          "long": 72.5798
        },
        {
          "username": "priya_mehta",
          "email": "priya.mehta@example.com",
          "location": "Asaram Road, Padli, Ahmedabad, India",
          "lat": 23.0330,
          "long": 72.5820
        },
        {
          "username": "vishal_desai",
          "email": "vishal.desai@example.com",
          "location": "Asaram Road, Padli, Ahmedabad, India",
          "lat": 23.0340,
          "long": 72.5830
        },
      ];

      isLoading.value = false;
      createMarkers();
    });

  }

  void createMarkers() {
    markers.clear();
    for (var i = 0; i < users.length; i++) {
      final user = users[i];
      markers.add(
        Marker(
          markerId: MarkerId(user['username']),
          position: LatLng(user['lat'], user['long']),
          infoWindow: InfoWindow(
            title: user['username'],
            snippet: user['location'],
            onTap: () {
              showUserDetails(user);
            },
          ),
          onTap: () {
            showUserDetails(user);
          },
        ),
      );
    }
  }

  void showUserDetails(Map<String, dynamic> user) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Get.theme.primaryColor,
                    child: Text(
                      user['username'][0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['username'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user['email'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildDetailRow(Icons.location_on, 'Location', user['location']),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.map, 'Latitude', user['lat'].toString()),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.map, 'Longitude', user['long'].toString()),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Calculate bounds to show all markers
    if (users.isNotEmpty) {
      double minLat = users.first['lat'];
      double maxLat = users.first['lat'];
      double minLong = users.first['long'];
      double maxLong = users.first['long'];

      for (var user in users) {
        if (user['lat'] < minLat) minLat = user['lat'];
        if (user['lat'] > maxLat) maxLat = user['lat'];
        if (user['long'] < minLong) minLong = user['long'];
        if (user['long'] > maxLong) maxLong = user['long'];
      }

      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(minLat, minLong),
        northeast: LatLng(maxLat, maxLong),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50),
        );
      });
    }
  }
}