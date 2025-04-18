import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../components/components.dart';
import '../../../../../core/core.dart';

class EmergencyAlertDisclaimerDialog extends StatelessWidget {
  const EmergencyAlertDisclaimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.colorScheme.brightness == Brightness.dark;

    ///TODO: Wrap with BackButton Listener
    return AppAlertDialog(
      title: "Emergency Alert",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Emergency Alert would share the following information with your emergency contacts",
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const Gap(32),
          const Align(
            alignment: Alignment.centerLeft,
            child: AlertDetailsText(
              iconData: FluentIcons.location_24_regular,
              label: "Your Location",
            ),
          ),
          const Gap(8),
          const Align(
            alignment: Alignment.centerLeft,
            child: AlertDetailsText(
              iconData: FluentIcons.apps_list_detail_24_regular,
              label: "Details about your crises",
            ),
          ),
          const Gap(32),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      "Status updates and location would be shared with emergency contacts for",
                  style: theme.textTheme.bodySmall!
                      .copyWith(color: AppColours.neutral50),
                ),
                TextSpan(
                  text: " 6 hours, ",
                  style: theme.textTheme.bodySmall!.copyWith(
                      color: isDarkMode
                          ? AppColours.red70
                          : theme.colorScheme.error),
                ),
                TextSpan(
                  text: "or until you stop sharing.",
                  style: theme.textTheme.bodySmall!
                      .copyWith(color: AppColours.neutral50),
                ),
              ],
            ),
          ),
          const Gap(16),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: AppButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: "Cancel",
                  buttonType: ButtonType.outline,
                  color: theme.colorScheme.error,
                  icon: FluentIcons.dismiss_24_regular,
                ),
              ),
              const Gap(8),
              Expanded(
                child: AppButton(
                  onPressed: () {},
                  label: "Continue",
                  buttonType: ButtonType.primary,
                  color: AppColours.white,
                  backgroundColor: theme.colorScheme.error,
                  //   iconPath: "assets/svg/emergency-alt.svg",
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class AlertDetailsText extends StatelessWidget {
  final IconData iconData;
  final String label;
  const AlertDetailsText(
      {super.key, required this.label, required this.iconData});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDarkMode
                ? theme.colorScheme.errorContainer
                : AppColours.red95,
          ),
          child: Icon(
            iconData,
            color: theme.colorScheme.error,
          ),
        ),
        const Gap(16),
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
