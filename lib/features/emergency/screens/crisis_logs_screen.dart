import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../../../components/components.dart';
import 'components/crisis_history_monthly.dart';
@RoutePage(name: CrisisLogsScreen.name)
class CrisisLogsScreen extends StatelessWidget {
  static const String path = "/crisis_logs";
  static const String name = "CrisisLogsScreen";
  const CrisisLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(pageTitle: "Crises History"),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16),
            //   child: CrisisHistoryWeekly(),
            // ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CrisisHistoryMonthly()),
          ],
        ),
      ),
    );
  }
}
