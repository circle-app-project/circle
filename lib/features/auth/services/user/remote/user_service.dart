import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../auth.dart';

class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///----Get User Data--------///
  Future<AppUser> getUserData(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('users').doc(uid).get();

    if (snapshot.exists &&
        snapshot.data() != null &&
        snapshot.data()!.isNotEmpty) {
      AppUser remoteUser = AppUser.fromMap(data: snapshot.data()!);
      return remoteUser;
    } else {
      throw AppException( message: "App user doesn't exist", type: ExceptionType.firebase, stackTrace: StackTrace.current);
    }

  }

  ///--------Add and Update User Data--------///
  Future<void> addUserData(AppUser user) async {
    await firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<void> updateUserData(AppUser user) async {
    await firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  ///-----Delete -----///
  Future<void> deleteUserData(String uid) async {
    await firestore.collection("users").doc(uid).delete();
  }
}
