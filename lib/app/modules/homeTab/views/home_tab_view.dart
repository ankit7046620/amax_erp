import 'package:amax_hr/app/modules/navBar/controllers/nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../controllers/home_tab_controller.dart';

class HomeTabView extends StatelessWidget {
  HomeTabView({super.key});



  final HomeTabController controller = Get.put(HomeTabController());

  @override
  Widget build(BuildContext context) {
    Get.put(HomeTabController());
    return GetBuilder<HomeTabController>(
      init: HomeTabController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          body: controller.isLoading.value
              ? _buildShimmerLoading()
              : _buildModuleContent(context, controller),
        );
      },
    );
  }

  Widget _buildModuleContent(
    BuildContext context,
    HomeTabController controller,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.popularModules.isNotEmpty) ...[
            _gridSection(
              context: context,
              title: "Popular Modules",
              items: controller.popularModules,
              colors: controller.popularColor,
              onTap: controller.handleModuleOnTap,
            ),
          ],
          const SizedBox(height: 28),
          if (controller.otherModules.isNotEmpty) ...[
            _gridSection(
              context: context,
              title: "Other Modules",
              items: controller.otherModules,
              colors: controller.popularColor,
              onTap: controller.handleModuleOnTap,
            ),
          ],
        ],
      ),
    );
  }

  Widget _gridSection({
    required BuildContext context,
    required String title,
    required List<ModuleItem> items,
    required List<Color> colors,
    required Function(String) onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            final color = colors[index % colors.length];
            return GestureDetector(
              onTap: () => onTap(item.name),
              child: _moduleCard(item.name, item.icon, color),
            );
          },
        ),
      ],
    );
  }

  Widget _moduleCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            radius: 22,
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            capitalizeFirstOnly(title),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String capitalizeFirstOnly(String text) =>
      text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : '';

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          _shimmerGrid(title: "Popular Modules"),
          const SizedBox(height: 32),

          _shimmerGrid(title: "Other Modules"),
        ],
      ),
    );
  }

  Widget _shimmerGrid({required String title}) {
    const crossAxisCount = 3;
    const itemCount = crossAxisCount * 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 22,
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade300,
          ),
          margin: const EdgeInsets.only(bottom: 16),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (context, index) {
            return Shimmer(
              duration: const Duration(seconds: 2),
              color: Colors.grey.shade300,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 12,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
