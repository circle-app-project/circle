import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../../components/app_button.dart';
import '../../../../core/core.dart';

class CustomDoseDialog extends StatefulWidget {
  const CustomDoseDialog({super.key});

  @override
  State<CustomDoseDialog> createState() => _CustomDoseDialogState();
}

class _CustomDoseDialogState extends State<CustomDoseDialog> {
  TextEditingController textController = TextEditingController();
  List<String> dropdownMenuItems = ["mg", "ml"]; //Add other units
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String? doseUnit;

  @override
  void initState() {
    doseUnit = dropdownMenuItems.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      surfaceTintColor: Colors.transparent,
      backgroundColor: theme.scaffoldBackgroundColor,
      titlePadding: const EdgeInsets.only(top: 16, left: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kPadding24),
      ),
      title: Text("Custom Dose", style: theme.textTheme.titleMedium),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Dose"),
            const Gap(kPadding12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: textController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: AppInputDecoration.inputDecoration(
                      context,
                    ).copyWith(hintText: "e.g 500 mg"),
                  ),
                ),
                const Gap(kPadding12),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 48,
                    child: DropdownMenu(
                      //  menuHeight: 40,
                      menuStyle: MenuStyle(
                        padding:
                            const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                              EdgeInsets.zero,
                            ),
                        //     surfaceTintColor: WidgetStatePropertyAll<Color>(Colors.red),
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          theme.colorScheme.surface,
                        ),
                        elevation: const WidgetStatePropertyAll<double>(20),
                        shape: WidgetStatePropertyAll<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kPadding16),
                          ),
                        ),
                      ),
                      inputDecorationTheme:
                          AppInputDecoration.inputDecorationTheme(context),
                      initialSelection: doseUnit,
                      onSelected: (value) {
                        setState(() {
                          doseUnit = value;
                        });
                      },
                      trailingIcon: const Icon(
                        FluentIcons.chevron_down_24_regular,
                      ),
                      selectedTrailingIcon: const Icon(
                        FluentIcons.chevron_up_24_regular,
                      ),
                      dropdownMenuEntries:
                          dropdownMenuItems
                              .map<DropdownMenuEntry<String>>(
                                (element) => DropdownMenuEntry<String>(
                                  value: element,
                                  label: element,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        FittedBox(
          child: AppButton(
            isChipButton: true,
            onPressed: () {
              Navigator.pop(context);
            },
            label: "Cancel",
            color: theme.iconTheme.color,
            buttonType: ButtonType.outline,
          ),
        ),
        FittedBox(
          child: AppButton(
            isChipButton: true,
            onPressed: () {
              Navigator.pop(context, "${textController.text.trim()} $doseUnit");
            },
            label: "Done",
            //buttonType: AppButtonType.text,
          ),
        ),
      ],
    );
  }
}
