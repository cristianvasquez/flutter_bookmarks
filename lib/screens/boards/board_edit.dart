import 'package:CardFLows/main.dart';
import 'package:CardFLows/model/board.dart';
import 'package:CardFLows/model/icons/named_icon.dart';
import 'package:CardFLows/provider/user_repository.dart';
import 'package:CardFLows/screens/boards/board.dart';
import 'package:CardFLows/widgets/icons.dart';
import 'package:CardFLows/widgets/pickers/icon_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';

typedef BoardUpdateCallback = void Function(Board board);

class EditBoard extends StatelessWidget {
  final board;

  EditBoard({Key key, this.board}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserRepository service = Provider.of<UserRepository>(context);

    return _BoardSettings(
      board: board,
      onUpdate: (Board board) {
        service.updateBoard(board);
        Navigator.of(context).pop(board);
      },
      buttonText: "Update",
    );
  }
}

class NewBoard extends StatelessWidget {
  final board;

  NewBoard({Key key, this.board}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);

    return _BoardSettings(
      board: board,
      onUpdate: (Board board) {
        userRepository.addNewBoard(board);
        Navigator.of(context).pop(board);

        doPush(
            context,
            BoardScreen(
              board: board,
            ));
      },
      buttonText: "Create",
    );
  }
}

class _BoardSettings extends StatefulWidget {
  final Board board;
  final String buttonText;
  BoardUpdateCallback onUpdate;

  _BoardSettings({Key key, this.board, this.onUpdate, this.buttonText})
      : super(key: key);

  @override
  _BoardSettingsState createState() => _BoardSettingsState();
}

class _BoardSettingsState extends State<_BoardSettings> {
  final _formKey = GlobalKey<FormState>();

  Board board;
  @override
  void initState() {
    super.initState();
    board = widget.board;
  }

  @override
  Widget build(BuildContext context) {
    buildColorPicker() {
      return MaterialColorPicker(
        onlyShadeSelection: true,
        selectedColor: board.color,
        onMainColorChange: (ColorSwatch color) {
          setState(() => board.color = color);
        },
      );
    }

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: TextFormField(
                  initialValue: board.name,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Needs a name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    board.name = value;
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SingleChildScrollView(
                        child: InkWell(
                      child: BoardIcon(
                        board: widget.board,
                      ),
                      onTap: () async {
                        NamedIcon selectedIcon = await Navigator.of(context)
                            .push(MaterialPageRoute(builder: (cxt) {
                          return MyTheme(
                            child: IconPicker(selectedIcon: board.icon),
                          );
                        }));
                        setState(() {
                          if (selectedIcon != null) {
                            board.icon = selectedIcon;
                          }
                        });
                      },
                    )),
                    Expanded(
                      child: buildColorPicker(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await widget.onUpdate(board);
                    }
                  },
                  child: Text('${widget.buttonText}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
