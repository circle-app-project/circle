import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../components/components.dart';
import '../../../core/core.dart';
import '../../meds/meds.dart';

class AddEmergencyContactScreen extends StatefulWidget {
  static const String id = "add_emergency_contact";
  const AddEmergencyContactScreen({super.key});

  @override
  State<AddEmergencyContactScreen> createState() =>
      _AddEmergencyContactScreenState();
}

class _AddEmergencyContactScreenState extends State<AddEmergencyContactScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              const CustomAppBar(
                pageTitle: "Add Emergency\nContacts",
              ),
              EditableAvatar(
                  imagePath: "assets/images/memoji.png", onEditPressed: () {}),
              const Gap(
                48,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(FluentIcons.person_24_regular,
                            color: theme.colorScheme.primary),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Name",
                          style: theme.textTheme.bodyMedium,
                        )
                      ],
                    ),
                    const Gap(
                      12,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration:
                          AppInputDecoration.inputDecoration(context)
                              .copyWith(hintText: "Name"),
                    ),
                    const Gap(
                      24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(FluentIcons.call_24_regular,
                            color: theme.colorScheme.primary),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Phone",
                          style: theme.textTheme.bodyMedium,
                        )
                      ],
                    ),
                    const Gap(8),
                    TextFormField(
                      controller: phoneController,
                      decoration:
                          AppInputDecoration.inputDecoration(context)
                              .copyWith(
                        hintText: "Phone Number",
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            FluentIcons.add_24_regular,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    const Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 16,
                      children: [
                        AppChip(
                          label: "6 77 77 77 77",
                          chipType: ChipType.info,
                        ),
                        AppChip(
                            label: "6 77 77 77 77",
                            chipType: ChipType.info),
                      ],
                    ),
                    const Gap(24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          FluentIcons.people_24_regular,
                          color: theme.colorScheme.primary,
                        ),
                        const Gap(
                          4,
                        ),
                        Text(
                          "Relation",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const Gap(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///Todo: Replace with the actual relations
                        MedsTypeItem(
                            medicationType: MedicationType.droplets,
                            onPressed: () {}),
                        MedsTypeItem(
                            medicationType: MedicationType.droplets,
                            onPressed: () {}),
                        MedsTypeItem(
                            medicationType: MedicationType.droplets,
                            onPressed: () {}),
                        MedsTypeItem(
                            medicationType: MedicationType.droplets,
                            onPressed: () {}),
                      ],
                    )
                  ],
                ),
              ),
              const Gap(64),
            ],
          ),
        ),
      ),
    );
  }
}
