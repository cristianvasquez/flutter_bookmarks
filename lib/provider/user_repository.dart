import 'dart:async';

import 'package:CardFLows/model/board.dart';
import 'package:CardFLows/model/defaults.dart';
import 'package:CardFLows/model/item.dart';
import 'package:CardFLows/model/pane.dart';
import 'package:CardFLows/model/workspace.dart';
import 'package:CardFLows/services/auth.dart';
import 'package:CardFLows/services/db_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sembast/sembast.dart';
import 'dart:developer' as developer;

class UserRepository extends ChangeNotifier {
  Workspace _workspace;
  StoreRef workspaceStore;

  UserRepository(this._workspace, this.workspaceStore);

  Workspace get workspace {
    return _workspace;
  }

  getBoards() {
    return _workspace.boards;
  }

  getPanes(Board board) {
    for (Board current in _workspace.boards) {
      if (board.uid == current.uid) {
        return current.panes;
      }
    }
  }

  Future<void> _update(Workspace _workspace) async {
    Database db = await LocalDatabase.instance.db;
    FirebaseUser user = await AuthService().getUser;
    await workspaceStore.record(user.uid).put(db, _workspace.toJsonMap());
  }

  /// Resets all data from the workspace to the default values
  Future<void> setDefaults() async {
    _workspace = Defaults.defaultWorkspace();
    await _update(_workspace);
    notifyListeners();
  }

  Future<void> addNewPane(Board targetBoard, Pane pane) async {
    for (Board board in _workspace.boards) {
      if (board.uid == targetBoard.uid) {
        board.panes.add(pane);
        developer.log("Adding pane ${pane.uid} to board ${board.uid}");
        await _update(_workspace);
        notifyListeners();
      }
    }
  }

  Future<void> swapPanes(Board targetBoard, Pane pane, Pane incoming) async {
    for (Board board in _workspace.boards) {
      if (board.uid == targetBoard.uid) {
        board.swapPanes(pane, incoming);
        developer.log("Swapping pane ${pane.uid} with ${incoming.uid}");
        await _update(_workspace);
        notifyListeners();
      }
    }
  }

  Future<void> addNewBoard(Board board) async {
    _workspace.boards.add(board);
    await _update(_workspace);
    notifyListeners();
  }

  Future<void> updateBoard(Board board) async {
    _workspace.boards[_workspace.boards.indexOf(board)] = board;
    await _update(_workspace);
    notifyListeners();
  }

  moveCard(Item item, Pane targetPane, targetPosition) async {
    for (Board board in _workspace.boards) {
      for (Pane pane in board.panes) {
        if (pane.items.contains(item)) {
          // Remove it
          board.removeItemById(item.uid);
          // Add it in position
          for (Board board in _workspace.boards) {
            for (Pane pane in board.panes) {
              if (pane.uid == targetPane.uid) {
                if (pane.items.length > targetPosition) {
                  pane.items.insert(targetPosition, item);
                } else {
                  pane.items.add(item);
                }
                developer.log(
                    'Put ${item.uid} into pane ${targetPane.uid} into position ${targetPosition}');
                await _update(_workspace);
                notifyListeners();
                return;
              }
            }
          }
        }
      }
    }
  }

  Future<void> updatePane(Pane pane) async {
    for (Board board in _workspace.boards) {
      if (board.panes.contains(pane)) {
        board.panes[board.panes.indexOf(pane)] = pane;
        await _update(_workspace);
        notifyListeners();
        return;
      }
    }
  }

  Future<void> deletePane(Pane pane) async {
    for (Board board in _workspace.boards) {
      if (board.panes.contains(pane)) {
        board.panes.remove(pane);
        await _update(_workspace);
        notifyListeners();
        return;
      }
    }
    throw ("Pane ${pane.uid} not deleted");
  }

  Future<void> updateCard(Item item) async {
    for (Board board in _workspace.boards) {
      for (Pane pane in board.panes) {
        if (pane.items.contains(item)) {
          pane.items[pane.items.indexOf(item)] = item;
          await _update(_workspace);
          notifyListeners();
          return;
        }
      }
    }
    throw ("Item ${item.uid} not deleted");
  }

  Future<void> addCard(Pane targetPane, Item item) async {
    for (Board board in _workspace.boards) {
      for (Pane pane in board.panes) {
        if (pane.uid == targetPane.uid) {
          pane.items.add(item);
          developer.log("Adding item ${item.uid} to pane ${targetPane.uid}");
          await _update(_workspace);
          notifyListeners();
          return;
        }
      }
    }
  }

  Future<void> deleteCard(Item item) async {
    for (Board board in _workspace.boards) {
      for (Pane pane in board.panes) {
        if (pane.items.contains(item)) {
          developer.log("Deleting item ${item.uid}");
          pane.items.removeAt(pane.items.indexOf(item));
          await _update(_workspace);
          notifyListeners();
          return;
        }
      }
    }
  }
}

class LandingZone {
  final Board board;
  final Pane pane;

  LandingZone(this.board, this.pane);
}
