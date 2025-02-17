import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/constants.dart';
import '../../../components/app_button.dart';

class CupertinoDatePickerCustomized extends StatelessWidget {
  const CupertinoDatePickerCustomized({
    super.key,
    required this.onDateTimeChanged,
    this.mode = CupertinoDatePickerMode.time,
    this.label = "Select Time",
  });

  final Function(DateTime value) onDateTimeChanged;
  final CupertinoDatePickerMode mode;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kPadding16),
        color: theme.colorScheme.surface,
      ),
      height: MediaQuery.sizeOf(context).height * .6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(kPadding12),
            Row(
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleMedium!.copyWith(
                    // fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(FluentIcons.dismiss_20_regular),
                ),
              ],
            ),

            Align(
              alignment: Alignment.center,
              child: Container(
                width: kPadding32,
                height: kPadding8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kPadding12),
                  color: theme.colorScheme.surfaceContainer,
                ),
              ),
            ),

            SizedBox(
              height: MediaQuery.sizeOf(context).height * .4,
              child: Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: DateTime.now(),
                  mode: mode,
                  onDateTimeChanged: onDateTimeChanged,
                ),
              ),
            ),
            const Gap(kPadding8),
            AppButton(
              onPressed: () {
                Navigator.pop(context);
              },
              label: "Select Date",
            ),
            const Gap(kPadding64),
          ],
        ),
      ),
    );
  }
}
