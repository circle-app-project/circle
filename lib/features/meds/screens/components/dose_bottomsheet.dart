import 'package:circle/components/components.dart';
import 'package:circle/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import '../../models/dose.dart';

class DoseBottomSheet extends StatefulWidget {
  const DoseBottomSheet({super.key});

  @override
  State<DoseBottomSheet> createState() => _DoseBottomSheetState();
}

class _DoseBottomSheetState extends State<DoseBottomSheet> {
  TextEditingController textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      bottomPadding: 48,
      onPressed: () {

        if(selectedUnit== null){
          showCustomSnackBar(context: context, message: "Please select a unit", mode: SnackBarMode.error);
        }else{
          if(_formKey.currentState!.validate()){
            setState(() {
              dose = Dose(dose: double.parse(textController.text.trim()), unit: selectedUnit!);
            });
            Navigator.pop(context, dose);
          }
        }




      },
      buttonLabel: "Save",
      child: Form(
        key: _formKey,
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
                  //  autofocus: true,
                    controller: textController,
                    keyboardType: TextInputType.number,
                    decoration: AppInputDecoration.inputDecoration(
                      context,
                    ).copyWith(
                      hintText: "e.g 100mg",
                    ),
                    inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Please input a value";
                      }
                      return null;
                    },
                  ),
                ),

              ],
            ),
            const Gap(kPadding16),
            Text("Units", style: theme.textTheme.titleSmall),
            const Gap(kPadding8),
            SizedBox(
              width: double.infinity,
              child: GenericSelector<Units, SelectableChip>(
                wrapSpacing: 8,
                wrapRunSpacing: 6,
                layout: SelectorLayout.wrap,
              //  initialSelection: [Units.milligram],
                onItemSelected: (List<Units> unitSelected) {
                  selectedUnit = unitSelected.first;
                  setState(() {
                  });
                },
                items: dropDownMenuItems,

                selectableWidgetBuilder: (item, isSelected, onSelected) {
                  /// Will create an empty dose of 0 to represent the case of a custom dose
                  /// Will check for that dose and properly launch the dose picker.

                  return SelectableChip(
                    label: item.symbol,
                    onPressed: onSelected,
                    isItemSelected: isSelected,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
