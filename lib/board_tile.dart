import 'package:flutter/material.dart';
import 'package:flutter_application_2/tile_state.dart';

class BoardTile extends StatelessWidget {
  final double dimension;
  final VoidCallback onPressed;
  final TileState tileState;
  BoardTile(
    this.tileState,
    this.onPressed, {
    Key? key,
    this.dimension = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.transparent;
    if (tileState == TileState.CROSS) {
      backgroundColor = Colors.orange;
    } else if (tileState == TileState.CIRCLE) {
      backgroundColor = Colors.purple;
    }

    return Container(
      width: dimension,
      height: dimension,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        onPressed: onPressed,
        child: widgetForTileState(),
      ),
    );
  }

  Widget widgetForTileState() {
    Widget widget;

    switch (tileState) {
      case TileState.EMPTY:
        {
          widget = Container();
        }
        break;
      case TileState.CROSS:
        {
          widget = Image.asset("images/x.png");
        }
        break;
      case TileState.CIRCLE:
        {
          widget = Image.asset("images/o.png");
        }
        break;
    }
    return widget;
  }
}
