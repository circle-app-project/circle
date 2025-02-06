import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../../components/app_button.dart';
import '../../../../components/bottom_sheet.dart';
import '../../../../core/core.dart';

class CustomFrequencyDialog extends StatefulWidget {
  const CustomFrequencyDialog({super.key});

  @override
  State<CustomFrequencyDialog> createState() => _CustomFrequencyDialogState();
}

class _CustomFrequencyDialogState extends State<CustomFrequencyDialog> {
  List<String> dropdownMenuItems = ["Day", "Week", "Month", "Year"];

  TextEditingController numberController = TextEditingController();

  String? timePeriod;
  String customFrequency = "";
  List<String> repeatDays = [];
  int repeatNumber = 1;

  @override
  void initState() {
    timePeriod = dropdownMenuItems.first;
    super.initState();
  }

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
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
        borderRadius: BorderRadius.circular(kPadding32),
      ),
      title: Text(
        "Custom Frequency",
        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w800),
      ),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Repeats Every"),
            const Gap(kPadding16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: numberController,
                    decoration: AppInputDecoration.inputDecoration(
                      context,
                    ).copyWith(hintText: "e.g 2"),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const Gap(kPadding16),
                Expanded(
                  flex: 2,
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
                      initialSelection: timePeriod,
                      onSelected: (value) {
                        setState(() {
                          timePeriod = value;
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
            const Gap(kPadding16),
            if (timePeriod == dropdownMenuItems[1])
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Repeats On"),
                  Gap(kPadding8),
                  //Todo: reimplement this calendar weekday selector using the new [SelectableWidget] API
                  // CalendarWeekDaySelector(
                  //     selectedDays: (List<String> selectedDays) {
                  //   setState(() {
                  //     repeatDays = selectedDays;
                  //   });
                  // }),
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
              //
              // print(generateFrequencyDescription(
              //     repeatNumber, timePeriod!, repeatDays));
              Navigator.pop(
                context,
                generateFrequencyDescription(
                  repeatNumber,
                  timePeriod!,
                  repeatDays,
                ),
              );
            },
            label: "Done",
          ),
        ),
      ],
    );
  }
}

class FrequencyBottomSheet extends StatefulWidget {
  const FrequencyBottomSheet({super.key});

  @override
  State<FrequencyBottomSheet> createState() => _FrequencyBottomSheetState();
}

class _FrequencyBottomSheetState extends State<FrequencyBottomSheet> {
  List<String> dropdownMenuItems = ["Day", "Week", "Month", "Year"];

  TextEditingController numberController = TextEditingController();

  String? timePeriod;
  String customFrequency = "";
  List<String> repeatDays = [];
  int repeatNumber = 1;

  @override
  void initState() {
    timePeriod = dropdownMenuItems.first;
    super.initState();
  }

  TextEditingController textController = TextEditingController();

  Duration? selectedDuration;
  Map<int, String> dropDownMenuItems = {
    1: "Day(s)",
    7: "Week(s)",
    30: "Month(s)",
  };

  int dayMultiplier = 1;
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBottomSheet(
      showLip: false,
      title: "Select Duration",
      onPressed: () {
        selectedDuration = Duration(
          days: int.tryParse(textController.text.trim())! * dayMultiplier,
        );
        Navigator.pop(context, selectedDuration);
      },
      buttonLabel: "Save",

      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Repeats Every"),
            const Gap(kPadding16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: numberController,
                    decoration: AppInputDecoration.inputDecoration(
                      context,
                    ).copyWith(hintText: "e.g 2"),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const Gap(kPadding16),
                Expanded(
                  flex: 2,
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
                      initialSelection: timePeriod,
                      onSelected: (value) {
                        setState(() {
                          timePeriod = value;
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
            const Gap(kPadding16),
            if (timePeriod == dropdownMenuItems[1])
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Repeats On"),
                  Gap(kPadding8),
                  //Todo: reimplement this calendar weekday selector using the new [SelectableWidget] API
                  // CalendarWeekDaySelector(
                  //     selectedDays: (List<String> selectedDays) {
                  //   setState(() {
                  //     repeatDays = selectedDays;
                  //   });
                  // }),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

String generateFrequencyDescription(
  int? repeatNumber,
  String? timePeriod,
  List<String>? selectedDays,
) {
  // Handle null or empty inputs
  if (repeatNumber == null ||
      timePeriod == null ||
      timePeriod.isEmpty ||
      selectedDays == null) {
    return "Frequency not set";
  }

  // Capitalize the first letter of timePeriod
  String capitalizedTimePeriod =
      timePeriod[0].toUpperCase() + timePeriod.substring(1);

  // Handle plural form of timePeriod
  if (repeatNumber != 1) {
    capitalizedTimePeriod += 's';
  }

  // Create the base sentence
  String sentence = "Repeats every $repeatNumber $capitalizedTimePeriod";

  // Add day information if any days are selected
  if (selectedDays.isNotEmpty) {
    if (selectedDays.length == 7) {
      sentence += " every day";
    } else if (selectedDays.length == 5 &&
        selectedDays.contains('M') &&
        selectedDays.contains('T') &&
        selectedDays.contains('W') &&
        selectedDays.contains('T') &&
        selectedDays.contains('F')) {
      sentence += " on weekdays";
    } else {
      String daysList = selectedDays.join(', ');
      if (daysList.contains(',')) {
        final int lastCommaIndex = daysList.lastIndexOf(',');
        daysList = daysList.replaceRange(
          lastCommaIndex,
          lastCommaIndex + 1,
          ' and',
        );
      }
      sentence += " on $daysList";
    }
  }

  return sentence;
}
