// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/user_list_controller.dart';
// import 'user_map_view.dart';
//
// class UserListView extends GetView<UserListController> {
//   const UserListView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Get.put(UserListController());
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User List'),
//         centerTitle: true,
//         elevation: 2,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.map),
//             tooltip: 'View Map',
//             onPressed: () {
//               Get.to(() => const UserMapView());
//             },
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//
//         if (controller.users.isEmpty) {
//           return const Center(
//             child: Text('No users found'),
//           );
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(8),
//           itemCount: controller.users.length,
//           itemBuilder: (context, index) {
//             final user = controller.users[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//               elevation: 2,
//               child: ListTile(
//                 contentPadding: const EdgeInsets.all(12),
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.primaries[index % Colors.primaries.length],
//                   child: Text(
//                     user['username'][0].toUpperCase(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 title: Text(
//                   user['username'],
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 4),
//                     Text(
//                       user['email'],
//                       style: TextStyle(
//                         color: Colors.grey[700],
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             user['location'],
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 13,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       'Lat: ${user['lat']}, Long: ${user['long']}',
//                       style: TextStyle(
//                         color: Colors.grey[500],
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 trailing: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 16,
//                   color: Colors.grey[400],
//                 ),
//                 onTap: () {
//                   controller.showUserDetails(user);
//                 },
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_list_controller.dart';
import 'user_map_view.dart';
import 'user_detail_location_view.dart';

class UserListView extends GetView<UserListController> {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserListController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            tooltip: 'View Map',
            onPressed: () {
              Get.to(() => const UserMapView());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.users.isEmpty) {
          return const Center(
            child: Text('No users found'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              elevation: 2,
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  backgroundColor: Colors.primaries[index % Colors.primaries.length],
                  child: Text(
                    user['username'][0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  user['username'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      user['email'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user['location'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Lat: ${user['lat']}, Long: ${user['long']}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
                onTap: () {
                  // Navigate to detailed location view with travel history
                  Get.to(
                        () => UserDetailLocationView(user: user),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}