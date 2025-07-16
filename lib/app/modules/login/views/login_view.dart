import 'package:amax_hr/common/component/common_elevated_button.dart';
import 'package:amax_hr/common/component/custom_image_widget.dart';
import 'package:amax_hr/common/component/custom_text_field.dart';
import 'package:amax_hr/constant/assets_constant.dart';
import 'package:amax_hr/constant/localel.dart';
import 'package:amax_hr/core/app_color.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
       LoginView({super.key});


LoginController _loginController=Get.put(LoginController());


  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
              MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  48, // Subtract padding
            ),
            child: IntrinsicHeight(
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
[
                    SizedBox(height: SizeType.xxxs),

                    _buildHeader(),
                    SizedBox(height: SizeType.xxxs),
                    _buildEmailField(),
                    SizedBox(height: SizeType.xxxs),
                    _buildPasswordField(),
                    SizedBox(height: SizeType.xxxxxs),
                    _buildLoginButton(),

                    SizedBox(height: SizeType.xxxxxxs),
                    _buildForgotPassword(),

                    // Add bottom spacing to push content up
                    SizedBox(height: SizeType.xxxxxs),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        CustomImageWidget(
          fit: BoxFit.contain,
          imagePath: AssetsConstant.logo,
          height: 120,
          // Increased logo size for full screen
          width: double.infinity,
          alignment: Alignment.center,
        ),
        SizedBox(height: SizeType.xxxxxxs),
        Text(
          LabelConstants.welcome,
          style: GoogleFonts.poppins(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
          ),
        ),
        SizedBox(height: SizeType.xxxxxxxxxxxs),
        Text(
            LabelConstants.signIn,
            style:  GoogleFonts.poppins(
              fontSize: 18.sp,

              color: AppColor.secondary,
            )
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: controller.emailController,
      labelText: 'Email',
      hintText: 'Enter your email',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: controller.validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return Obx(
          () => CustomTextField(
        controller: controller.passwordController,
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: Icons.lock_outline,
        obscureText: !controller.isPasswordVisible.value,
        suffixIcon: IconButton(
          icon: Icon(
            controller.isPasswordVisible.value
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: controller.togglePasswordVisibility,
        ),
        validator: controller.validatePassword,
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(
          () => CommonElevatedButton(
        text: 'Login',
        width: double.infinity,
        isLoading: controller.isLoading.value,
        onPressed:  controller.login,
        child: SizedBox(),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: controller.forgotPassword,

      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: Color(0xFF163049), // Changed to white70 for better contrast
          fontSize: 16,
        ),
      ),
    );
  }
}
