import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';

import '../../../components/components.dart';
import '../../../core/core.dart';
import '../../auth/auth.dart';
import '../hla.dart';

/// Entry point for the HLA typing feature: a plain-language explainer of what
/// HLA typing is and why it matters, plus the primary CTA. If the patient
/// already has an active request, the CTA becomes "View your active request"
/// (AC US-1.1, US-1.3).
@RoutePage(name: HlaIntroScreen.name)
class HlaIntroScreen extends ConsumerStatefulWidget {
  static const String path = "/hla";
  static const String name = "HlaIntroScreen";
  const HlaIntroScreen({super.key});

  @override
  ConsumerState<HlaIntroScreen> createState() => _HlaIntroScreenState();
}

class _HlaIntroScreenState extends ConsumerState<HlaIntroScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final AppUser user = ref.read(userNotifierProviderImpl).value ?? AppUser.empty;
      if (user.isNotEmpty) {
        await ref
            .read(hlaRequestsNotifierProviderImpl.notifier)
            .getRequests(user: user);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppUser user = ref.watch(userNotifierProviderImpl).value ?? AppUser.empty;
    final List<HlaTestRequest> requests =
        ref.watch(hlaRequestsNotifierProviderImpl).value ?? [];

    HlaTestRequest? active;
    for (final r in requests) {
      if (!r.isCancelled && !r.status.isTerminal) {
        active = r;
        break;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kPadding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(pageTitle: "HLA Typing"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(kPadding24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(kPadding24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      FluentIcons.organization_24_regular,
                      size: 40,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    const Gap(kPadding16),
                    Text(
                      "Find your transplant match",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const Gap(kPadding8),
                    Text(
                      "HLA typing is a blood test that identifies the proteins "
                      "(markers) your immune system uses to tell your cells "
                      "apart from others. Matching these markers with a donor "
                      "is the first step toward a bone marrow or stem cell "
                      "transplant.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(kPadding24),
              Text("How it works", style: theme.textTheme.titleMedium),
              const Gap(kPadding12),
              const _Step(
                number: 1,
                title: "Request the test",
                body:
                    "Tell us you'd like an HLA typing test and list the people "
                    "whose samples will be collected with yours.",
              ),
              const _Step(
                number: 2,
                title: "Book a collection appointment",
                body:
                    "Pick a time to come in and hand over your sample at one "
                    "of our collection points.",
              ),
              const _Step(
                number: 3,
                title: "Track your sample's journey",
                body:
                    "Your sample is cross-matched against your panel and sent "
                    "to our partner lab. Follow every step in the app.",
              ),
              const _Step(
                number: 4,
                title: "Receive your results",
                body: "Your results are delivered securely inside the app.",
                isLast: true,
              ),
              const Gap(kPadding32),
              if (active != null)
                Builder(
                  builder: (context) {
                    final HlaTestRequest activeRequest = active!;
                    return AppButton(
                      label: "View your active request",
                      trailingIcon: FluentIcons.arrow_right_24_regular,
                      onPressed: () {
                        context.router.pushNamed(
                          "${HlaStatusScreen.path}/${activeRequest.uid}",
                        );
                      },
                    );
                  },
                )
              else
                AppButton(
                  label: "Request test",
                  trailingIcon: FluentIcons.arrow_right_24_regular,
                  onPressed: user.isEmpty
                      ? () {}
                      : () {
                          context.router.pushNamed(HlaRequestFormScreen.path);
                        },
                ),
              const Gap(kPadding12),
              if (requests.isNotEmpty)
                AppButton(
                  label: "My requests",
                  buttonType: ButtonType.outline,
                  onPressed: () {
                    context.router.pushNamed(HlaRequestsListScreen.path);
                  },
                ),
              const Gap(kPadding64),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.title,
    required this.body,
    this.isLast = false,
  });

  final int number;
  final String title;
  final String body;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : kPadding16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: theme.colorScheme.secondaryContainer,
            child: Text(
              "$number",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Gap(kPadding12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Gap(kPadding4),
                Text(
                  body,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColours.neutral50, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
