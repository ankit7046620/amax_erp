import 'package:amax_hr/common/component/common_elevated_button.dart';
import 'package:amax_hr/common/component/custom_image_widget.dart';
import 'package:amax_hr/constant/assets_constant.dart';
import 'package:amax_hr/manager/auth_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F3),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Login Card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          /// Logo
                          CustomImageWidget(
                            imagePath: AssetsConstant.tech_logo,
                            fit: BoxFit.contain,
                            height: 80,
                            width: 160,
                            alignment: Alignment.center,
                          ),
                          const SizedBox(height: 24),

                          /// Email Field
                          TextField(
                            controller: controller.emailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              labelText: 'Email or Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// Password Field
                          Obx(
                            () => TextField(
                              controller: controller.passwordController,
                              obscureText: controller.obscurePassword.value,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock),
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.obscurePassword.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    controller.obscurePassword.value =
                                        !controller.obscurePassword.value;
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          /// Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                controller.loginLocal();
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// Biometric Auth

                          IconButton(
                            onPressed: () async {
                              controller.biometricLogin();
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.fingerprint,
                              size: 40,
                              color: Colors.deepOrange,
                            ),
                            tooltip: 'Login with Face/Fingerprint',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),

            /// Industry image bottom
            if (!isKeyboardOpen)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CustomImageWidget(
                  imagePath: AssetsConstant.inudstry,
                  fit: BoxFit.cover,
                  height: 100,
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
