import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';

import '../../../../components/components.dart';
import '../../../../core/core.dart';
import '../../models/hla_sample_subject.dart';

/// A row representing one sample subject in the panel. Shows the name and
/// relation; the self subject is badged and never deletable (AC US-2.4).
class HlaSubjectTile extends StatelessWidget {
  const HlaSubjectTile({
    super.key,
    required this.subject,
    this.onDelete,
  });

  final HlaSampleSubject subject;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kPadding16,
        vertical: kPadding12,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(kPadding16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(
              FluentIcons.person_24_regular,
              size: 18,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const Gap(kPadding12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  subject.isSelf ? "You" : subject.relation.label,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColours.neutral50),
                ),
              ],
            ),
          ),
          if (onDelete != null && !subject.isSelf)
            IconButton(
              onPressed: onDelete,
              icon: Icon(
                FluentIcons.delete_24_regular,
                color: theme.colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }
}

/// Opens a bottom sheet to add a new subject. Returns the created
/// [HlaSampleSubject], or null if cancelled.
Future<HlaSampleSubject?> showAddSubjectSheet(BuildContext context) {
  return showModalBottomSheet<HlaSampleSubject>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _AddSubjectSheet(),
  );
}

class _AddSubjectSheet extends StatefulWidget {
  const _AddSubjectSheet();

  @override
  State<_AddSubjectSheet> createState() => _AddSubjectSheetState();
}

class _AddSubjectSheetState extends State<_AddSubjectSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  HlaSubjectRelation _relation = HlaSubjectRelation.sibling;
  Genotype? _genotype;
  String? _nameError;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = "Name is required");
      return;
    }
    Navigator.pop(
      context,
      HlaSampleSubject(
        name: name,
        relation: _relation,
        genotype: _genotype,
        phone:
            _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // Relations a patient can add (everything except `self`).
    final List<HlaSubjectRelation> relations = HlaSubjectRelation.values
        .where((r) => r != HlaSubjectRelation.self)
        .toList();

    return AppBottomSheet(
      title: "Add subject",
      buttonLabel: "Add to panel",
      onPressed: _submit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: AppInputDecoration.inputDecoration(context).copyWith(
              hintText: "Name",
              errorText: _nameError,
            ),
          ),
          const Gap(kPadding16),
          DropdownButtonFormField<HlaSubjectRelation>(
            initialValue: _relation,
            isExpanded: true,
            decoration: AppInputDecoration.inputDecoration(context)
                .copyWith(hintText: "Relation"),
            items: [
              for (final r in relations)
                DropdownMenuItem(value: r, child: Text(r.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _relation = value);
            },
          ),
          const Gap(kPadding16),
          DropdownButtonFormField<Genotype>(
            initialValue: _genotype,
            isExpanded: true,
            decoration: AppInputDecoration.inputDecoration(context)
                .copyWith(hintText: "Genotype (optional)"),
            items: [
              for (final g in Genotype.values)
                DropdownMenuItem(
                  value: g,
                  child: Text(g.name.toUpperCase()),
                ),
            ],
            onChanged: (value) => setState(() => _genotype = value),
          ),
          const Gap(kPadding16),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: AppInputDecoration.inputDecoration(context)
                .copyWith(hintText: "Phone (optional)"),
          ),
          const Gap(kPadding8),
          Text(
            "The patient (you) is always included in the panel.",
            style: AppTextStyles.bodySmall
                .copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
