// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i26;
import 'package:circle/components/bottom_nav_bar.dart' as _i4;
import 'package:circle/features/auth/screens/auth/auth_success.dart' as _i3;
import 'package:circle/features/auth/screens/auth/google_sign_in_screen.dart'
    as _i8;
import 'package:circle/features/auth/screens/auth/loading_screen.dart' as _i11;
import 'package:circle/features/auth/screens/auth/register_screen.dart' as _i20;
import 'package:circle/features/auth/screens/auth/sign_in_screen.dart' as _i22;
import 'package:circle/features/auth/screens/onboarding/onboarding_base_screen.dart'
    as _i15;
import 'package:circle/features/emergency/screens/add_emergency_contact_screen.dart'
    as _i1;
import 'package:circle/features/emergency/screens/crisis_logs_screen.dart'
    as _i5;
import 'package:circle/features/emergency/screens/emergency_screen.dart' as _i7;
import 'package:circle/features/health_connect/screens/health_screen.dart'
    as _i9;
import 'package:circle/features/home/screens/home_screen.dart' as _i10;
import 'package:circle/features/meds/models/medication.dart' as _i28;
import 'package:circle/features/meds/screens/add_edit_meds_screen.dart' as _i2;
import 'package:circle/features/meds/screens/meds_details_screen.dart' as _i12;
import 'package:circle/features/meds/screens/meds_schedule_screen.dart' as _i13;
import 'package:circle/features/meds/screens/meds_screen.dart' as _i14;
import 'package:circle/features/profile/screens/profile_basic_info_screen.dart'
    as _i16;
import 'package:circle/features/profile/screens/profile_medical_info_screen.dart'
    as _i17;
import 'package:circle/features/profile/screens/profile_screen.dart' as _i18;
import 'package:circle/features/profile/screens/profile_vitals_info_screen.dart'
    as _i19;
import 'package:circle/features/profile/screens/settings_screen.dart' as _i21;
import 'package:circle/features/water/screens/edit_daily_goal_screen.dart'
    as _i6;
import 'package:circle/features/water/screens/suggested_water_daily_goal_screen.dart'
    as _i23;
import 'package:circle/features/water/screens/water_empty_screen.dart' as _i24;
import 'package:circle/features/water/screens/water_screen.dart' as _i25;
import 'package:flutter/cupertino.dart' as _i27;
import 'package:flutter/material.dart' as _i29;

/// generated route for
/// [_i1.AddEmergencyContactScreen]
class AddEmergencyContactScreen extends _i26.PageRouteInfo<void> {
  const AddEmergencyContactScreen({List<_i26.PageRouteInfo>? children})
    : super(AddEmergencyContactScreen.name, initialChildren: children);

  static const String name = 'AddEmergencyContactScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i1.AddEmergencyContactScreen();
    },
  );
}

/// generated route for
/// [_i2.AddMedsScreen]
class AddMedsScreen extends _i26.PageRouteInfo<AddMedsScreenArgs> {
  AddMedsScreen({
    _i27.Key? key,
    bool isEditing = false,
    _i28.Medication? medicationToEdit,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         AddMedsScreen.name,
         args: AddMedsScreenArgs(
           key: key,
           isEditing: isEditing,
           medicationToEdit: medicationToEdit,
         ),
         initialChildren: children,
       );

  static const String name = 'AddMedsScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddMedsScreenArgs>(
        orElse: () => const AddMedsScreenArgs(),
      );
      return _i2.AddMedsScreen(
        key: args.key,
        isEditing: args.isEditing,
        medicationToEdit: args.medicationToEdit,
      );
    },
  );
}

class AddMedsScreenArgs {
  const AddMedsScreenArgs({
    this.key,
    this.isEditing = false,
    this.medicationToEdit,
  });

  final _i27.Key? key;

  final bool isEditing;

  final _i28.Medication? medicationToEdit;

  @override
  String toString() {
    return 'AddMedsScreenArgs{key: $key, isEditing: $isEditing, medicationToEdit: $medicationToEdit}';
  }
}

/// generated route for
/// [_i3.AuthSuccessScreen]
class AuthSuccessScreen extends _i26.PageRouteInfo<void> {
  const AuthSuccessScreen({List<_i26.PageRouteInfo>? children})
    : super(AuthSuccessScreen.name, initialChildren: children);

  static const String name = 'AuthSuccessScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i3.AuthSuccessScreen();
    },
  );
}

/// generated route for
/// [_i4.BottomNavBar]
class BottomNavBar extends _i26.PageRouteInfo<void> {
  const BottomNavBar({List<_i26.PageRouteInfo>? children})
    : super(BottomNavBar.name, initialChildren: children);

  static const String name = 'BottomNavBar';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i4.BottomNavBar();
    },
  );
}

/// generated route for
/// [_i5.CrisisLogsScreen]
class CrisisLogsScreen extends _i26.PageRouteInfo<void> {
  const CrisisLogsScreen({List<_i26.PageRouteInfo>? children})
    : super(CrisisLogsScreen.name, initialChildren: children);

  static const String name = 'CrisisLogsScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i5.CrisisLogsScreen();
    },
  );
}

/// generated route for
/// [_i6.EditDailyGoalScreen]
class EditDailyGoalScreen extends _i26.PageRouteInfo<void> {
  const EditDailyGoalScreen({List<_i26.PageRouteInfo>? children})
    : super(EditDailyGoalScreen.name, initialChildren: children);

  static const String name = 'EditDailyGoalScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i6.EditDailyGoalScreen();
    },
  );
}

/// generated route for
/// [_i7.EmergencyScreen]
class EmergencyScreen extends _i26.PageRouteInfo<void> {
  const EmergencyScreen({List<_i26.PageRouteInfo>? children})
    : super(EmergencyScreen.name, initialChildren: children);

  static const String name = 'EmergencyScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i7.EmergencyScreen();
    },
  );
}

/// generated route for
/// [_i8.GoogleSignInScreen]
class GoogleSignInScreen extends _i26.PageRouteInfo<void> {
  const GoogleSignInScreen({List<_i26.PageRouteInfo>? children})
    : super(GoogleSignInScreen.name, initialChildren: children);

  static const String name = 'GoogleSignInScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i8.GoogleSignInScreen();
    },
  );
}

/// generated route for
/// [_i9.HealthScreen]
class HealthScreen extends _i26.PageRouteInfo<void> {
  const HealthScreen({List<_i26.PageRouteInfo>? children})
    : super(HealthScreen.name, initialChildren: children);

  static const String name = 'HealthScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i9.HealthScreen();
    },
  );
}

/// generated route for
/// [_i10.HomeScreen]
class HomeScreen extends _i26.PageRouteInfo<void> {
  const HomeScreen({List<_i26.PageRouteInfo>? children})
    : super(HomeScreen.name, initialChildren: children);

  static const String name = 'HomeScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i10.HomeScreen();
    },
  );
}

/// generated route for
/// [_i11.LoadingScreen]
class LoadingScreen extends _i26.PageRouteInfo<void> {
  const LoadingScreen({List<_i26.PageRouteInfo>? children})
    : super(LoadingScreen.name, initialChildren: children);

  static const String name = 'LoadingScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i11.LoadingScreen();
    },
  );
}

/// generated route for
/// [_i12.MedsDetailsScreen]
class MedsDetailsScreen extends _i26.PageRouteInfo<void> {
  const MedsDetailsScreen({List<_i26.PageRouteInfo>? children})
    : super(MedsDetailsScreen.name, initialChildren: children);

  static const String name = 'MedsDetailsScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i12.MedsDetailsScreen();
    },
  );
}

/// generated route for
/// [_i13.MedsScheduleScreen]
class MedsScheduleScreen extends _i26.PageRouteInfo<void> {
  const MedsScheduleScreen({List<_i26.PageRouteInfo>? children})
    : super(MedsScheduleScreen.name, initialChildren: children);

  static const String name = 'MedsScheduleScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i13.MedsScheduleScreen();
    },
  );
}

/// generated route for
/// [_i14.MedsScreen]
class MedsScreen extends _i26.PageRouteInfo<void> {
  const MedsScreen({List<_i26.PageRouteInfo>? children})
    : super(MedsScreen.name, initialChildren: children);

  static const String name = 'MedsScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i14.MedsScreen();
    },
  );
}

/// generated route for
/// [_i15.OnboardingBaseScreen]
class OnboardingBaseScreen extends _i26.PageRouteInfo<void> {
  const OnboardingBaseScreen({List<_i26.PageRouteInfo>? children})
    : super(OnboardingBaseScreen.name, initialChildren: children);

  static const String name = 'OnboardingBaseScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i15.OnboardingBaseScreen();
    },
  );
}

/// generated route for
/// [_i16.ProfileBasicInfoScreen]
class ProfileBasicInfoScreen
    extends _i26.PageRouteInfo<ProfileBasicInfoScreenArgs> {
  ProfileBasicInfoScreen({
    _i29.Key? key,
    bool? isEditing = false,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         ProfileBasicInfoScreen.name,
         args: ProfileBasicInfoScreenArgs(key: key, isEditing: isEditing),
         initialChildren: children,
       );

  static const String name = 'ProfileBasicInfoScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileBasicInfoScreenArgs>(
        orElse: () => const ProfileBasicInfoScreenArgs(),
      );
      return _i16.ProfileBasicInfoScreen(
        key: args.key,
        isEditing: args.isEditing,
      );
    },
  );
}

class ProfileBasicInfoScreenArgs {
  const ProfileBasicInfoScreenArgs({this.key, this.isEditing = false});

  final _i29.Key? key;

  final bool? isEditing;

  @override
  String toString() {
    return 'ProfileBasicInfoScreenArgs{key: $key, isEditing: $isEditing}';
  }
}

/// generated route for
/// [_i17.ProfileMedicalInfoScreen]
class ProfileMedicalInfoScreen
    extends _i26.PageRouteInfo<ProfileMedicalInfoScreenArgs> {
  ProfileMedicalInfoScreen({
    _i29.Key? key,
    bool? isEditing = false,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         ProfileMedicalInfoScreen.name,
         args: ProfileMedicalInfoScreenArgs(key: key, isEditing: isEditing),
         initialChildren: children,
       );

  static const String name = 'ProfileMedicalInfoScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileMedicalInfoScreenArgs>(
        orElse: () => const ProfileMedicalInfoScreenArgs(),
      );
      return _i17.ProfileMedicalInfoScreen(
        key: args.key,
        isEditing: args.isEditing,
      );
    },
  );
}

class ProfileMedicalInfoScreenArgs {
  const ProfileMedicalInfoScreenArgs({this.key, this.isEditing = false});

  final _i29.Key? key;

  final bool? isEditing;

  @override
  String toString() {
    return 'ProfileMedicalInfoScreenArgs{key: $key, isEditing: $isEditing}';
  }
}

/// generated route for
/// [_i18.ProfileScreen]
class ProfileScreen extends _i26.PageRouteInfo<void> {
  const ProfileScreen({List<_i26.PageRouteInfo>? children})
    : super(ProfileScreen.name, initialChildren: children);

  static const String name = 'ProfileScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i18.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i19.ProfileVitalsInfoScreen]
class ProfileVitalsInfoScreen
    extends _i26.PageRouteInfo<ProfileVitalsInfoScreenArgs> {
  ProfileVitalsInfoScreen({
    _i29.Key? key,
    bool? isEditing = false,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         ProfileVitalsInfoScreen.name,
         args: ProfileVitalsInfoScreenArgs(key: key, isEditing: isEditing),
         initialChildren: children,
       );

  static const String name = 'ProfileVitalsInfoScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileVitalsInfoScreenArgs>(
        orElse: () => const ProfileVitalsInfoScreenArgs(),
      );
      return _i19.ProfileVitalsInfoScreen(
        key: args.key,
        isEditing: args.isEditing,
      );
    },
  );
}

class ProfileVitalsInfoScreenArgs {
  const ProfileVitalsInfoScreenArgs({this.key, this.isEditing = false});

  final _i29.Key? key;

  final bool? isEditing;

  @override
  String toString() {
    return 'ProfileVitalsInfoScreenArgs{key: $key, isEditing: $isEditing}';
  }
}

/// generated route for
/// [_i20.RegisterScreen]
class RegisterScreen extends _i26.PageRouteInfo<void> {
  const RegisterScreen({List<_i26.PageRouteInfo>? children})
    : super(RegisterScreen.name, initialChildren: children);

  static const String name = 'RegisterScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i20.RegisterScreen();
    },
  );
}

/// generated route for
/// [_i21.SettingsScreen]
class SettingsScreen extends _i26.PageRouteInfo<void> {
  const SettingsScreen({List<_i26.PageRouteInfo>? children})
    : super(SettingsScreen.name, initialChildren: children);

  static const String name = 'SettingsScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i21.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i22.SignInScreen]
class SignInScreen extends _i26.PageRouteInfo<void> {
  const SignInScreen({List<_i26.PageRouteInfo>? children})
    : super(SignInScreen.name, initialChildren: children);

  static const String name = 'SignInScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i22.SignInScreen();
    },
  );
}

/// generated route for
/// [_i23.SuggestedWaterDailyGoalScreen]
class SuggestedWaterDailyGoalScreen extends _i26.PageRouteInfo<void> {
  const SuggestedWaterDailyGoalScreen({List<_i26.PageRouteInfo>? children})
    : super(SuggestedWaterDailyGoalScreen.name, initialChildren: children);

  static const String name = 'SuggestedWaterDailyGoalScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i23.SuggestedWaterDailyGoalScreen();
    },
  );
}

/// generated route for
/// [_i24.WaterEmptyScreen]
class WaterEmptyScreen extends _i26.PageRouteInfo<void> {
  const WaterEmptyScreen({List<_i26.PageRouteInfo>? children})
    : super(WaterEmptyScreen.name, initialChildren: children);

  static const String name = 'WaterEmptyScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i24.WaterEmptyScreen();
    },
  );
}

/// generated route for
/// [_i25.WaterScreen]
class WaterScreen extends _i26.PageRouteInfo<void> {
  const WaterScreen({List<_i26.PageRouteInfo>? children})
    : super(WaterScreen.name, initialChildren: children);

  static const String name = 'WaterScreen';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i25.WaterScreen();
    },
  );
}
