import 'package:circle/core/core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../components/bottom_sheet.dart';
import '../../../../components/generic_selector.dart';
import '../../../../components/selectable_chip.dart';
import '../../../../core/theme/constants.dart';
import '../../models/dose.dart';

class DoseBottomSheet extends StatefulWidget {
  const DoseBottomSheet({super.key});

  @override
  State<DoseBottomSheet> createState() => _DoseBottomSheetState();
}

class _DoseBottomSheetState extends State<DoseBottomSheet> {
  TextEditingController textController = TextEditingController();

  Dose? dose;
  Units? selectedUnit;
  List<Units> dropDownMenuItems = [
    Units.milligram,
    Units.gram,
    Units.droplet,
    Units.millilitres,
    Units.centilitres,
    Units.litres,
    Units.calories,
    Units.kilocalories,
    Units.ounce,
    Units.pound,
  ];

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
      title: "Select Dose",
      onPressed: () {
        Navigator.pop(context, dose);
      },
      buttonLabel: "Save",

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
       // spacing: kPadding16,
        children: [
          Row(
            spacing: 2,
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  autofocus: true,
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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    border: OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: const BorderSide(
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
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          border: OutlineInputBorder(
                            gapPadding: 0,
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            gapPadding: 0,
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            gapPadding: 0,
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            gapPadding: 0,
                            borderSide: const BorderSide(
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
                    initialSelection: dropDownMenuItems.first,
                    onSelected: (unitSelected) {
                      setState(() {
                        selectedUnit = unitSelected;
                      });
                    },
                    trailingIcon: const Icon(
                      FluentIcons.chevron_down_24_regular,
                    ),
                    selectedTrailingIcon: Icon(
                      FluentIcons.chevron_up_24_regular,
                    ),
                    dropdownMenuEntries:
                        dropDownMenuItems
                            .map<DropdownMenuEntry<Units>>(
                              (element) => DropdownMenuEntry<Units>(
                                value: element,
                                label: element.symbol,
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ],
          ),
          Gap(kPadding16),
          Text("Units", style: theme.textTheme.titleSmall),
          Gap(kPadding8),
          SizedBox(
            width: double.infinity,
            child: GenericSelector<Units, SelectableChip>(
              wrapSpacing: 8,
              wrapRunSpacing: 6,
              layout: SelectorLayout.wrap,
              initialSelection: [Units.milligram],
              onItemSelected: (List<Units> unitSelected) {
                selectedUnit = unitSelected.first;
              },
              items: dropDownMenuItems,

              selectableWidgetBuilder: (item, isSelected, onSelected) {
                /// Will create an empty dose of 0 to represent the case of a custom dose
                /// Will check for that dose and properly launch the dose picker.

                return SelectableChip(
                  label: item.name,

                  onPressed: onSelected,

                  isItemSelected: isSelected,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
