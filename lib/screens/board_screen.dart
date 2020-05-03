import 'dart:math';

import 'package:flutter_bookmarks/main.dart';
import 'package:flutter_bookmarks/model/board.dart';
import 'package:flutter_bookmarks/model/defaults.dart';
import 'package:flutter_bookmarks/model/icons/all_icons.dart';
import 'package:flutter_bookmarks/provider/user_repository.dart';
import 'package:flutter_bookmarks/screens/boards/board.dart';
import 'package:flutter_bookmarks/util/colors.dart';
import 'package:flutter_bookmarks/widgets/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'boards/board_edit.dart';

class BoardsScreen extends StatefulWidget {
  @override
  _BoardsScreenState createState() => _BoardsScreenState();
}

class _BoardsScreenState extends State<BoardsScreen> {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);
    MediaQueryData mqd = MediaQuery.of(context);

    // The size of each Icon
    double iconSize = mqd.orientation == Orientation.portrait
        ? mqd.size.width / 4
        : mqd.size.width / 6;

    double spacing = mqd.size.width * 0.075;
    double runSpacing = mqd.size.width * 0.025;

    addNewBoard() async {
      Board board = Defaults.newBoard();
      if (board.color == null) {
        final _random = new Random();
        board.color = materialColors[_random.nextInt(materialColors.length)];
      }
      if (board.icon == null) {
        board.icon = randomIcon();
      }
      await showModalBottomSheet(
          context: context,
          builder: (context) => Container(
                child: NewBoard(
                  board: board,
                ),
              ));
      setState(() {
        // For some mysterious reason, provider is not triggering with the change notifiers.
        // @TODO remove this when figuring out the reason.
      });
    }

    buildBoardList() {
      if (userRepository != null) {
        return Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: spacing,
                    runSpacing: runSpacing,
                    children:
                        userRepository.workspace.boards // The list of boards
                            .map((Board board) => InkWell(
                                  onTap: () async {
                                    await doPush(
                                        context, BoardScreen(board: board));
                                    setState(() {
                                      // For some mysterious reason, provider is not triggering with the change notifiers.
                                      // @TODO remove this when figuring out the reason.
                                    });
                                  },
                                  child: BoardIcon(
                                    key: ObjectKey(board.uid),
                                    board: board,
                                    size: iconSize,
                                  ),
                                ))
                            .toList(),
                  ),
                ),
              ),
            )
          ],
        );
      } else {
        return CircularProgressIndicator();
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Your boards",
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: addNewBoard,
            ),
          ]),
      body: buildBoardList(),
    );
  }
}
