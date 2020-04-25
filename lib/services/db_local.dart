import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class LocalDatabase {
  LocalDatabase._internal();

  static LocalDatabase get instance => _singleton;

  static final LocalDatabase _singleton = LocalDatabase._internal();

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Future initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    // make sure it exists
    await dir.create(recursive: true);
    final dbPath = join(dir.path, 'cardflows.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    return database;
  }
}
