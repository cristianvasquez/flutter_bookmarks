//# Pane
//
//A Pane instance belongs to one and only one board,
//
//This is the unit that allows to represent the state of a card within a Board.
//A very simple state, like Todo, in progress and DONE.
//
//## Operations:
//
//Drag the pane to other position within the board.
//Move the pane to another board, with all the cards it contains.
//Clone the pane into other board, with all contents.
//Move all contents into the pane of another board.
//Archive the pane with all contents.
//
//Archive all contents.
//
//Sort cards by due date.
//Sort cards by date created (newest first).
//Sort cards by date created (oldest first).
//
//## Representation
//
//For simplicity a pane presents all its cards in the same way. (? I'm not sure though)
//Cards are ordered, therefore can be presented as a list.
//In the case of trello, they are blocks of cards forming the kanban.
//In the case of Hypercard, this is the CardStack.

import 'package:CardFLows/model/resource.dart';

import 'item.dart';

const String PANE_TYPE_DEFAULT = "DEFAULT";
const String PANE_TYPE_LANDING_ZONE = "LANDING_ZONE";

class Pane extends Resource {
  String name;
  String type;
  List<Item> items;

  Pane({
    String uid,
    this.name,
    this.type,
    this.items,
  }) : super(uid);

  factory Pane.fromMap(Map data) {
    return Pane(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      type: data['type'] ?? PANE_TYPE_DEFAULT,
      items: (data['items'] as List ?? [])
          .map((v) => Item.fromMap(v))
          .toList(), //data['quizzes'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = uid;
    data['name'] = name;
    data['type'] = type;

    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJsonMap()).toList();
    }
    return data;
  }
}
