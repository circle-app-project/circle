import 'dart:developer';
import 'dart:io';

import 'package:circle/core/extensions/date_time_formatter.dart';
import 'package:circle/features/meds/models/dose.dart';
import 'package:circle/features/meds/screens/components/dose_bottomsheet.dart';
import 'package:circle/features/meds/screens/components/duration_bottomsheet.dart';
import 'package:circle/features/meds/screens/components/emphasized_container.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sprung/sprung.dart';
import '../../../components/components.dart';
import '../../../components/customized_cupertino_date_picker.dart';
import '../../../core/core.dart';
import '../meds.dart';
import '../models/frequency.dart';
import '../models/medication.dart';
import '../providers/med_notifier.dart';

///Todo: Animate things on and off the screen more elegantly
class AddMedsScreen extends ConsumerStatefulWidget {
  static const String id = "add_meds";
  final bool isEditing;
  const AddMedsScreen({super.key, this.isEditing = false});

  @override
  ConsumerState<AddMedsScreen> createState() => _AddMedsScreenState();
}

class _AddMedsScreenState extends ConsumerState<AddMedsScreen> {
  /// Fields to be created by the medication
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController warningMessageController =
      TextEditingController();
  final TextEditingController reminderMessageController =
      TextEditingController();

  List<int> defaultDoseValues = [5, 10, 50, 100, 250, 500, 1000, 0];
  List<Dose> defaultDoses = [];
  List<int> defaultDurationValues = [3, 7, 14, 21, 30, 60, 90, 0];
  List<TimeOfDay> selectedTimeToTakeMedication = [];

  /// Fields to be created by the medication
  bool isTakingMedsPermanently = false;
  bool shouldRemind = true;
  MedicationType selectedMedicationType = MedicationType.tabletsPills;
  Dose? selectedDose;
  Frequency selectedFrequency = Frequency.empty;
  DateTime? selectedStartDate = DateTime.now();
  Duration? selectedDuration;
  bool showSelectedDuration = false;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    warningMessageController.dispose();
    startDateController.dispose();
    reminderMessageController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    startDateController.text = selectedStartDate!.formatDate(context);

    defaultDoses = List.generate(
      defaultDoseValues.length,
      (index) => Dose(
        dose: defaultDoseValues[index].toDouble(),
        unit: Units.milligram,
      ),
    );
    super.initState();
  }

  void _selectDuration() async {
    selectedDuration = await showModalBottomSheet(
      sheetAnimationStyle: AnimationStyle(
        curve: Sprung.overDamped,
        duration: 300.ms,
        reverseCurve: Sprung.overDamped,
      ),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const DurationBottomSheet();
      },
    );

    /// Add the selected duration to the default duration values
    /// to visually show the user
    defaultDurationValues.insert(
      defaultDurationValues.length - 1,
      selectedDuration!.inDays,
    );

    showSelectedDuration = true;

    log(
      "Selected medication duration is ${selectedDuration!.inDays} days",
      name: "Add Medication Screen",
    );

    setState(() {});
  }

  void _selectDoses() async {
    selectedDose = await showModalBottomSheet(
      sheetAnimationStyle: AnimationStyle(
        curve: Sprung.overDamped,
        duration: 300.ms,
        reverseCurve: Sprung.overDamped,
      ),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const DoseBottomSheet();
      },
    );

    if (selectedDose != null) {
      /// Add the selected duration to the default duration values
      /// to visually show the user
      defaultDoses.insert(defaultDoseValues.length - 1, selectedDose!);
    }

    log("Selected Dose is : ${selectedDose!.dose} ${selectedDose!.unit.name}");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomAppBar(
                pageTitle:
                    widget.isEditing ? "Edit\nMedication" : "Add\nMedication",
                actions: [
                  AppButton(
                    isChipButton: true,
                    onPressed: () {
                      //Todo: Skip Page
                    },
                    label: "Skip",
                    buttonType: ButtonType.text,
                  ),
                ],
              ),

              const Gap(kPadding16),
              Row(
                children: [
                  const AppIcon(
                    icon: HugeIcons.strokeRoundedFile01,
                  ), const Gap(kPadding8),
                  Text("General Information", style: theme.textTheme.titleMedium),
                ],
              ),
              const Gap(kPadding16),
              Text("Name", style: theme.textTheme.bodyMedium),
              const Gap(kPadding12),
              TextFormField(
                controller: nameController,
                decoration: AppInputDecoration.inputDecoration(
                  context,
                ).copyWith(hintText: "Hydroxyl Urea"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please provide a medication name";
                  } else {
                    return null;
                  }
                },
              ),
              const Gap(kPadding16),
              Text("Description", style: theme.textTheme.bodyMedium),
              const Gap(kPadding12),
              TextFormField(
                maxLines: 3,
                controller: descriptionController,
                decoration: AppInputDecoration.inputDecoration(
                  context,
                ).copyWith(hintText: "Description"),
              ),
              const Gap(kPadding16),

              Divider(color: theme.colorScheme.surfaceContainer,)
              ,

              const Gap(kPadding16),
              Row(
                children: [
                  const AppIcon(
                    icon: FluentIcons.pill_24_regular,
                  ), const Gap(kPadding8),
                  Text("Type", style: theme.textTheme.titleMedium),
                ],
              ),

              const Gap(kPadding16),
              const Text("What type of medication are you taking?"),
              const Gap(kPadding16),

              GenericSelector<MedicationType, SelectableCircularButton>(
                initialSelection: const [MedicationType.tabletsPills],
                onItemSelected: (selectedType) {
                  log(
                    "Selected medication type is $selectedType",
                    name: "Add Medication Screen",
                  );

                  setState(() {
                    selectedMedicationType = selectedType.first;
                  });
                },
                items: MedicationType.values,
                layout: SelectorLayout.grid,
                childAspectRatio: .8,

                selectableWidgetBuilder: (item, isSelected, onSelected) {
                  String label = item.label;

                  if (item == MedicationType.liquids ||
                      item == MedicationType.droplets) {
                    return SelectableCircularButton(
                      onPressed: onSelected,
                      isItemSelected: isSelected,
                      label: label,
                      // iconPath: item.iconPath,
                      iconPath:
                          isSelected ? item.iconPathFilled : item.iconPath,
                    );
                  } else {
                    return SelectableCircularButton(
                      onPressed: onSelected,
                      isItemSelected: isSelected,
                      label: label,
                      icon: isSelected ? item.iconFilled : item.icon,
                    );
                  }
                },
              ),

              const Gap(24),
              const Text("What's the dose of your medication "),
              const Gap(12),
              GenericSelector<Dose, SelectableChip>(
                wrapSpacing: 8,
                wrapRunSpacing: 6,
                layout: SelectorLayout.wrap,
                isMultiSelectMode: false,
                onItemSelected: (List<Dose> dosesSelected) {
                  log(
                    "Selected medication dose is ${dosesSelected.first.dose}",
                    name: "Add Medication Screen",
                  );
                  selectedDose = dosesSelected.first;
                  setState(() {});
                },
                initialSelection: [defaultDoses.first],
                items: defaultDoses,

                selectableWidgetBuilder: (item, isSelected, onSelected) {
                  /// Will create an empty dose of 0 to represent the case of a custom dose
                  /// Will check for that dose and properly launch the dose picker.

                  return SelectableChip(
                    icon: item.dose == 0 ? FluentIcons.add_24_regular : null,
                    label:
                        item.dose == 0
                            ? "Custom"
                            : item.dose.toStringAsFixed(0) + item.unit.symbol,
                    onPressed: () async {
                      if (item.dose == 0) {
                        _selectDoses();
                      }
                      onSelected.call();
                    },
                    isItemSelected: isSelected,
                  );
                },
              ),

              const Gap(24),

              const Gap(kPadding16),
              Divider(color: theme.colorScheme.surfaceContainer),
              /// ---------------------------------------------///
              const Gap(kPadding16),
              /// Timeline
              Row(
                children: [
                  const AppIcon(
                    icon: HugeIcons.strokeRoundedCalendar03,
                  ), const Gap(kPadding8),
                  Text("Timeline & Schedule", style: theme.textTheme.titleMedium),
                ],
              ),
              const Gap(kPadding16),

              Text("Start Date", style: theme.textTheme.bodyMedium),
              const Gap(kPadding8),
              TextFormField(
                controller: startDateController,
                onTap: () async {
                  /// Show Cupertino Date Picker
                  if (Platform.isIOS) {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return CupertinoDatePickerCustomized(
                          onDateTimeChanged: (DateTime value) {
                            setState(() {
                              selectedStartDate = value;
                              startDateController.text = selectedStartDate!
                                  .formatDate(context);
                            });
                          },
                        );
                      },
                    );
                  } else {
                    final DateTime? pickedDate = await showDatePicker(
                      initialDatePickerMode: DatePickerMode.day,
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    setState(() {
                      selectedStartDate = pickedDate;
                      startDateController.text =
                          selectedStartDate != null
                              ? selectedStartDate!.formatDate(context)
                              : "";
                    });
                  }
                },
                decoration: AppInputDecoration.inputDecoration(
                  context,
                ).copyWith(
                  hintText: "Select start date",
                  suffixIcon: const Icon(HugeIcons.strokeRoundedCalendar03, size: 24),
                ),
              ),

              const Gap(kPadding16),
              if (!isTakingMedsPermanently) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Duration"),
                ),
                const Gap(kPadding16),
                SizedBox(
                  width: double.infinity,
                  child: GenericSelector<int, SelectableChip>(
                    wrapSpacing: 8,
                    wrapRunSpacing: 6,
                    layout: SelectorLayout.wrap,
                    onItemSelected: (List<int> duration) {
                      selectedDuration = Duration(days: duration.first);
                    },
                    items: defaultDurationValues,

                    selectableWidgetBuilder: (item, isSelected, onSelected) {
                      String label = "$item days";
                      if (item >= 14) {
                        label = "${(item / 7).round().toInt()} weeks";
                      }
                      if (item > 30) {
                        label = "${(item / 30).round().toInt()} months";
                      }
                      if (item == 0) {
                        label = "Custom";
                      }

                      return SelectableChip(
                        icon: item == 0 ? FluentIcons.add_24_regular : null,
                        label: label,
                        onPressed: () {
                          if (item == 0) {
                            _selectDuration();
                          }
                          onSelected.call();
                        },
                        isItemSelected: isSelected,
                      );
                    },
                  ),
                ),

                if (selectedDuration != null && showSelectedDuration) ...[
                  const Gap(kPadding16),
                  EmphasizedContainer(
                    label: "Selected Duration",
                    value: "${selectedDuration?.inDays} days",
                  ),
                ],
                const Gap(kPadding16),
              ],
              Row(
                children: [
                  const Text("I am taking this medication permanently"),
                  const Spacer(),
                  CupertinoSwitch(
                    activeTrackColor: theme.colorScheme.primary,
                    value: isTakingMedsPermanently,
                    onChanged: (value) {
                      setState(() {
                        isTakingMedsPermanently = value;
                        selectedDuration = null;
                      });
                    },
                  ),
                ],
              ),

              const Gap(kPadding16),

              /// When do you take your medication
              Row(
                children: [
                  const Text("When do you take your medication?"),
                  const Spacer(),
                  FittedBox(
                    child: AppButton(
                      buttonType: ButtonType.text,
                      isChipButton: true,
                      onPressed: () async {
                        TimeOfDay? selectedTime;
                        if (Platform.isIOS) {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return CupertinoDatePickerCustomized(
                                onDateTimeChanged: (DateTime value) {
                                  setState(() {
                                    selectedTime = TimeOfDay.fromDateTime(
                                      value,
                                    );
                                  });
                                },
                              );
                            },
                          );
                        } else {
                          selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                        }

                        if (selectedTime != null) {
                          setState(() {
                            selectedTimeToTakeMedication.add(selectedTime!);
                          });
                        }
                      },
                      label: "Select times",
                    ),
                  ),
                ],
              ),
              const Gap(kPadding8),
              Wrap(
                direction: Axis.horizontal,
                spacing: 8,
                runSpacing: 12,
                children: [
                  for (TimeOfDay time in selectedTimeToTakeMedication)
                    AppChip(
                      label: time.format(context),
                      onDeleted: () {
                        setState(() {
                          selectedTimeToTakeMedication.remove(time);
                        });
                      },
                    ),
                ],
              ),
              const Gap(kPadding16),
              // ExpansionTile(
              //   initiallyExpanded: true,
              //   title: Text("Timeline & Schedule", style: theme.textTheme.titleMedium),
              //   leading: const AppIcon(icon: HugeIcons.strokeRoundedClock01),
              //   children: [
              //
              //   ],
              // ),
              Divider(color: theme.colorScheme.surfaceContainer),
              /// ---------------------------------------------///
              const Gap(kPadding16),
              Row(
                children: [
                  const AppIcon(
                    icon: HugeIcons.strokeRoundedNotification03,
                  ), const Gap(kPadding8),
                  Text("Notifications", style: theme.textTheme.titleMedium),
                ],
              ),
              const Gap(kPadding16),
              Row(
                children: [
                  const Text("Set reminders for this medication?"),
                  const Spacer(),
                  CupertinoSwitch(
                    activeTrackColor: theme.colorScheme.primary,
                    value: shouldRemind,
                    onChanged: (value) {
                      setState(() {
                        shouldRemind = value;
                      });
                    },
                  ),
                ],
              ),
              if (shouldRemind)
                ...[
                      const Gap(kPadding12),
                      Text(
                        "Reminder message",
                        style: theme.textTheme.bodyMedium,
                      ),
                      const Gap(kPadding12),
                      TextFormField(
                        maxLines: 2,
                        controller: reminderMessageController,
                        decoration: AppInputDecoration.inputDecoration(
                          context,
                        ).copyWith(hintText: "Reminder message (optional)"),
                      ),
                    ]
                    .animate()
                    .moveX(
                      begin: -50,
                      end: 0,
                      duration: 500.ms,
                      curve: Sprung.overDamped,
                    )
                    .fade(duration: 500.ms),

              const Gap(kPadding16),

              // ///Todo: Refactor this such that the frequency is selected in one go
              // const Text("How often do you take your medication in a day?"),
              // const Gap(12),
              //
              // ElevatedButton(
              //   onPressed: () {
              //     showModalBottomSheet(
              //       backgroundColor: Colors.transparent,
              //       context: context,
              //       isScrollControlled: true,
              //       builder: (context) {
              //         return FrequencyBottomSheet();
              //       },
              //     );
              //   },
              //   child: Text("Select button"),
              // ),
              const Gap(kPadding16),
              Divider(color: theme.colorScheme.surfaceContainer),

              const Gap(kPadding16),
              Row(
                children: [
                  const AppIcon(
                    icon: HugeIcons.strokeRoundedAlertCircle,
                  ), const Gap(kPadding8),
                  Text("Notes & Warnings", style: theme.textTheme.titleMedium),
                ],
              ),
              const Gap(kPadding16),
              Text("Things to note", style: theme.textTheme.bodyMedium),
              const Gap(kPadding12),
              TextFormField(
                maxLines: 3,
                controller: warningMessageController,
                decoration: AppInputDecoration.inputDecoration(
                  context,
                ).copyWith(hintText: "Things to note"),
              ),


              const Gap(kPadding48),
              AppButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final Medication medication = Medication(
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim(),
                      type: selectedMedicationType,
                      dose: selectedDose,
                      frequency: selectedFrequency,
                      durationDays: selectedDuration?.inDays,
                      isPermanent: isTakingMedsPermanently,
                      startDate: selectedStartDate,
                      warningMessage: warningMessageController.text.trim(),
                      endDate:
                          selectedDuration != null
                              ? selectedStartDate?.add(selectedDuration!)
                              : null,
                      shouldRemind: shouldRemind,
                      reminderMessage:
                          reminderMessageController.text.trim().isNotEmpty
                              ? reminderMessageController.text.trim()
                              : "It's time to take ${nameController.text.trim()}",
                    );

                    await ref
                        .watch(medNotifierProviderImpl.notifier)
                        .putMedication(medication: medication);
                    if (ref.watch(medNotifierProviderImpl).hasError) {
                      if (context.mounted) {
                        showCustomSnackBar(
                          context: context,
                          message: "Unable to add medication",
                          error:
                              ref.watch(medNotifierProviderImpl).error
                                  as Failure?,
                        );
                      }
                    } else {
                      ///Navigate to where ever
                    }
                  }
                },
                label: widget.isEditing ? "Save Medication" : "Add Medication",
                // icon: FluentIcons.checkmark_24_regular,
              ),
              const Gap(kPadding64),
            ],
          ),
        ),
      ),
    );
  }
}
