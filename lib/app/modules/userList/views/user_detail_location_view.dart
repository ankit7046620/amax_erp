import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserDetailLocationView extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserDetailLocationView({super.key, required this.user});

  @override
  State<UserDetailLocationView> createState() => _UserDetailLocationViewState();
}

class _UserDetailLocationViewState extends State<UserDetailLocationView> {
  GoogleMapController? _mapController;
  String selectedPeriod = 'Today';
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  // Simulated travel history data
  final Map<String, List<Map<String, dynamic>>> travelHistory = {
    'Today': [
      {'lat': 23.0300, 'long': 72.5800, 'time': '09:00 AM', 'address': 'Home - Asaram Road'},
      {'lat': 23.0320, 'long': 72.5810, 'time': '10:30 AM', 'address': 'Office - SG Highway'},
      {'lat': 23.0350, 'long': 72.5850, 'time': '01:00 PM', 'address': 'Restaurant - Maninagar'},
      {'lat': 23.0320, 'long': 72.5810, 'time': '02:30 PM', 'address': 'Office - SG Highway'},
      {'lat': 23.0300, 'long': 72.5800, 'time': '06:00 PM', 'address': 'Home - Asaram Road'},
    ],
    'Yesterday': [
      {'lat': 23.0300, 'long': 72.5800, 'time': '08:30 AM', 'address': 'Home - Asaram Road'},
      {'lat': 23.0280, 'long': 72.5780, 'time': '09:30 AM', 'address': 'Gym - Vastrapur'},
      {'lat': 23.0320, 'long': 72.5810, 'time': '11:00 AM', 'address': 'Office - SG Highway'},
      {'lat': 23.0400, 'long': 72.5900, 'time': '01:30 PM', 'address': 'Client Meeting - CG Road'},
      {'lat': 23.0320, 'long': 72.5810, 'time': '03:00 PM', 'address': 'Office - SG Highway'},
      {'lat': 23.0300, 'long': 72.5800, 'time': '07:00 PM', 'address': 'Home - Asaram Road'},
    ],
    'Last 7 Days': [
      {'lat': 23.0300, 'long': 72.5800, 'time': 'Oct 3', 'address': 'Home - Asaram Road'},
      {'lat': 23.0320, 'long': 72.5810, 'time': 'Oct 3', 'address': 'Office - SG Highway'},
      {'lat': 23.0500, 'long': 72.6000, 'time': 'Oct 4', 'address': 'Mall - Satellite'},
      {'lat': 23.0200, 'long': 72.5700, 'time': 'Oct 5', 'address': 'Airport Road'},
      {'lat': 23.0450, 'long': 72.5950, 'time': 'Oct 6', 'address': 'Science City'},
      {'lat': 23.0320, 'long': 72.5810, 'time': 'Oct 7', 'address': 'Office - SG Highway'},
      {'lat': 23.0380, 'long': 72.5880, 'time': 'Oct 8', 'address': 'Shopping Center'},
      {'lat': 23.0300, 'long': 72.5800, 'time': 'Oct 9', 'address': 'Home - Asaram Road'},
    ],
    'Last 30 Days': [
      {'lat': 23.0300, 'long': 72.5800, 'time': 'Sep 10', 'address': 'Home - Asaram Road'},
      {'lat': 23.0600, 'long': 72.6100, 'time': 'Sep 15', 'address': 'North Ahmedabad'},
      {'lat': 23.0100, 'long': 72.5600, 'time': 'Sep 20', 'address': 'South Ahmedabad'},
      {'lat': 23.0320, 'long': 72.5810, 'time': 'Sep 25', 'address': 'Office - SG Highway'},
      {'lat': 23.0700, 'long': 72.6200, 'time': 'Sep 30', 'address': 'Gandhinagar'},
      {'lat': 23.0400, 'long': 72.5900, 'time': 'Oct 5', 'address': 'CG Road Area'},
      {'lat': 23.0300, 'long': 72.5800, 'time': 'Oct 9', 'address': 'Home - Asaram Road'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _updateMarkersAndRoute();
  }

  void _updateMarkersAndRoute() {
    setState(() {
      _markers.clear();
      _polylines.clear();

      final locations = travelHistory[selectedPeriod] ?? [];

      if (locations.isEmpty) return;

      // Create markers for each location
      for (int i = 0; i < locations.length; i++) {
        final location = locations[i];
        _markers.add(
          Marker(
            markerId: MarkerId('location_$i'),
            position: LatLng(location['lat'], location['long']),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              i == 0 ? BitmapDescriptor.hueGreen :
              i == locations.length - 1 ? BitmapDescriptor.hueRed :
              BitmapDescriptor.hueOrange,
            ),
            infoWindow: InfoWindow(
              title: location['time'],
              snippet: location['address'],
            ),
          ),
        );
      }

      // Create polyline connecting all points
      if (locations.length > 1) {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: locations.map((loc) => LatLng(loc['lat'], loc['long'])).toList(),
            color: Colors.blue,
            width: 4,
            patterns: [PatternItem.dot, PatternItem.gap(10)],
          ),
        );
      }

      // Adjust camera to show all markers
      _adjustCamera(locations);
    });
  }

  void _adjustCamera(List<Map<String, dynamic>> locations) {
    if (locations.isEmpty || _mapController == null) return;

    double minLat = locations.first['lat'];
    double maxLat = locations.first['lat'];
    double minLong = locations.first['long'];
    double maxLong = locations.first['long'];

    for (var loc in locations) {
      if (loc['lat'] < minLat) minLat = loc['lat'];
      if (loc['lat'] > maxLat) maxLat = loc['lat'];
      if (loc['long'] < minLong) minLong = loc['long'];
      if (loc['long'] > maxLong) maxLong = loc['long'];
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat - 0.001, minLong - 0.001),
      northeast: LatLng(maxLat + 0.001, maxLong + 0.001),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final locations = travelHistory[selectedPeriod] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user['username']),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          // User Info Card
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    widget.user['username'][0].toUpperCase(),
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
                        widget.user['username'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.user['email'],
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
          ),

          // Time Period Selector
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.grey[100],
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: ['Today', 'Yesterday', 'Last 7 Days', 'Last 30 Days']
                  .map((period) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(period),
                  selected: selectedPeriod == period,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        selectedPeriod = period;
                      });
                      _updateMarkersAndRoute();
                    }
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: selectedPeriod == period
                        ? Colors.blue
                        : Colors.black87,
                    fontWeight: selectedPeriod == period
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ))
                  .toList(),
            ),
          ),

          // Map View
          Expanded(
            flex: 3,
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
                _updateMarkersAndRoute();
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.user['lat'], widget.user['long']),
                zoom: 13,
              ),
              markers: _markers,
              polylines: _polylines,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              mapToolbarEnabled: false,
            ),
          ),

          // Location History List
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Location History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${locations.length} locations',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: locations.isEmpty
                        ? Center(
                      child: Text(
                        'No location history available',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                        : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        final location = locations[index];
                        final isFirst = index == 0;
                        final isLast = index == locations.length - 1;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Timeline indicator
                            Column(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isFirst
                                        ? Colors.green
                                        : isLast
                                        ? Colors.red
                                        : Colors.orange,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                if (!isLast)
                                  Container(
                                    width: 2,
                                    height: 60,
                                    color: Colors.grey[300],
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            // Location details
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey[200]!,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          location['time'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800],
                                            fontSize: 14,
                                          ),
                                        ),
                                        if (isFirst)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                              BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              'Start',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        else if (isLast)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                              BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              'End',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            location['address'],
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Lat: ${location['lat']}, Long: ${location['long']}',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}