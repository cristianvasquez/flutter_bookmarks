import 'dart:developer' as developer;

import 'package:CardFLows/model/pane.dart';
import 'package:CardFLows/provider/user_repository.dart';
import 'package:CardFLows/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _Choice {
  const _Choice({
    this.title,
    this.sucessMessage,
  });
  final String title;
  final String sucessMessage;
}

const _Choice MOVE_LIST = const _Choice(
  title: 'Move list',
  sucessMessage: "List moved sucessfuly",
);
const _Choice COPY_LIST = const _Choice(
  title: 'Copy list',
  sucessMessage: "List copied successfuly",
);
const _Choice DELETE_LIST = const _Choice(
  title: 'Delete list',
  sucessMessage: "List deleted",
);
const _Choice MOVE_CARDS = const _Choice(
  title: 'Move all cards',
  sucessMessage: "Cards moved",
);
const _Choice DELETE_CARDS = const _Choice(
  title: 'Delete all cards',
  sucessMessage: "Cards deleted",
);
const _Choice SORT_BY_DATE = const _Choice(
  title: 'Sort By Date Created (Newest First)',
  sucessMessage: "Cards sorted",
);
const _Choice SORT_BY_DATE_BACKWARDS = const _Choice(
  title: 'Sort By Date Created (Oldest First)',
  sucessMessage: "Cards sorted",
);

const List<_Choice> choices = const <_Choice>[
  MOVE_LIST,
  COPY_LIST,
  DELETE_LIST,
  MOVE_CARDS,
  DELETE_CARDS,
  SORT_BY_DATE,
  SORT_BY_DATE_BACKWARDS,
];

class PaneHeader extends StatefulWidget {
  final Pane pane;
  final Color color;

  final void Function() updateParent;
  const PaneHeader({
    Key key,
    this.pane,
    this.color,
    this.updateParent,
  }) : super(key: key);
  @override
  _PaneHeaderState createState() => _PaneHeaderState();
}

class _PaneHeaderState extends State<PaneHeader> {
  Pane pane;
  bool editMode;

  @override
  void initState() {
    super.initState();
    pane = widget.pane;
    editMode = false;
  }

  @override
  Widget build(BuildContext context) {
    UserRepository service = Provider.of<UserRepository>(context);

    final Color mainColor = widget.color;
    final Color contentColor = getLegibleColor(mainColor);

    Future<void> doChoice(_Choice choice) async {
      if (choice == MOVE_LIST) {
        developer.log("MOVE_LIST");
      } else if (choice == COPY_LIST) {
        developer.log("COPY_LIST");
      } else if (choice == DELETE_LIST) {
        await service.deletePane(pane);
        developer.log("DELETE_LIST");
      } else if (choice == DELETE_LIST) {
        developer.log("DELETE_LIST");
      } else if (choice == MOVE_CARDS) {
        developer.log("MOVE_CARDS");
      } else if (choice == DELETE_CARDS) {
        developer.log("DELETE_CARDS");
      } else if (choice == SORT_BY_DATE) {
        developer.log("SORT_BY_DATE");
      } else if (choice == SORT_BY_DATE_BACKWARDS) {
        developer.log("SORT_BY_DATE_BACKWARDS");
      }
      widget.updateParent();
    }

    Widget text = editMode
        ? TextFormField(
            style: TextStyle(
              color: contentColor,
            ),
            autofocus: true,
            initialValue: pane.name,
            onChanged: (value) {
              pane.name = value;
            },
            onEditingComplete: () {
              setState(() {
                service.updatePane(pane);
                widget.updateParent();
//                widget.onUpdateCallback(pane);
                editMode = false;
              });
            },
          )
        : Text(
            pane.name,
            style: TextStyle(
              color: contentColor,
            ),
          );

    return Card(
      key: ObjectKey(widget.pane.uid),
      elevation: 2.0,
      margin: new EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 6.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: mainColor,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          title: InkWell(
            child: Container(
              width: double.infinity,
              child: text,
            ),
            onTap: () {
              setState(() {
                editMode = true;
              });
            },
          ),
          trailing: PopupMenuButton<_Choice>(
            icon: Icon(
              Icons.more_vert,
              color: contentColor,
            ),
            onSelected: (_Choice choice) async {
              Widget snackBar = SnackBar(
                backgroundColor: mainColor,
                duration: Duration(seconds: 2),
                content: Text(
                  choice.sucessMessage,
                  style: TextStyle(
                    color: contentColor,
                  ),
                ),
              );

              await doChoice(choice);
              setState(() {
                Scaffold.of(context).showSnackBar(snackBar);
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                ...choices.map((_Choice choice) {
                  return PopupMenuItem<_Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList()
              ];
            },
          ),
        ),
      ),
    );
  }
}

class PaneHeaderStatic extends StatelessWidget {
  final Pane pane;
  final Color color;

  const PaneHeaderStatic({
    Key key,
    this.pane,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color contentColor = getLegibleColor(color);

    return Card(
      key: ObjectKey(pane.uid),
      elevation: 2.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          title: Text(
            pane.name,
            style: TextStyle(color: contentColor),
          ),
        ),
      ),
    );
  }
}
