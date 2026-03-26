import 'package:flutter/material.dart';
import 'package:ksta/pages/home/controllers/homepage_controller.dart';
import 'package:ksta/pages/home/widgets/home_block_section.dart';
import 'package:ksta/utils/app_breakpoint.dart';
import 'package:ksta/widgets/ksta_sliver_app_bar.dart';

class HomepageList extends StatelessWidget {
  const HomepageList({
    required this.controller,
    super.key,
  });

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
    final bodySliver = controller.isLoading && !controller.hasContent
        ? const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          )
        : controller.errorMessage != null && !controller.hasContent
        ? SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Failed to load homepage:\n${controller.errorMessage}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: controller.reload,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
          )
        : SliverPadding(
            padding: listPadding,
            sliver: SliverList.separated(
              itemCount: controller.blockControllers.length,
              separatorBuilder: (context, index) => SizedBox(height: breakpoint.sectionSpacing),
              itemBuilder: (context, index) {
                final blockController = controller.blockControllers[index];

                return Align(
                  alignment: Alignment.topCenter,
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

    return RefreshIndicator(
      onRefresh: controller.reload,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const KstaSliverAppBar(
            floating: true,
            snap: true,
          ),
          bodySliver,
        ],
      ),
    );
  }
}
