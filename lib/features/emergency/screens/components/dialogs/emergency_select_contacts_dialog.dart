import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../components/components.dart';
import '../../../../../core/core.dart';

class EmergencySelectContactsDialog extends StatelessWidget {
  const EmergencySelectContactsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppAlertDialog(
      title: "Select Contacts",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.errorContainer,
            ),
          ),
          const Gap(16),
          AppButton(
            onPressed: () {},
            label: "Send to all contacts",
            buttonType: ButtonType.primary,
            color: AppColours.white,
            backgroundColor: theme.colorScheme.error,
            iconPath: "assets/svg/emergency-alt.svg",
          ),
          const Gap(12),
          AppButton(
            onPressed: () {},
            label: "Select Contacts",
            buttonType: ButtonType.outline,
            color: theme.colorScheme.error,
          ),
        ],
      ),
    );
  }
}
