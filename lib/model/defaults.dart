import 'package:flutter/material.dart';
import 'package:flutter_bookmarks/model/board.dart';
import 'package:flutter_bookmarks/model/icons/named_icon.dart';
import 'package:flutter_bookmarks/model/item.dart';
import 'package:flutter_bookmarks/model/pane.dart';
import 'package:flutter_bookmarks/model/workspace.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

Uuid random = Uuid();

class Defaults {
  static Workspace defaultWorkspace() {
    Workspace result = Workspace();
    result.boards = defaultBoards();
    result.uid = random.v4();
    return result;
  }

  static List<Board> defaultBoards() {
    return [
      Board(
          uid: random.v4(),
          name: "Welcome Board",
          color: Colors.teal,
          icon: NamedIcon(FontAwesomeIcons.inbox, "inbox"),
          panes: [
            Pane(
                uid: random.v4(),
                name: "Stuff to Try (this is a list)\n",
                type: PANE_TYPE_LANDING_ZONE,
                items: [
                  Item.fromText(
                      "This is a card. Drag it into \"Tried it\" to show it's done"),
                  Item.fromText(
                      "Cards do many cool things. Click on this card to open and learn more"),
                  Item.fromText("Add all the cards and lists you need"),
                  Item.fromText(
                      "Add members to a board (through the sidebar) to collaborate, share and discuss"),
                ]),
            Pane(
              type: PANE_TYPE_DEFAULT,
              uid: random.v4(),
              name: "Tried it (this is another list)",
              items: [
                Item.fromText("Cards can be moved back also"),
              ],
            ),
          ])
    ];
  }

  static String tutorial_markdown_data = """
# Markdown Example
Markdown allows you to easily include formatted text, images, and even formatted Dart code in your app.

## Titles

Setext-style

```
This is an H1
=============

This is an H2
-------------
```

Atx-style

```
# This is an H1

## This is an H2

###### This is an H6
```

Select the valid headers:

- [x] `# hello`
- [ ] `#hello`

## Links

[Google's Homepage][Google]

```
[inline-style](https://www.google.com)

[reference-style][Google]
```

## Images

![Flutter logo](/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png)

## Tables

|Syntax                                 |Result                               |
|---------------------------------------|-------------------------------------|
|`*italic 1*`                           |*italic 1*                           |
|`_italic 2_`                           | _italic 2_                          |
|`**bold 1**`                           |**bold 1**                           |
|`__bold 2__`                           |__bold 2__                           |
|`This is a ~~strikethrough~~`          |This is a ~~strikethrough~~          |
|`***italic bold 1***`                  |***italic bold 1***                  |
|`___italic bold 2___`                  |___italic bold 2___                  |
|`***~~italic bold strikethrough 1~~***`|***~~italic bold strikethrough 1~~***|
|`~~***italic bold strikethrough 2***~~`|~~***italic bold strikethrough 2***~~|

## Styling
Style text as _italic_, __bold__, ~~strikethrough~~, or `inline code`.

- Use bulleted lists
- To better clarify
- Your points

## Code blocks
Formatted Dart code looks really pretty too:

```
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Markdown(data: markdownData),
    ),
  ));
}
```

## Markdown widget

This is an example of how to create your own Markdown widget:

    Markdown(data: 'Hello _world_!');

Enjoy!

[Google]: https://www.google.com/
""";

  static newBoard() {
    return new Board(
      uid: random.v4(),
      name: "New board",
      panes: [
        newPane(),
      ],
    );
  }

  Item newItem() {
    return new Item(
      uid: random.v4(),
//      contents: "New card",
    );
  }

  static newPane() {
    return Pane(
      type: PANE_TYPE_DEFAULT,
      uid: random.v4(),
      name: "New List",
      items: [],
    );
  }

  static defaultPane() {
    return Pane(
      uid: random.v4(),
      name: "Landing ",
    );
  }
}

List<Board> testCardSpaces = [
  Board(
    icon: NamedIcon(FontAwesomeIcons.inbox, "inbox"),
    name: "Landing zone",
  ),
  Board(
    icon: NamedIcon(FontAwesomeIcons.chalkboardTeacher, "chalkboardTeacher"),
    name: "Courses",
  ),
  Board(
    icon: NamedIcon(FontAwesomeIcons.lightbulb, "lightbulb"),
    name: "Ideas",
  ),
  Board(
    icon: NamedIcon(FontAwesomeIcons.film, "film"),
    name: "Films",
  ),
  Board(
    icon: NamedIcon(FontAwesomeIcons.futbol, "futbol"),
    name: "Sports",
  ),
  Board(
    icon: NamedIcon(FontAwesomeIcons.briefcase, "briefcase"),
    name: "Work",
  ),
  Board(
    icon: NamedIcon(FontAwesomeIcons.beer, "beer"),
    name: "Beer catalog",
  ),
  Board(
    icon: NamedIcon(FontAwesomeIcons.smileBeam, "smileBeam"),
    name: "Fun",
  ),
];

List<Board> testBoards = [
  Board(
      icon: NamedIcon(FontAwesomeIcons.flagCheckered, "flagCheckered"),
      name: "Tasks to finish"),
  Board(
      icon: NamedIcon(FontAwesomeIcons.heartbeat, "heartbeat"), name: "Health"),
  Board(
      icon: NamedIcon(FontAwesomeIcons.birthdayCake, "birthdayCake"),
      name: "Birthday"),
  Board(icon: NamedIcon(FontAwesomeIcons.book, "book"), name: "Books"),
  Board(
      icon: NamedIcon(FontAwesomeIcons.moneyBillWave, "moneyBillWave"),
      name: "Money"),
  Board(icon: NamedIcon(FontAwesomeIcons.at, "at"), name: "Emails"),
  Board(
      icon: NamedIcon(FontAwesomeIcons.balanceScale, "balanceScale"),
      name: "Legal"),
  Board(
      icon: NamedIcon(FontAwesomeIcons.earlybirds, "earlybirds"),
      name: "Learning"),
  Board(
      icon: NamedIcon(FontAwesomeIcons.kiwiBird, "kiwiBird"),
      name: "Pretty kiwi bird"),
  Board(
      icon: NamedIcon(FontAwesomeIcons.rocket, "rocket"),
      name: "Arrive to mars"),
  Board(
      icon: NamedIcon(FontAwesomeIcons.optinMonster, "optinMonster"),
      name: "Monster related"),
  Board(
      icon: NamedIcon(FontAwesomeIcons.babyCarriage, "babyCarriage"),
      name: "Baby"),
];
