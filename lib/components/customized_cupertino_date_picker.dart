
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/constants.dart';
import '../../../components/app_button.dart';

class CupertinoDatePickerCustomized extends StatelessWidget {
  const CupertinoDatePickerCustomized({
    super.key,
    required this.onDateTimeChanged,
  });

  final Function(DateTime value) onDateTimeChanged;

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
        padding: EdgeInsets.symmetric(horizontal: kPadding16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(kPadding12),
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
            Gap(kPadding12),
            Text("Select Date", style: theme.textTheme.titleMedium),
            //  Gap(kPadding16),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: onDateTimeChanged,
              ),
            ),
            Gap(kPadding8),
            AppButton(
              onPressed: () {
                Navigator.pop(context);
              },
              label: "Select Date",
            ),
            Gap(kPadding64),
          ],
        ),
      ),
    );
  }
}
