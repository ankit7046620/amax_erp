import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xFF3A7BD5); // Deep Blue
const Color secondaryColor = Color(0xFF00D2FF); // Aqua
const Color accentColor = Color(0xFFFA7268); // Coral
const Color background = Color(0xFFF5F7FA); // Light Grey
const Color cardBackground = Colors.white;
const Color textDark = Color(0xFF222222);
const Color textLight = Colors.grey;

class ProfileController extends GetxController {
  String name = "Ankit Patel";
  String email = "ankit.patel@techclouderp.com";

  void confirmLogout() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage("https://i.pravatar.cc/300?img=15"),
              ),
              const SizedBox(height: 20),
              const Text(
                "Are you sure you want to logout?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.snackbar("Logged out", "You have been logged out.",
                          backgroundColor: accentColor, colorText: Colors.white);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                    ),
                    child: const Text("Logout"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: background,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage("https://i.pravatar.cc/300?img=15"),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: textLight,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Action Tiles
                _tile(icon: Icons.person_outline, label: "Edit Profile", onTap: () {}),
                _tile(icon: Icons.lock_outline, label: "Change Password", onTap: () {}),
                _tile(icon: Icons.settings_outlined, label: "Settings", onTap: () {}),
                _tile(
                  icon: Icons.logout,
                  label: "Logout",
                  onTap: controller.confirmLogout,
                  iconColor: accentColor,
                  textColor: accentColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _tile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = primaryColor,
    Color textColor = textDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        leading: Icon(icon, color: iconColor),
        title: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}
