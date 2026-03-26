import 'package:flutter/material.dart';
import 'package:ksta/pages/home/controllers/homepage_controller.dart';
import 'package:ksta/pages/home/widgets/home_block_section.dart';
import 'package:ksta/utils/app_breakpoint.dart';
import 'package:ksta/widgets/ksta_sliver_app_bar.dart';

class HomepageList extends StatelessWidget {
  const HomepageList({super.key, required this.controller});

  final HomepageController controller;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: controller.reload,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const KstaSliverAppBar(floating: true, snap: true),

          // Blocks
          if (controller.isLoading && !controller.hasContent)
            const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator.adaptive()))
          else if (controller.errorMessage != null && !controller.hasContent)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const .all(24),
                  child: Column(
                    mainAxisSize: .min,
                    spacing: 16,
                    children: [
                      Text('Failed to load homepage:\n${controller.errorMessage}', textAlign: .center),
                      FilledButton(onPressed: controller.reload, child: const Text('Try again')),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverList.separated(
              itemCount: controller.blockControllers.length,
              separatorBuilder: (context, index) => SizedBox(height: context.breakpoint.sectionSpacing),
              itemBuilder: (context, index) {
                final blockController = controller.blockControllers[index];

                return Align(
                  alignment: .topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: context.breakpoint.maxContentWidth),
                    child: SizedBox(
                      width: double.infinity,
                      child: HomepageBlockSection(key: ObjectKey(blockController), controller: blockController),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
