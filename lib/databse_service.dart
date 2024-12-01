import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:circle/objectbox.g.dart';

import 'features/auth/models/user/user_preferences.dart';

class LocalDatabaseService {
  Store? _store;
  Admin? _admin;

  // Private constructor for Singleton
  LocalDatabaseService._();

  static final LocalDatabaseService _instance = LocalDatabaseService._();

  // Accessor for the singleton instance
  static LocalDatabaseService get instance => _instance;

  // Initialize the database and optionally start the admin
  Future<void> initialize({
    bool startAdmin = kDebugMode,
    int adminPort = 8090,
  }) async {
    if (_store != null) return; //Prevents multiple instances

    try {
      final docsDir = await getApplicationDocumentsDirectory();
      _store = await openStore(directory: p.join(docsDir.path, "circle-db"));
      log("OBJECTBOX STORE INITIALIZED", name: "DATABASE SERVICE");
      if (startAdmin && Admin.isAvailable()) {
        try {
          _admin = Admin(_store!, bindUri: "http://127.0.0.1:$adminPort");
          log("ADMIN STARTED ON PORT: ${_admin!.port}",  name: "DATABASE SERVICE");
        } catch (e) {
          log("FAILED TO START ADMIN: $e",  name: "DATABASE SERVICE");
        }
      }

      //Set the user Preferences
      Box<UserPreferences>? userPreferencesBox = _store?.box<UserPreferences>();
      if(userPreferencesBox == null){
        log("USER PREFERENCES BOX IS NULL",  name: "DATABASE SERVICE");
        log("ADDING PREFRENCES BOX TO DB",  name: "DATABASE SERVICE");
      }

    } catch (e) {
      log("FAILED TO INITIALIZE DATABASE: $e",  name: "DATABASE SERVICE");
      rethrow; // Rethrow so the app knows initialization failed
    }
  }

  // Dispose of resources
  void dispose() {
    try {
      _admin?.close();
      _store?.close();
      log("Database and Admin closed successfully",  name: "DATABASE SERVICE");
    } catch (e, stackTrace) {
      log("Error during database disposal: $e", error: e,  name: "DATABASE SERVICE", stackTrace: stackTrace);
    } finally {
      _store = null;
      _admin = null;
    }
  }

  // Expose the Store
  Store get store {
    if (_store == null) {
      throw StateError("Database not initialized, Call 'initialize()' first");
    }
    return _store!;
  }

  // Check if Admin is running
  bool get isAdminRunning => _admin != null;
}
