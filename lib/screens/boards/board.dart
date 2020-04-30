import 'package:CardFLows/main.dart';
import 'package:CardFLows/model/board.dart';
import 'package:CardFLows/model/images.dart';
import 'package:CardFLows/provider/user_repository.dart';
import 'package:CardFLows/screens/boards/board_edit.dart';
import 'package:CardFLows/screens/boards/kanban_board.dart';
import 'package:CardFLows/widgets/pickers/background_image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class BoardScreen extends StatefulWidget {
  final Board board;

  const BoardScreen({Key key, this.board}) : super(key: key);

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  Board board;
  bool titleEditMode;

  @override
  void initState() {
    super.initState();
    board = widget.board;
    titleEditMode = false;
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);

    final BoardStyle boardStyle = BoardStyle.fromColorSwatch(board.color);

    Widget text = titleEditMode
        ? TextFormField(
            style: TextStyle(
              color: boardStyle.appBarContentColor,
            ),
            autofocus: true,
            initialValue: board.name,
            onChanged: (value) {
              board.name = value;
            },
            onEditingComplete: () {
              setState(() {
                userRepository.updateBoard(board);
                titleEditMode = false;
              });
            },
          )
        : Text(
            board.name,
            style: TextStyle(
              color: boardStyle.appBarContentColor,
            ),
          );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: boardStyle.appBarColor,
        iconTheme: IconThemeData(
          color: boardStyle.appBarContentColor,
        ),
        elevation: 0.1,
        title: InkWell(
          child: Container(
            width: double.infinity,
            child: text,
          ),
          onTap: () {
            setState(() {
              titleEditMode = true;
            });
          },
        ),
      ),
      endDrawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text("Icons and color"),
            onTap: () async {
              Navigator.of(context).pop();
              Board result = await showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                        child: EditBoard(
                          board: board,
                        ),
                      ));
              if (result != null) {
                setState(() {
                  board = result;
                });
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text("Background"),
            onTap: () async {
              Navigator.of(context).pop();
              SplashImage selectedImage = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (cxt) {
                return MyTheme(
                  child: SplashImagePicker(),
                );
              }));
              setState(() {
                if (selectedImage != null) {
                  board.backgroundUri = selectedImage.medium();
                }
              });
            },
          )
        ],
      )),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: board.backgroundUri != null
            ? new BoxDecoration(
                image: new DecorationImage(
                    image: new NetworkImage(
                      "${board.backgroundUri}",
                    ),
                    fit: BoxFit.cover),
              )
            : null,
        child: KanbanBoard(board: widget.board),
      ),
    );
  }
}
