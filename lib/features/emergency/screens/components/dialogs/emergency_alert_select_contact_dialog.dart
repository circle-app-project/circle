import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:circle/core/core.dart';

import '../../../../../components/components.dart';
import '../components.dart';

class EmergencyAlertSelectContactDialog extends StatelessWidget {
  const EmergencyAlertSelectContactDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    //  final bool isDarkMode = theme.colorScheme.brightness == Brightness.dark;

    ///TODO: Wrap with BackButton Listener
    return AppAlertDialog(
      title: "Emergency Alert",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "This would alert the chosen contacts of your emergency",
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const Gap(32),
          const EmergencyContactRadio(
              number: "6 77 77 77 77",
              isSelected: false,
              name: "Amelia Robertson",
              imagePath: "assets/images/memoji.png"),
          const Gap(8),
          const EmergencyContactRadio(
              number: "6 77 77 77 77",
              isSelected: true,
              name: "Amelia Robertson",
              imagePath: "assets/images/memoji.png"),
          const Gap(16),
          AppButton(
            onPressed: () {},
            label: "Send Alert",
            buttonType: ButtonType.primary,
            color: AppColours.white,
            backgroundColor: theme.colorScheme.error,
            iconPath: "assets/svg/emergency-alt.svg",
          ),
        ],
      ),
    );
  }
}
