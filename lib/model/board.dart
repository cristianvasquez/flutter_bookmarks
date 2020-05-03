import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookmarks/model/icons/named_icon.dart';
import 'package:flutter_bookmarks/util/colors.dart';
import 'package:flutter_bookmarks/util/util.dart';

import 'pane.dart';
import 'resource.dart';

// # Workspace
//
//    Contains all the boards of the user,
//    It's always up to the user.
//
//    A board can be in control of many users, at least one.
//    A board might have a default 'landing' pane.
//    A board can have rules that affect all the panes. (Follows the concept of background of Hypercard).
//
//    A board can be cloned from the Web, following the concept of package.
//
//## Operations:
//
//    - Shows  activity of the members
//    - Inspect archived cards
//    - Inspect archived panes
//
//## Properties
//
//    - A name
//    - An owner account
//    - A context color, icon color, background color or background image
//    - Others, such as visibility (public, private)
//
//## Visuals
//
//    A board presents the places in several configurations. One example is a Kanban board
//    If panes are not evident, there must be a cues that highlight hotspots for those panes.
//    It can have a photo assigned, if the user wants to customize it.

class BoardStyle {
  final Color appBarColor;
  final Color appBarContentColor;
  final Color paneHeaderColor;
  final Color buttonColor;
  final Color iconColor;
  final Color backgroundColor;
  final Color paneBackgroundColor;
  final Color cardColor;

  BoardStyle({
    this.appBarColor,
    this.appBarContentColor,
    this.paneHeaderColor,
    this.buttonColor,
    this.iconColor,
    this.backgroundColor,
    this.paneBackgroundColor,
    this.cardColor,
  });

  factory BoardStyle.fromColorSwatch(Color color) {
    return BoardStyle(
      appBarColor: darkerColor(getColorShades(color)[8], 0.1),
      appBarContentColor:
          getLegibleColor(darkerColor(getColorShades(color)[8], 0.1)),
      paneHeaderColor:
          darkerColor(getColorShades(color)[4], 0.2).withOpacity(0.7),
      buttonColor: getColorShades(color)[8],
      iconColor: getLegibleColor(getColorShades(color)[8]),
      backgroundColor: getColorShades(color)[0],
      paneBackgroundColor:
          darkerColor(getColorShades(color)[1], 0.6).withOpacity(0.5),
      cardColor: getColorShades(color)[1].withOpacity(0.5),
    );
  }
}

class Board extends Resource {
  String name;
  NamedIcon icon;
  ColorSwatch color;
  List<Pane> panes;
  String backgroundUri;

  Board({
    this.name,
    this.icon,
    this.color,
    this.panes,
    this.backgroundUri,
    String uid,
  }) : super(uid) {
    if (panes == null) {
      panes = [];
    }
  }

  // Representation

  factory Board.fromMap(Map data) {
    return Board(
      uid: data['uid'],
      name: data['name'] ?? '',
      icon: NamedIcon.fromMap(data['icon']) ?? '',
      color: findSwatch(data['color']) ?? null,
      panes: (data['panes'] as List ?? []).map((v) => Pane.fromMap(v)).toList(),
      backgroundUri: data['backgroundUri'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = uid;
    data['name'] = name;
    data['icon'] = icon != null ? icon.toJsonMap() : null;
    data['color'] = color.value;
    if (this.panes != null) {
      data['panes'] = this.panes.map((v) => v.toJsonMap()).toList();
    }
    if (this.backgroundUri != null) {
      data['backgroundUri'] = backgroundUri;
    }
    return data;
  }

  Pane getPaneById(String id) {
    return panes.firstWhere((Pane pane) {
      return pane.uid == id;
    });
  }

  bool removeItemById(String id) {
    for (Pane pane in panes) {
      for (int i = 0; i < pane.items.length; i++) {
        if (pane.items[i].uid == id) {
          return pane.items.remove(pane.items[i]);
        }
      }
    }
    return false;
  }

  void swapPanes(Pane pane, Pane incomingPane) {
    Pane row = panes.removeAt(panes.indexOf(pane));
    panes.insert(panes.indexOf(incomingPane), row);
  }
}
