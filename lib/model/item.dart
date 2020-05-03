import 'dart:convert';

import 'package:flutter_bookmarks/model/defaults.dart';
import 'package:notus/notus.dart';
import 'package:quill_delta/quill_delta.dart';

import 'resource.dart';

/// # Item
//
// Can be shown in a card, a sheet of Material used to represent some related information,
// for example an album, a geographical location, a meal, contact details, etc.
//
//## Description
//
//    A Item is the smallest unit of work that's traceable.
//    A Item can be versioned through GIT. It can be forked and merged
//    A Item (or instead the place?) can have behavior, handle events. (can be programmed).
//    This could be simply a 'button', a item in a place that looks like button.
//
//## Model
//
//    A item belongs to one and only one place, in a specified position within that place.
//    A user can add an item to a a board without specifying the place, in that case it lands into the default.
//
//## Operations:
//
//    1. Move the item to other place, in a specified position. This place can belong to other board.
//    2. Share the item link.
//    3. Full CRUD
//
//## Representation:
//
//    A item follows the notion of document, all that is stored in it persists instantaneously.
//
//    It can can have arbitrary properties:
//    Labels, tags, or cues, a scheduled event, multiple checklists, texts and images.
//
//    There are no wizards to create items, they usually are cloned from somewhere else, acting as a default.
//    The user simply starts editing, for example you click the text and you change it.
//
//    The item can be represented internally as RDF, and might follow rules.
//    A item can be placed with other items, in places.
class Item extends Resource {
  String title;
  String photoUri;
  String markdownContent;

  Item({
    this.title,
    this.photoUri,
    this.markdownContent,
    String uid,
  }) : super(uid);

  factory Item.fromText(String text) {
    String getNotusText(String content) {
      return jsonEncode(NotusDocument.fromDelta(Delta()..insert(content)));
    }

    return Item(
      uid: random.v4(),
      title: text,
      markdownContent: getNotusText("$text\n"),
    );
  }

  factory Item.fromMap(Map data) {
    return Item(
        uid: data['uid'],
        title: data['title'],
        photoUri: data['photoUri'],
        markdownContent: data['markdownContent']);
  }

  Map<String, dynamic> toJsonMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = uid;

    if (title != null) {
      data['title'] = title;
    }

    if (photoUri != null) {
      data['photoUri'] = photoUri;
    }

    if (markdownContent != null) {
      data['markdownContent'] = markdownContent;
    }

    return data;
  }
}
