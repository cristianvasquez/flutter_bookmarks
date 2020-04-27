import 'package:CardFLows/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/board.dart';

enum BoardState {
  unselected,
  selected,
}

class BoardIcon extends StatelessWidget {
  final double size;
  final Board board;
  final bool circular;
  final BoardState iconState;

  const BoardIcon(
      {Key key,
      this.board,
      this.size = 200,
      this.circular = true,
      this.iconState = BoardState.unselected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: GlowingIcon(
            iconData: board.icon.iconData,
            color: board.color,
            size: size / 2,
            borderRadius: circular ? size : 0,
            iconState: iconState,
          ),
        ),
        board.name != null
            ? Text(
                "${board.name}",
                maxLines: 2,
                textAlign: TextAlign.center,
              )
            : NOTHING
      ]),
    );
  }
}

class GlowingIcon extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final double size;
  final double borderRadius;
  final BoardState iconState;

  const GlowingIcon(
      {Key key,
      this.iconData,
      this.color,
      this.size = 100,
      this.borderRadius = 0,
      this.iconState = BoardState.unselected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
//    final brightness = ThemeData.estimateBrightnessForColor(color);
//    final iconColor =
//    brightness == Brightness.light ? Colors.black : Colors.white;

    ThemeData themeData = Theme.of(context);

    // Dark and unselected
    double iconGlowOpacity = 0.2;
    Color iconColor = lighterColor(color, 0.3);

    // Dark and selected
    if (themeData.brightness == Brightness.dark &&
        iconState == BoardState.selected) {
      iconGlowOpacity = 0.8;
      iconColor = Colors.white;
    }
    // Light and unselected
    if (themeData.brightness == Brightness.light &&
        iconState == BoardState.unselected) {
      iconGlowOpacity = 0.2;
      iconColor = darkerColor(color, 0.3);
    }

    // Light and selected
    if (themeData.brightness == Brightness.light &&
        iconState == BoardState.selected) {
      iconGlowOpacity = 0.8;
      iconColor = Colors.black;
    }

    return SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
                child: Opacity(
                  opacity: iconGlowOpacity,
                  child: Container(
                    color: color,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Icon(
                iconData,
                size: size * 0.50,
                color: iconColor,
              ),
            ),

//            Text("iconState:${iconState}")
          ],
        ));
  }
}
