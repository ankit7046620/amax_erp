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
          body: controller.isLoading.value
              ? _buildShimmerLoading(context)
              : _buildModuleContent(context, controller),
        );
      },
    );
  }

  Widget _buildModuleContent(BuildContext context, HomeTabController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 24),
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
    const crossAxisCount = 3;
    final cardCount = items.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cardCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.0,
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
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
              radius: 18,
            ),
            const SizedBox(height: 12),
            Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
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

  Widget _buildShimmerLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _shimmerGrid(title: "Popular Modules"),
          const SizedBox(height: 24),
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
        Shimmer(
          duration: const Duration(seconds: 2),
          interval: const Duration(milliseconds: 100),
          child: Container(
            height: 18,
            width: 120,
            color: Colors.grey.shade300,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            return Shimmer(
              duration: const Duration(seconds: 2),
              color: Colors.grey.shade300,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      radius: 18,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 12,
                      width: 100,
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
