import 'dart:developer' as developer;

import 'package:flutter_bookmarks/model/board.dart';
import 'package:flutter_bookmarks/model/defaults.dart';
import 'package:flutter_bookmarks/model/item.dart';
import 'package:flutter_bookmarks/model/pane.dart';
import 'package:flutter_bookmarks/provider/user_repository.dart';
import 'package:flutter_bookmarks/screens/boards/card/card_widget.dart';
import 'package:flutter_bookmarks/screens/boards/pane/pane.dart';
import 'package:flutter_bookmarks/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class KanbanBoard extends StatefulWidget {
  final double tileWidth = 300;

  final Board board;

  const KanbanBoard({Key key, this.board}) : super(key: key);
  @override
  _KanbanBoardState createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  Board board;

  // I use this to show or not the item toolbar. I don't like the approach though.
  Set<String> cardsFloatingAround;

  addCardFloatingAround(CardWidget widget) {
    setState(() {
      cardsFloatingAround.add(widget.card.uid);
    });
  }

  removeCardFloatingAround(CardWidget widget) {
    setState(() {
      cardsFloatingAround.remove(widget.card.uid);
    });
  }

  @override
  void initState() {
    super.initState();
    board = widget.board;
    cardsFloatingAround = {};
  }

  @override
  Widget build(BuildContext context) {
    UserRepository service = Provider.of<UserRepository>(context);
    developer.log("Building kanban board");

    final BoardStyle boardStyle = BoardStyle.fromColorSwatch(board.color);

    moveItem(Item item, Pane targetPane, targetPosition) {
      setState(() {
        service.moveCard(item, targetPane, targetPosition);
      });
    }

    addNewPane() {
      setState(() {
        service.addNewPane(board, Defaults.newPane());
      });
    }

    swapPanes(Pane pane, Pane incoming) {
      setState(
        () {
          service.swapPanes(board, pane, incoming);
        },
      );
    }

    addNewCard(Pane targetPane) {
      setState(() {
        service.addCard(targetPane, Defaults().newItem());
      });
    }

    deleteCard(Item item) {
      setState(() {
        service.deleteCard(item);
      });
    }

    onUpdateCard(Item item) {
      setState(() {
        service.updateCard(item);
        Navigator.of(context).pop(item);
      });
    }

    buildPaneHeader(Pane pane) {
      final Widget staticPlaceHeader = PaneHeaderStatic(
        pane: pane,
        color: boardStyle.paneHeaderColor,
      );

      buildPaneheader() {
        return LongPressDraggable<Pane>(
          data: pane,
          child: PaneHeader(
            color: boardStyle.paneHeaderColor,
            updateParent: () {
              setState(() {
                developer.log("Updating state");
                // I still don't know why this is not triggered with provider
              });
            },
            pane: pane,
          ),
          childWhenDragging: _LeftBehindWidget(
            child: staticPlaceHeader,
          ),
          feedback: _FloatingWidget(
            // A header floating around
            child: Container(
              width: widget.tileWidth,
              child: staticPlaceHeader,
            ),
          ),
        );
      }

      // The header
      return DragTarget<CardWidget>(
        onWillAccept: (CardWidget data) {
          // Always accept if the list is empty.
          if (pane.items.isEmpty) {
            return true;
          }
          // Does not accept himself.
          if (pane.items[0].uid == data.card.uid) {
            return false;
          }
          return true;
        },
        // Moves the card into the position
        onAccept: (CardWidget data) => moveItem(data.card, pane, 0),
        builder: (
          BuildContext context,
          List<CardWidget> incoming,
          List<dynamic> rejectedData,
        ) {
          if (incoming.isEmpty) {
            // The area that accepts the draggable
            return DragTarget<Pane>(
              // Will accept others, but not himself
              onWillAccept: (Pane incoming) {
                return pane.uid != incoming.uid;
              },
              // Moves the card into the position
              onAccept: (Pane incoming) {
                swapPanes(pane, incoming);
              },

              builder: (
                BuildContext context,
                List<Pane> incoming,
                List<dynamic> rejectedData,
              ) {
                if (incoming.isEmpty) {
                  // The area that accepts the draggable
                  return buildPaneheader();
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: Colors.blueAccent,
                      ),
                    ),
                    child: buildPaneheader(),
                  );
                }
              },
            );
          } else {
            return _AcceptingCardWidgets(
              hostWidget: staticPlaceHeader,
              floatingCardWidgets: incoming,
            );
          }
        },
      );
    }

    // A card that can be dragged and can accept other cards
    buildItem(
      Pane pane,
      int index,
    ) {
      final CardWidget tile = CardWidget(
        card: pane.items[index],
        boardStyle: boardStyle,
        leading: "${index + 1}",
        onUpdate: onUpdateCard,
      );

      return DragTarget<CardWidget>(
        // Will accept others, but not himself
        onWillAccept: (CardWidget data) {
          // Always accept if the list is empty.
          if (pane.items.isEmpty) {
            return true;
          }
          // Does not accept himself.
          if (pane.items[index].uid == data.card.uid) {
            return false;
          }
          // Does not accept the next item.
          if (pane.items.length > index + 1) {
            if (pane.items[index + 1].uid == data.card.uid) {
              return false;
            }
          }
          return true;
        },

        // Moves the card into the position
        onAccept: (CardWidget data) => moveItem(data.card, pane, index + 1),

        builder: (
          BuildContext context,
          List<CardWidget> data,
          List<dynamic> rejectedData,
        ) {
          if (data.isEmpty) {
            // The area that accepts the draggable
            return LongPressDraggable<CardWidget>(
              data: tile,
              child: tile, // A card waiting to be dragged
              childWhenDragging: _LeftBehindWidget(
                child: tile,
              ),
              feedback: Container(
                // A card floating around
                width: widget.tileWidth,

                child: VisibilityDetector(
                  key: Key(tile.card.uid),
                  onVisibilityChanged: (VisibilityInfo info) {
                    if (info.visibleFraction > 0) {
                      addCardFloatingAround(tile);
                    } else {
                      removeCardFloatingAround(tile);
                    }
                  },
                  child: _FloatingWidget(child: tile),
                ),
              ),
            );
          } else {
            return _AcceptingCardWidgets(
              hostWidget: tile,
              floatingCardWidgets: data,
            );
          }
        },
      );
    }

    buildItemList(Pane pane) {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: boardStyle.paneBackgroundColor,
            ),
            child: buildPaneHeader(pane),
          ),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: boardStyle.paneBackgroundColor,
              ),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: pane.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildItem(pane, index);
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            decoration: BoxDecoration(
                color: boardStyle.paneBackgroundColor,
                borderRadius: new BorderRadius.only(
                    bottomLeft: const Radius.circular(40.0),
                    bottomRight: const Radius.circular(40.0))),
            child: Center(
              child: RaisedButton(
                color: boardStyle.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: boardStyle.iconColor,
                  ),
                ),
                onPressed: () {
                  addNewCard(pane);
                },
              ),
            ),
          )
        ],
      );
    }

    buildPanes() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...board.panes.map((Pane place) {
              return Container(
                width: widget.tileWidth,
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: buildItemList(place),
              );
            }).toList(),
            RaisedButton(
              color: boardStyle.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                "Add List",
                style: TextStyle(
                  color: boardStyle.iconColor,
                ),
              ),
              onPressed: () {
                addNewPane();
              },
            ),
          ],
        ),
      );
    }

    buildCardActionsToolbar() {
      return DragTarget<CardWidget>(
        onWillAccept: (CardWidget data) {
          return true;
        },

        // Moves the card into the position
        onAccept: (CardWidget data) => {
          deleteCard(data.card),
        },

        builder: (BuildContext context, List<CardWidget> data,
            List<dynamic> rejectedData) {
          bool showDeleteButton = cardsFloatingAround.isNotEmpty;

          return showDeleteButton
              ? Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                      height: data.isEmpty ? 80 : 90,
                      width: data.isEmpty ? 80 : 90,
                      color: boardStyle.buttonColor,
                      child: Icon(
                        Icons.delete,
                        color: boardStyle.iconColor,
                        size: data.isEmpty ? 40 : 60,
                      ),
                    ),
                  ),
                )
              : NOTHING;
        },
      );
    }

    return Column(
      children: [
        Expanded(
          child: buildPanes(),
        ),
        buildCardActionsToolbar(),
      ],
    );
  }
}

// Used when dragging
// The floating widget itself
class _LeftBehindWidget extends StatelessWidget {
  final Widget child;

  const _LeftBehindWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.2,
      child: child,
    );
  }
}

// Used when dragging
// What's left while the target is being dragged
class _FloatingWidget extends StatelessWidget {
  final Widget child;

  const _FloatingWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Transform.rotate(
        angle: 0.1,
        child: child,
      ),
    );
  }
}

// Used when dragging
// What's shown when a target is being accepted
class _AcceptingCardWidgets extends StatelessWidget {
  final Widget hostWidget;
  final List<CardWidget> floatingCardWidgets;

  const _AcceptingCardWidgets({
    Key key,
    this.floatingCardWidgets,
    this.hostWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // What's shown when hovering on it
      children: [
        hostWidget,
        ...floatingCardWidgets.map((CardWidget floatingWidget) {
          return Opacity(
            opacity: 0.5,
            child: floatingWidget,
          );
        }).toList()
      ],
    );
  }
}
