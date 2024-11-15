import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:circle/objectbox.g.dart';
import 'features/auth/auth.dart';

class LocalDatabaseService {
  late final Store store;

  LocalDatabaseService._create(this.store) {
    //Todo: Get relevant app data for initialisation, specifically user preferences
  }

  static Future<LocalDatabaseService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "circle-db"));
    return LocalDatabaseService._create(store);
  }

  static dispose(Store store) {
    store.close();
  }
}
