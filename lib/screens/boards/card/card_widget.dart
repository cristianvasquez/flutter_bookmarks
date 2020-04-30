import 'package:CardFLows/main.dart';
import 'package:CardFLows/model/board.dart';
import 'package:CardFLows/model/item.dart';
import 'package:CardFLows/screens/boards/card/card_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Item card;
  final String leading;
  final BoardStyle boardStyle;
  final CardUpdateCallback onUpdate;

  const CardWidget(
      {Key key, this.card, this.leading, this.boardStyle, this.onUpdate})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final BoxDecoration decoration = card.photoUri == null
        ? BoxDecoration(
            color: boardStyle.cardColor,
          )
        : BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(card.photoUri),
              fit: BoxFit.cover,
            ),
          );

    return Card(
      key: ObjectKey(card.uid),
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 6.0,
      ),
      child: Container(
        decoration: decoration,
        child: ListTile(
          onTap: () async {
            await doPush(
                context,
                CardEditor(
                  card: card,
                  boardStyle: boardStyle,
                  onUpdate: onUpdate,
                ));
          },
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          leading: leading != null
              ? Container(
                  padding: const EdgeInsets.only(
                    right: 12.0,
                  ),
                  decoration: const BoxDecoration(
                      border: const Border(
                    right: const BorderSide(
                      width: 1.0,
                      color: Colors.white24,
                    ),
                  )),
                  child: Text("$leading"),
                )
              : null,
          title: Text(
            card.title != null ? card.title : "",
          ),
//          trailing: Icon(
//            Icons.drag_handle,
////            color: Colors.white,
//            size: 30.0,
//          ),
        ),
      ),
    );
  }
}
