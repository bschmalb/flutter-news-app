import 'package:flutter/material.dart';
import 'package:ksta/pages/home/controllers/homepage_controller.dart';
import 'package:ksta/pages/home/widgets/home_block_section.dart';
import 'package:ksta/utils/app_breakpoint.dart';
import 'package:ksta/widgets/ksta_sliver_app_bar.dart';

class HomepageList extends StatelessWidget {
  const HomepageList({
    required this.controller,
    required this.pageTitle,
    super.key,
  });

  final HomepageController controller;
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    final breakpoint = context.breakpoint;
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
            padding: EdgeInsets.all(breakpoint.horizontalPadding),
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
          KstaSliverAppBar(title: pageTitle),
          bodySliver,
        ],
      ),
    );
  }
}
