import 'package:circle/objectbox.g.dart';

import '../../../auth.dart';

///This app will eventually have multiple users, so it needs to be able to store multiple users

class UserLocalService {
  late final Box<AppUser> _userBox;
  late final Box<UserPreferences> _userPreferencesBox;
  late final Box<UserProfile> _userProfileBox;

  UserLocalService({required Store store})
    : _userBox = store.box<AppUser>(),
      _userPreferencesBox = store.box<UserPreferences>(),
      _userProfileBox = store.box<UserProfile>();

  Stream<UserPreferences> listenUserPreferences() {
    return _userPreferencesBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find().first);
  }

  AppUser getUser({int? id}) {
    if (id == null) {
      List<AppUser> users = _userBox.getAll();
      return users.isEmpty ? AppUser.empty : users.first;
    } else {
      return _userBox.get(id) ?? AppUser.empty;
    }
  }

  AppUser? getUserByUid(String uid) {
    /// Attempts to get a user with this uid, returns null if a user doesn't exits
    Query query = _userBox.query(AppUser_.uid.equals(uid)).build();
    try {
      AppUser user = query.find().first;
      query.close();
      return user;
    } catch (e) {
      query.close();
      return null;
    }
  }

  List<AppUser> getUsers() {
    return _userBox.getAll();
  }

  Future<AppUser> putAndGetUser(AppUser user) async {
    // Save relations first
    if (user.profile.target != null) {
      user.profile.target = await _userProfileBox.putAndGetAsync(
        user.profile.target!,
        mode: user.profile.target?.id == 0 ? PutMode.put : PutMode.update,
      );
    }
    if (user.preferences.target != null) {
      user.preferences.target = await _userPreferencesBox.putAndGetAsync(
        user.preferences.target!,
        mode: user.preferences.target?.id == 0 ? PutMode.put : PutMode.update,
      );
    }

    // Then save user
    return await _userBox.putAndGetAsync(
      user,
      mode: user.id == 0 ? PutMode.put : PutMode.update,
    );
  }



  void deleteUser({AppUser? user}) {

    if (user == null) {
      _userProfileBox.removeAll();
      _userPreferencesBox.removeAll();
      _userBox.removeAll();
    } else {
      if(user.profile.target?.id != null){
        _userProfileBox.remove(user.profile.target!.id);
      }

      if(user.preferences.target?.id != null){
        _userPreferencesBox.remove(user.preferences.target!.id);
      }
      _userBox.remove(user.id);
    }
  }
}
