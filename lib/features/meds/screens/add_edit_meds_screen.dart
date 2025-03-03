import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
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
import 'package:springster/springster.dart';
import '../../../components/components.dart';
import '../../../components/customized_cupertino_date_picker.dart';
import '../../../core/core.dart';
import '../meds.dart';
import '../models/frequency.dart';
import '../models/medication.dart';
import '../providers/med_notifier.dart';

///Todo: Animate things on and off the screen more elegantly

@RoutePage(name: AddMedsScreen.name)
class AddMedsScreen extends ConsumerStatefulWidget {
  static const String path = "/add_meds";
  static const String name = "AddMedsScreen";
  final bool isEditing;
  final Medication? medicationToEdit;
  const AddMedsScreen({
    super.key,
    this.isEditing = false,
    this.medicationToEdit,
  });

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
  MedicationType selectedMedicationType = MedicationType.tablet;
  Dose? selectedDose;
  // Frequency selectedFrequency = Frequency.empty;
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

    if (widget.isEditing && widget.medicationToEdit != null) {
      selectedStartDate = widget.medicationToEdit?.startDate;
      nameController.text = widget.medicationToEdit?.name ?? "";
      descriptionController.text = widget.medicationToEdit?.description ?? "";
      selectedMedicationType =
          widget.medicationToEdit?.type ?? MedicationType.tablet;
      selectedDose = widget.medicationToEdit?.dose;
      selectedDuration = Duration(
        days: widget.medicationToEdit?.durationDays ?? 0,
      );
      isTakingMedsPermanently = widget.medicationToEdit?.isPermanent ?? false;
      selectedTimeToTakeMedication =
          widget.medicationToEdit?.frequency?.times ?? [];
      shouldRemind = widget.medicationToEdit?.shouldRemind ?? true;
      warningMessageController.text =
          widget.medicationToEdit?.warningMessage ?? "";
      reminderMessageController.text =
          widget.medicationToEdit?.reminderMessage ?? "";

      /// Add the selected duration on dose to the list of default doses and durations, then make them sets
      defaultDoses.insert(defaultDoseValues.length - 1, selectedDose!);
      defaultDoses.toSet().toList(); /// Convert to set to remove duplicates then back to list

      defaultDurationValues.insert(
        defaultDurationValues.length - 1,
        selectedDuration!.inDays,
      );

      defaultDurationValues.toSet().toList(); /// Convert to set to remove duplicates then back to list
    }

    super.initState();
  }

  void _selectDuration() async {
    selectedDuration = await showModalBottomSheet(
      sheetAnimationStyle: AnimationStyle(
        curve: Spring.defaultIOS.toCurve,
        duration: 300.ms,
        reverseCurve: Spring.defaultIOS.toCurve,
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
        curve: Spring.defaultIOS.toCurve,
        duration: 300.ms,
        reverseCurve: Spring.defaultIOS.toCurve,
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
          child: Form(
            key: _formKey,
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
                    const AppIcon(icon: HugeIcons.strokeRoundedFile01),
                    const Gap(kPadding8),
                    Text(
                      "General Information",
                      style: theme.textTheme.titleMedium,
                    ),
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

                Divider(color: theme.colorScheme.surfaceContainer),

                const Gap(kPadding16),
                Row(
                  children: [
                    const AppIcon(icon: FluentIcons.pill_24_regular),
                    const Gap(kPadding8),
                    Text("Type", style: theme.textTheme.titleMedium),
                  ],
                ),

                const Gap(kPadding16),
                const Text("What type of medication are you taking?"),
                const Gap(kPadding16),

                GenericSelector<MedicationType, SelectableCircularButton>(
                  initialSelection:
                      widget.isEditing
                          ? [
                            widget.medicationToEdit?.type ??
                                MedicationType.tablet,
                          ]
                          : const [MedicationType.tablet],
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

                    if (item == MedicationType.liquid ||
                        item == MedicationType.droplet) {
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
                  initialSelection:
                      widget.isEditing
                          ? [
                            widget.medicationToEdit?.dose ?? defaultDoses.first,
                          ]
                          : [defaultDoses.first],
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
                    const AppIcon(icon: HugeIcons.strokeRoundedCalendar03),
                    const Gap(kPadding8),
                    Text(
                      "Timeline & Schedule",
                      style: theme.textTheme.titleMedium,
                    ),
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
                        firstDate: DateTime(
                          2000,
                          01,
                          01,
                        ), // Set the initial date to 2000
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
                    suffixIcon: const Icon(
                      HugeIcons.strokeRoundedCalendar03,
                      size: 24,
                    ),
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
                    const AppIcon(icon: HugeIcons.strokeRoundedNotification03),
                    const Gap(kPadding8),
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
                        curve: Spring.defaultIOS.toCurve,
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
                    const AppIcon(icon: HugeIcons.strokeRoundedAlertCircle),
                    const Gap(kPadding8),
                    Text(
                      "Notes & Warnings",
                      style: theme.textTheme.titleMedium,
                    ),
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
                    /// Construct a selected frequency object
                    /// To keep things simple for now, we are assuming
                    /// the medication will be taken daily.
                    /// We believe this should cover 90+% of all cases.
                    /// In the future, we will add a more comprehensive
                    /// medication frequency selection.
                    final Frequency constructedFrequency = Frequency.daily(
                      times: selectedTimeToTakeMedication,
                      timesPerDay: selectedTimeToTakeMedication.length,
                    );

                    // Enforce Adding required fields

                    if(selectedTimeToTakeMedication.isEmpty){
                      showCustomSnackBar(
                        context: context,
                        message: "Please select a time to take your medication",
                        mode: SnackBarMode.error,
                      );
                      return;
                    }

                    if (selectedDose == null) {
                      showCustomSnackBar(
                        context: context,
                        message: "Please select a time to take your medication",
                        mode: SnackBarMode.error,
                      );
                      return;
                    }

                    if (_formKey.currentState!.validate()) {
                      final Medication medication;
                      if (!widget.isEditing) {
                        medication = Medication(
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim(),
                          type: selectedMedicationType,
                          dose: selectedDose,
                          frequency: constructedFrequency,
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
                          updatedAt: DateTime.now(),
                          createdAt: DateTime.now(),
                        );
                      } else {
                        final Frequency constructedFrequency = Frequency.daily(
                          times: selectedTimeToTakeMedication,
                          timesPerDay: selectedTimeToTakeMedication.length,
                        );

                        ///Todo: Use copy With to add a edit the current medication
                        medication = widget.medicationToEdit!.copyWith(
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim(),
                          type: selectedMedicationType,
                          dose: selectedDose,
                          frequency: constructedFrequency,
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
                          updatedAt: DateTime.now(),
                        );
                      }

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
                        if (context.mounted) {
                          showCustomSnackBar(
                            context: context,
                            message: "Medication Added Successfully",
                            mode: SnackBarMode.success,
                          );
                          context.back();
                        }

                        ///Navigate to where ever
                      }
                    }
                  },
                  label:
                      widget.isEditing ? "Save Medication" : "Add Medication",
                  // icon: FluentIcons.checkmark_24_regular,
                ),
                const Gap(kPadding64),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
