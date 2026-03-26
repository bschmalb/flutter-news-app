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
    final breakpoint = context.breakpoint;
    final listPadding = switch (breakpoint) {
      AppBreakpoint.compact => EdgeInsets.symmetric(
        vertical: breakpoint.horizontalPadding,
      ),
      _ => EdgeInsets.all(breakpoint.horizontalPadding),
    };
    late final Widget bodySliver;

    if (controller.isLoading && !controller.hasContent) {
      bodySliver = const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    } else if (controller.errorMessage != null && !controller.hasContent) {
      bodySliver = SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const .all(24),
            child: Column(
              mainAxisSize: .min,
              spacing: 16,
              children: [
                Text(
                  'Failed to load homepage:\n${controller.errorMessage}',
                  textAlign: .center,
                ),
                FilledButton(
                  onPressed: controller.reload,
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      bodySliver = SliverPadding(
        padding: listPadding,
        sliver: SliverList.separated(
          itemCount: controller.blockControllers.length,
          separatorBuilder: (context, index) => SizedBox(height: breakpoint.sectionSpacing),
          itemBuilder: (context, index) {
            final blockController = controller.blockControllers[index];

            return Align(
              alignment: .topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: breakpoint.maxContentWidth,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: HomepageBlockSection(
                    key: ObjectKey(blockController),
                    controller: blockController,
                    trimTopPadding: index == 0,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.reload,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Header
          const KstaSliverAppBar(
            floating: true,
            snap: true,
          ),

          // Blocks
          bodySliver,
        ],
      ),
    );
  }
}
