import 'dart:convert';

import 'package:flutter_bookmarks/libraries/zephyr/widgets/controller.dart';
import 'package:flutter_bookmarks/libraries/zephyr/widgets/editor.dart';
import 'package:flutter_bookmarks/libraries/zephyr/widgets/scaffold.dart';
import 'package:flutter_bookmarks/libraries/zephyr/widgets/view.dart';
import 'package:flutter_bookmarks/model/board.dart';
import 'package:flutter_bookmarks/model/item.dart';
import 'package:flutter_bookmarks/provider/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notus/notus.dart';
import 'package:provider/provider.dart';
import 'package:quill_delta/quill_delta.dart';
import 'dart:math' as math;

typedef CardUpdateCallback = void Function(Item board);

class CardEditor extends StatefulWidget {
  final Item card;
  final BoardStyle boardStyle;
  final CardUpdateCallback onUpdate;

  CardEditor({
    Key key,
    this.card,
    this.boardStyle,
    this.onUpdate,
  }) : super(key: key);

  @override
  _CardEditorState createState() => new _CardEditorState();
}

class _CardEditorState extends State<CardEditor> {
  ZefyrController _controller;
  FocusNode _focusNode;
  Item card;
  bool editMode;

  // Grabs text from the first line
  void updateTitle(String value) {
    if (value.indexOf('\n') > 0) {
      card.title = value.substring(0, value.indexOf('\n'));
    } else {
      card.title = value;
    }
  }

  @override
  void initState() {
    card = widget.card;
    if (card.title == null) {
      card.title = "";
    }

    editMode = card.markdownContent == null;

    final document = _loadDocument();
    _controller = ZefyrController(document);
    _controller.addListener(() {
      setState(() {
        String plainText = document.toPlainText();
        updateTitle(plainText);
      });
    });
    _focusNode = FocusNode();
    super.initState();
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    if (card.markdownContent == null) {
      return NotusDocument.fromDelta(Delta()..insert('\n'));
    } else {
      return NotusDocument.fromJson(jsonDecode(card.markdownContent));
    }
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);

    editor() {
      return ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
        ),
      );
    }

    viewOnly() {
      return InkWell(
        onTap: () {
          setState(() {
            editMode = true;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ZefyrView(
              document: _controller.document,
            ),
          ),
        ),
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: widget.boardStyle.appBarColor,
        elevation: 0.2,
        title: Container(
          width: double.infinity,
          child: Text(
            card.title,
            style: TextStyle(
              color: widget.boardStyle.appBarContentColor,
            ),
          ),
        ),
      ),
      body: editMode ? editor() : viewOnly(),
      floatingActionButtonLocation: editMode ? EditCardButtonLocation() : null,
      floatingActionButton: editMode
          ? FloatingActionButton(
              onPressed: () {
                card.markdownContent = jsonEncode(_controller.document);
                widget.onUpdate(card);
              },
              child: Icon(
                Icons.check_circle,
                color: widget.boardStyle.appBarContentColor,
                semanticLabel: "Accept changes",
              ),
              backgroundColor: widget.boardStyle.buttonColor,
            )
          : null,
    );
  }
}

double _leftOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
    {double offset = 0.0}) {
  return kFloatingActionButtonMargin + scaffoldGeometry.minInsets.left - offset;
}

double _rightOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
    {double offset = 0.0}) {
  return scaffoldGeometry.scaffoldSize.width -
      kFloatingActionButtonMargin -
      scaffoldGeometry.minInsets.right -
      scaffoldGeometry.floatingActionButtonSize.width +
      offset;
}

double _endOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
    {double offset = 0.0}) {
  assert(scaffoldGeometry.textDirection != null);
  switch (scaffoldGeometry.textDirection) {
    case TextDirection.rtl:
      return _leftOffset(scaffoldGeometry, offset: offset);
    case TextDirection.ltr:
      return _rightOffset(scaffoldGeometry, offset: offset);
  }
  return null;
}

class EditCardButtonLocation extends FloatingActionButtonLocation {
  const EditCardButtonLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Compute the x-axis offset.
    final double fabX = _endOffset(scaffoldGeometry);

    // Compute the y-axis offset.
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;

    double fabY = contentBottom - fabHeight - kFloatingActionButtonMargin;
    if (snackBarHeight > 0.0)
      fabY = math.min(
          fabY,
          contentBottom -
              snackBarHeight -
              fabHeight -
              kFloatingActionButtonMargin);
    if (bottomSheetHeight > 0.0)
      fabY =
          math.min(fabY, contentBottom - bottomSheetHeight - fabHeight / 2.0);

    return Offset(fabX, fabY - 50);
  }

  @override
  String toString() => 'FloatingActionButtonLocation.endFloat';
}
