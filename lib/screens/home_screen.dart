import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bookmarks/main.dart';
import 'package:flutter_bookmarks/model/board.dart';
import 'package:flutter_bookmarks/model/defaults.dart';
import 'package:flutter_bookmarks/model/item.dart';
import 'package:flutter_bookmarks/model/pane.dart';
import 'package:flutter_bookmarks/provider/user_repository.dart';
import 'package:flutter_bookmarks/screens/boards/board.dart';
import 'package:flutter_bookmarks/screens/boards/card/card_editor.dart';
import 'package:flutter_bookmarks/screens/boards/pane/pane.dart';
import 'package:flutter_bookmarks/widgets/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile> _sharedFiles;
  String _sharedText;
  Board targetBoard;
  Pane targetPane;

  @override
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        developer.log(
            "Shared:" + (_sharedFiles?.map((f) => f.path)?.join(",") ?? ""));
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        developer.log(
            "Shared:" + (_sharedFiles?.map((f) => f.path)?.join(",") ?? ""));
      });
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
        developer.log("Shared: $_sharedText");
      });
    }, onError: (err) {
      developer.log("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      setState(() {
        _sharedText = value;
        developer.log("Shared: $_sharedText");
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);
    MediaQueryData mqd = MediaQuery.of(context);

//    double iconSize = mqd.orientation == Orientation.portrait
//        ? mqd.size.width / 4
//        : mqd.size.width / 6;

    double iconSize = 130;

    if (_sharedText != null) {
      List<Board> boards = userRepository.getBoards();

      if (targetBoard == null) {
        targetBoard = boards[0];
      }

      List<Pane> panes = userRepository.getPanes(targetBoard);

      if (targetPane == null) {
        targetPane = panes[0];
      }

      void selectPane(Pane pane) {
        targetPane = pane;
      }

      selectBoard(Board board) {
        targetBoard = board;
        panes = targetBoard.panes;
        selectPane(board.panes[0]);
      }

      final BoardStyle boardStyle =
          BoardStyle.fromColorSwatch(targetBoard.color);
      Item item = Item.fromText(_sharedText);

      return Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: boards
                        .map((Board board) => InkWell(
                              onTap: () async {
                                setState(() {
                                  selectBoard(board);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 0),
                                child: BoardIcon(
                                  iconState: targetBoard.uid == board.uid
                                      ? BoardState.selected
                                      : BoardState.unselected,
                                  key: ObjectKey(board.uid),
                                  board: board,
                                  size: targetBoard.uid == board.uid
                                      ? iconSize * 1.1
                                      : iconSize,
                                ),
                              ),
                            ))
                        .toList(),
                  )),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: panes
                        .map((Pane pane) => InkWell(
                              onTap: () async {
                                setState(() {
                                  selectPane(pane);
                                });
                              },
                              child: Container(
                                width: 200,
                                child: Opacity(
                                  opacity: pane.uid == targetPane.uid ? 0.7 : 1,
                                  child: PaneHeaderStatic(
                                    pane: pane,
                                    color: boardStyle.paneHeaderColor,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  )),
            ),
            SizedBox(height: 50),
            Expanded(
              flex: 10,
              child: CardEditor(
                boardStyle: boardStyle,
                card: item,
                onUpdate: (Item item) => {developer.log("Updated")},
              ),
            ),
          ],
        ),
      );
    } else {
      return Text("Home");
    }
  }
}
