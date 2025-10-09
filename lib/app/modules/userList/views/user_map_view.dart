import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/user_list_controller.dart';

class UserMapView extends GetView<UserListController> {
  const UserMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Map'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Obx(() {
        if (controller.users.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              controller.users.first['lat'],
              controller.users.first['long'],
            ),
            zoom: 2,
          ),
          markers: controller.markers,
          onMapCreated: controller.onMapCreated,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          compassEnabled: true,
          mapToolbarEnabled: true,
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Reset camera to show all markers
          if (controller.mapController != null && controller.users.isNotEmpty) {
            double minLat = controller.users.first['lat'];
            double maxLat = controller.users.first['lat'];
            double minLong = controller.users.first['long'];
            double maxLong = controller.users.first['long'];

            for (var user in controller.users) {
              if (user['lat'] < minLat) minLat = user['lat'];
              if (user['lat'] > maxLat) maxLat = user['lat'];
              if (user['long'] < minLong) minLong = user['long'];
              if (user['long'] > maxLong) maxLong = user['long'];
            }

            LatLngBounds bounds = LatLngBounds(
              southwest: LatLng(minLat, minLong),
              northeast: LatLng(maxLat, maxLong),
            );

            controller.mapController?.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, 50),
            );
          }
        },
        icon: const Icon(Icons.center_focus_strong),
        label: const Text('Show All'),
      ),
    );
  }
}