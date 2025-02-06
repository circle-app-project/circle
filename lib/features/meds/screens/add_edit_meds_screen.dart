import 'dart:io';

import 'package:circle/core/extensions/date_time_formatter.dart';
import 'package:circle/features/meds/models/dose.dart';
import 'package:circle/features/meds/screens/components/dose_bottomsheet.dart';
import 'package:circle/features/meds/screens/components/duration_bottomsheet.dart';
import 'package:circle/features/meds/screens/components/emphasized_container.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../components/components.dart';
import '../../../components/customized_cupertino_date_picker.dart';
import '../../../core/core.dart';
import '../meds.dart';
import '../models/frequency.dart';
import '../models/medication.dart';
import '../providers/med_notifier.dart';
import 'components/custom_dose_dialog.dart';

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
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController warningMessageController =
      TextEditingController();

  List<int> defaultDoseValues = [5, 10, 50, 100, 250, 500, 1000, 0];
  List<int> defaultDurationValues = [3, 7, 14, 21, 30, 60, 90, 0];

  /// Fields to be created by the medication
  bool isTakingMedsPermanently = false;
  MedicationType selectedMedicationType = MedicationType.tabletsPills;
  Dose selectedDose = Dose.empty;
  Frequency selectedFrequency = Frequency.empty;
  DateTime? selectedStartDate = DateTime.now();
  Duration? selectedDuration;
  bool showSelectedDuration = false;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    warningMessageController.dispose();
    endDateController.dispose();
    startDateController.dispose();

    super.dispose();
  }

  void _selectDuration() async {
    selectedDuration = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DurationBottomSheet();
      },
    );

    /// Add the selected duration to the default duration values
    /// to visually show the user

    defaultDurationValues.insert(
      defaultDurationValues.length - 1,
      selectedDuration!.inDays,
    );

    showSelectedDuration = true;

    print("Selected duration is ${selectedDuration!.inDays} days");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;
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
              Text("General Information", style: theme.textTheme.titleMedium),

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
              const Gap(kPadding24),

              Text("Type", style: theme.textTheme.titleMedium),
              const Gap(kPadding16),
              const Text("What type of medication are you taking?"),
              const Gap(kPadding16),

              GenericSelector<MedicationType, SelectableCircularButton>(
                initialSelection: [MedicationType.tabletsPills],
                onItemSelected: (selectedType) {
                  print("selectedMedication: $selectedType");

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
                onItemSelected: (List<Dose> dosesSelected) {
                  print("selectedDoses: $dosesSelected");
                  selectedDose = dosesSelected.first;
                },
                items: [
                  ...List.generate(
                    defaultDoseValues.length,
                    (index) => Dose(
                      dose: defaultDoseValues[index].toDouble(),
                      unit: Units.milligram,
                    ),
                  ),
                ],

                selectableWidgetBuilder: (item, isSelected, onSelected) {
                  /// Will create an empty dose of 0 to represent the case of a custom dose
                  /// Will check for that dose and properly launch the dose picker.

                  return SelectableChip(
                    icon: item.dose == 0 ? FluentIcons.add_24_regular : null,
                    label:
                        item.dose == 0
                            ? "Custom"
                            : item.dose.toStringAsFixed(0) + item.unit.symbol,
                    onPressed: () {
                      onSelected.call();

                      if (item.dose == 0) {
                        ///Todo: Refactor and rebuild this into a Dose picker, which can be used anywhere
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return  DoseBottomSheet();
                              // child: ListWheelScrollViewPicker(
                              //   mode: AppListWheelScrollViewPickerMode.integer,
                              //   primaryInitialValue: 50,
                              //   primaryFinalValue: 1000,
                              //   primaryValueInterval: 50,
                              //   primaryUnitLabels:
                              //       Units.values.map((e) => e.symbol).toList(),
                              //   scrollViewToLabelPadding: 24,
                              //   onSelectedItemChanged: (selectedValue) {
                              //     Dose constructedDose = Dose(
                              //       dose: selectedValue as double,
                              //       unit: Units.milligram,
                              //     );
                              //
                              //     selectedDose = constructedDose;
                              //   },
                              // ),

                          },
                        );
                      }
                    },
                    isItemSelected: isSelected,
                  );
                },
              ),

              const Gap(24),

              ///Todo: Refactor this such that the frequency is selected in one go
              const Text("How often do you take your medication in a day?"),
              const Gap(12),
              GenericSelector<MedicationType, SelectableChip>(
                initialSelection: [MedicationType.tabletsPills],
                onItemSelected: (selectedType) {
                  print("selectedMedication: $selectedType");

                  setState(() {
                    selectedMedicationType = selectedType.first;
                  });
                },
                items: MedicationType.values,
                layout: SelectorLayout.wrap,
                wrapSpacing: 8,
                wrapRunSpacing: 6,

                selectableWidgetBuilder: (item, isSelected, onSelected) {
                  String label = item.label;

                  if (item == MedicationType.liquids ||
                      item == MedicationType.droplets) {
                    return SelectableChip(
                      onPressed: onSelected,
                      isItemSelected: isSelected,
                      label: label,
                      // iconPath: item.iconPath,
                      iconPath:
                          isSelected ? item.iconPathFilled : item.iconPath,
                    );
                  } else {
                    return SelectableChip(
                      onPressed: onSelected,
                      isItemSelected: isSelected,
                      label: label,
                      icon: isSelected ? item.iconFilled : item.icon,
                    );
                  }
                },
              ),

              const Gap(kPadding24),

              /// Timeline
              Text("Timeline & Schedule", style: theme.textTheme.titleMedium),
              const Gap(kPadding24),
              Text("Start Date", style: theme.textTheme.bodyMedium),
              Gap(kPadding8),
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
                  suffixIcon: Icon(FluentIcons.calendar_24_regular, size: 24),
                ),
              ),

              Gap(kPadding16),
              const Text("Duration"),
              const Gap(kPadding16),
              GenericSelector<int, SelectableChip>(
                wrapSpacing: 8,
                wrapRunSpacing: 6,
                layout: SelectorLayout.wrap,
                onItemSelected: (List<int> duration) {
                  print("selectedDuration: $duration");
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
              //
              // if (showSelectedDuration)
              //   EmphasizedContainer(
              //     label: "Selected Duration",
              //     value: "${selectedDuration?.inDays} days",
              //   ),
              Gap(kPadding16),
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
                      });
                    },
                  ),
                ],
              ),
              const Gap(12),
              Gap(kPadding48),
              AppButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final Medication medication = Medication(
                      name: nameController.text,
                      description: descriptionController.text,
                      type: selectedMedicationType,
                      dose: selectedDose,
                      frequency: selectedFrequency,
                      durationDays: selectedDuration?.inDays,
                      isPermanent: isTakingMedsPermanently,
                      startDate: selectedStartDate,
                      endDate:
                          selectedDuration != null
                              ? selectedStartDate?.add(selectedDuration!)
                              : null,
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
                icon: FluentIcons.checkmark_24_regular,
              ),

              if (!widget.isEditing) ...[
                const Gap(kPadding16),
                AppButton(
                  onPressed: () {
                    context.pop();
                  },
                  label: "Done",
                  buttonType: ButtonType.outline,
                ),
              ],

              const SizedBox(height: kPadding64),
            ],
          ),
        ),
      ),
    );
  }
}
