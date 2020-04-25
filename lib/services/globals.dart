import 'package:CardFLows/model/board.dart';
import 'package:CardFLows/model/item.dart';
import 'package:CardFLows/model/pane.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Static global state. Immutable services that do not care about build context.
class Global {
  // App Data
  static final String title = 'Fireship';

  // Services
  static final FirebaseAnalytics analytics = FirebaseAnalytics();

  // Data Models
  static final Map models = {
//    Workspace: (data) => Workspace.fromMap(data),
    Board: (data) => Board.fromMap(data),
    Item: (data) => Item.fromMap(data),
    Pane: (data) => Pane.fromMap(data),
  };

  // Firestore references for write
//  static final UserData<Workspace> workspaceRef =
//      UserData<Workspace>(collection: 'workspaces');
}
