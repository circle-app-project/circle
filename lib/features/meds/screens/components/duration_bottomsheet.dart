import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../components/bottom_sheet.dart';
import '../../../../core/theme/constants.dart';

class DurationBottomSheet extends StatefulWidget {
  const DurationBottomSheet({super.key});

  @override
  State<DurationBottomSheet> createState() => _DurationBottomSheetState();
}

class _DurationBottomSheetState extends State<DurationBottomSheet> {
  TextEditingController textController = TextEditingController();

  Duration? selectedDuration;
  Map<int, String> dropDownMenuItems = {1: "Day(s)", 7: "Week(s)", 30: "Month(s)"};

  int dayMultiplier = 1;
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBottomSheet(
      showLip: false,
      title: "Select Duration",
      onPressed: () {
        selectedDuration = Duration(
          days:
          int.tryParse(textController.text.trim())! *
              dayMultiplier,
        );
        Navigator.pop(context, selectedDuration);
      },
      buttonLabel: "Save",

      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: kPadding16,
        children: [
          Row(
            spacing: 2,
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: textController,
                  decoration: AppInputDecoration.inputDecoration(
                    context,
                  ).copyWith(
                    hintText: "e.g 12 Days",
                    errorBorder: OutlineInputBorder(
                      gapPadding: 4,
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    border: const OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    disabledBorder: const OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: BorderSide(
                        width: 1,
                        color: AppColours.purple60,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 48,
                  child: DropdownMenu(

                    //  menuHeight: 40,
                    menuStyle: MenuStyle(
                      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                        EdgeInsets.zero,
                      ),
                      //     surfaceTintColor: WidgetStatePropertyAll<Color>(Colors.red),
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        theme.colorScheme.surface,
                      ),
                      elevation: const WidgetStatePropertyAll<double>(20),
                      shape: WidgetStatePropertyAll<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kPadding12),
                        ),
                      ),
                    ),
                    inputDecorationTheme:
                        AppInputDecoration.inputDecorationTheme(
                          context,
                        ).copyWith(
                          errorBorder: OutlineInputBorder(
                            gapPadding: 4,
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            gapPadding: 0,
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            gapPadding: 0,
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            gapPadding: 0,
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            gapPadding: 0,
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColours.purple60,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                        ),
                    initialSelection: dropDownMenuItems.keys.first,
                    onSelected: (selectedDayMultiplier) {
                      setState(() {
                      dayMultiplier = selectedDayMultiplier ?? 1;

                      });
                    },
                    trailingIcon: const Icon(
                      FluentIcons.chevron_down_24_regular,
                    ),
                    selectedTrailingIcon: const Icon(
                      FluentIcons.chevron_up_24_regular,
                    ),
                    dropdownMenuEntries:
                        dropDownMenuItems.entries
                            .map<DropdownMenuEntry>(
                              (element) => DropdownMenuEntry<int>(
                                value: element.key,
                                label: element.value,
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
    );
  }
}
