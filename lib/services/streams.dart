//import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bookmarks/model/defaults.dart';
import 'package:flutter_bookmarks/model/workspace.dart';
import 'package:flutter_bookmarks/provider/user_repository.dart';
import 'package:flutter_bookmarks/services/db_local.dart';
import 'package:sembast/sembast.dart';

const int USER_ID = 42;

Future<UserRepository> getUserRepository() async {
  final StoreRef workspaceStore = StoreRef.main();

  Database db = await LocalDatabase.instance.db;
  var map = await workspaceStore.record(USER_ID).get(db) as Map;
  if (map == null) {
    developer.log('Loading defaults for user ${USER_ID}',
        name: 'cardflows.user');

    return UserRepository(
      Defaults.defaultWorkspace(),
      workspaceStore,
    );
  } else {
    developer.log('Loading existing data for user: ${USER_ID}',
        name: 'cardflows.user');
    return UserRepository(
      Workspace.fromMap(map),
      workspaceStore,
    );
  }
}

//
//import 'package:flutter_bookmarks/model/defaults.dart';
//import 'package:flutter_bookmarks/model/workspace.dart';
//import 'package:flutter_bookmarks/provider/user_repository.dart';
//import 'package:flutter_bookmarks/services/db_local.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:sembast/sembast.dart';
//
//class Streams {
//  final FirebaseAuth _auth = FirebaseAuth.instance;
//  final StoreRef workspaceStore = StoreRef.main();
//
//  // Streams different users depending on who is logged in.
//  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;
//
//  // Streams different providers depending on who is logged in.
//  Stream<UserRepository> get workspace => applicationProviderStream(user);
//
//  Stream<UserRepository> applicationProviderStream(
//      Stream<FirebaseUser> source) async* {
//    await for (var user in source) {
//      if (user == null) {
//        developer.log('No user logged in', name: 'cardflows.user');
//        yield null;
//      } else {
//        Database db = await LocalDatabase.instance.db;
//        var map = await workspaceStore.record(user.uid).get(db) as Map;
//
//        if (map == null) {
//          developer.log('Loading defaults for user ${user.uid}',
//              name: 'cardflows.user');
//          try {
//            yield UserRepository(
//              Defaults.defaultWorkspace(),
//              workspaceStore,
//            );
//          } catch (e) {
//            print(e);
//          }
//        } else {
//          developer.log('Loading existing data for user${user.uid}',
//              name: 'cardflows.user');
//
//          yield UserRepository(
//            Workspace.fromMap(map),
//            workspaceStore,
//          );
//        }
//      }
//    }
//  }
//}
