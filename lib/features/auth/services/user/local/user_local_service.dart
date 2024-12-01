
import 'package:circle/objectbox.g.dart';

import '../../../auth.dart';

///This app will eventually have multiple users, so it needs to be able to store multiple users

class UserLocalService {
  late final Box<AppUser> _userBox;
  late final Box<UserPreferences> _userPreferencesBox;

  UserLocalService({required Store store})
      : _userBox = store.box<AppUser>(),
        _userPreferencesBox = store.box<UserPreferences>();

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

  AppUser getUserByUid(String uid) {
    Query query = _userBox.query(AppUser_.uid.equals(uid)).build();
    AppUser user = query.find().first;
    query.close();
    return user;
  }

  List<AppUser> getUsers() {
    return _userBox.getAll();
  }

  void addUser(AppUser user) {
    _userBox.put(user);
  }

  void updateUser(AppUser user) {
    _userBox.put(user, mode: PutMode.update);
  }

  void deleteUser({AppUser? user}) {
    if (user == null) {
      _userBox.removeAll();
    } else {
      _userBox.remove(user.id);
    }
  }
}