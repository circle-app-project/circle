import 'package:auto_route/auto_route.dart';
import '../../components/bottom_nav_bar.dart';
import '../../features/auth/auth.dart';
import '../../features/emergency/emergency.dart';
import '../../features/home/home.dart';
import '../../features/meds/meds.dart';
import '../../features/profile/profile.dart';
import '../../features/water/water.dart';
import 'routes.gr.dart' as route;

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    // ////-------Home-------//// //
    AutoRoute(page: route.HomeScreen.page, path: HomeScreen.path),

    // ////-------Water-------//// //
    AutoRoute(page: route.WaterScreen.page, path: WaterScreen.path),
    AutoRoute(
      page: route.EditDailyGoalScreen.page,
      path: EditDailyGoalScreen.path,
    ),
    AutoRoute(
      page: route.SuggestedWaterDailyGoalScreen.page,
      path: SuggestedWaterDailyGoalScreen.path,
    ),
    AutoRoute(page: route.WaterEmptyScreen.page, path: WaterEmptyScreen.path),

    // ////-------Emergency-------//// //
    AutoRoute(page: route.EmergencyScreen.page, path: EmergencyScreen.path),
    AutoRoute(
      page: route.AddEmergencyContactScreen.page,
      path: AddEmergencyContactScreen.path,
    ),
    AutoRoute(page: route.CrisisLogsScreen.page, path: CrisisLogsScreen.path),

    // ////-------Profile-------///
    AutoRoute(page: route.ProfileScreen.page, path: ProfileScreen.path),
    AutoRoute(
      page: route.ProfileBasicInfoScreen.page,
      path: ProfileBasicInfoScreen.path,
    ),
    AutoRoute(
      page: route.ProfileMedicalInfoScreen.page,
      path: ProfileMedicalInfoScreen.path,
    ),
    AutoRoute(
      page: route.ProfileVitalsInfoScreen.page,
      path: ProfileVitalsInfoScreen.path,
    ),

    // ////-------Medication-------//// //
    AutoRoute(page: route.MedsScreen.page, path: MedsScreen.path),
    AutoRoute(
      page: route.MedsScheduleScreen.page,
      path: MedsScheduleScreen.path,
    ),
    AutoRoute(page: route.AddMedsScreen.page, path: AddMedsScreen.path),
    AutoRoute(page: route.MedsDetailsScreen.page, path: MedsDetailsScreen.path),

    // ////-------Onboarding-------//// //
    AutoRoute(
      page: route.OnboardingBaseScreen.page,
      path: OnboardingBaseScreen.path,
    ),

    // ////-------Auth-------//// //
    AutoRoute(page: route.SignInScreen.page, path: SignInScreen.path),
    AutoRoute(page: route.RegisterScreen.page, path: RegisterScreen.path),
    AutoRoute(
      page: route.GoogleSignInScreen.page,
      path: GoogleSignInScreen.path,
    ),
    AutoRoute(page: route.AuthSuccessScreen.page, path: AuthSuccessScreen.path),

    // ////-------Bottom Nav-------//// //
    AutoRoute(page: route.BottomNavBar.page, path: BottomNavBar.path),

    // ////-------Loading Screen-------//// //
    AutoRoute(
      page: route.LoadingScreen.page,
      path: LoadingScreen.path,
      initial: true,
    ),
  ];
}
