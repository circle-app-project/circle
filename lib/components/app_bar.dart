import 'package:auto_route/auto_route.dart';
import 'package:circle/core/core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';


class CustomAppBar extends StatelessWidget {
  final String pageTitle;
  final List<Widget>? actions;
  final bool? showTitle;
  final bool? showBackButton;

  const CustomAppBar({
    super.key,
    required this.pageTitle,
    this.actions,
    this.showBackButton = true,
    this.showTitle = true,
  });

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
            if (showBackButton!)
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Feedback.forTap(context);
                  context.router.back();
                },
                icon: const Icon(FluentIcons.arrow_left_24_regular),
              ),
            const Spacer(),
            Visibility(
              visible: actions != null ? true : false,
              child: Row(children: actions ?? []),
            ),
          ],
        ),
        const Gap(kPadding32),
        if (showTitle!)
          Text(
            pageTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),

        const Gap(32),
      ],
    );
  }
}
