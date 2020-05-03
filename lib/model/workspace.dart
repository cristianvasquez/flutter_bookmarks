import 'package:flutter_bookmarks/model/board.dart';

class Workspace {
  List<Board> boards;
  String uid;

  Workspace({this.boards, this.uid});

  // Serialization
  factory Workspace.fromMap(Map data) {
    return Workspace(
      uid: data['uid'],
      boards:
          (data['boards'] as List ?? []).map((v) => Board.fromMap(v)).toList(),
    );
  }

  Map<String, dynamic> toJsonMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (null != uid) {
      data['uid'] = uid;
    }

    if (this.boards != null) {
      data['boards'] = this.boards.map((v) => v.toJsonMap()).toList();
    }
    return data;
  }
}
