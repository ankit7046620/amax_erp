import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../controllers/home_tab_controller.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeTabController>(
      init: HomeTabController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          body: controller.isLoading.value
              ? _buildShimmerLoading()
              : _buildModuleContent(context, controller),
        );
      },
    );
  }

  Widget _buildModuleContent(BuildContext context, HomeTabController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _gridSection(
            context: context,
            title: "Popular Modules",
            items: controller.popularModules,
            colors: controller.popularColor,
            onTap: controller.handleModuleOnTap,
          ),
          const SizedBox(height: 32),
          _gridSection(
            context: context,

            title: "Other Modules",
            items: controller.otherModules,
            colors: controller.popularColor,
            onTap: controller.handleModuleOnTap,
          ),
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
        Text(title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            )),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.95,
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
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      shadowColor: Colors.black12,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 10),
            Text(
              capitalizeFirstOnly(title),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String capitalizeFirstOnly(String text) =>
      text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : '';

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.all(16),
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
          height: 20,
          width: 140,
          color: Colors.grey.shade300,
          margin: const EdgeInsets.only(bottom: 12),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.95,
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
                      radius: 18,
                      backgroundColor: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 12,
                      width: 90,
                      color: Colors.grey.shade300,
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
