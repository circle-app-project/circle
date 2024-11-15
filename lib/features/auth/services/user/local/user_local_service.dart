import 'package:circle/features/auth/auth.dart';
import 'package:circle/objectbox.g.dart';

//This app will eventually have multiple users, so it needs to be able to store multiple users
class UserLocalService {
  late final Box<AppUser> userBox;
  late final Box<UserPreferences> userPreferencesBox;
  UserLocalService({required Store store})
      : userBox = store.box<AppUser>(),
        userPreferencesBox = store.box<UserPreferences>();

  Stream<UserPreferences> listenUserPreferences() {
    return userPreferencesBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find().first);
  }

  AppUser getUser({int? id}) {
    if(id == null){
     return  userBox.getAll().first;
    }else{
      return userBox.get(id) ?? AppUser.empty;
    }
  }

  AppUser getUserByUid(String uid) {
    Query query = userBox.query(AppUser_.uid.equals(uid)).build();
    AppUser user = query.find().first;
    query.close();
    return user;
  }

  List<AppUser> getUsers() {
    return userBox.getAll();
  }

  void addUser(AppUser user) {
    userBox.put(user);
  }

  void updateUser(AppUser user) {
    userBox.put(user, mode: PutMode.update);
  }

  void deleteUser({AppUser? user}) {
    if (user == null) {
      userBox.removeAll();
    } else {
      userBox.remove(user.id);
    }
  }
}
