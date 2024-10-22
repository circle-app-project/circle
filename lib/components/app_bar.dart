import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget {
  final String pageTitle;
  final List<Widget>? actions;
  final bool? showTitle;
  final bool? showBackButton;

  const CustomAppBar(
      {super.key,
      required this.pageTitle,
      this.actions,
      this.showBackButton = true,
      this.showTitle = true});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Gap(48),
        Row(
          children: [
            Visibility(
              visible: showBackButton!,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Feedback.forTap(context);
                  context.pop();
                },
                icon:Icon(FluentIcons.arrow_left_24_regular),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Visibility(
                visible: actions != null ? true : false,
                child: Row(
                  children: actions ?? [],
                ),
              ),
            )
          ],
        ),
        Visibility(
          visible: showTitle!,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(pageTitle,
                style: theme.textTheme.headlineMedium),
          ),
        ),
        const Gap(48),
      ],
    );
  }
}
