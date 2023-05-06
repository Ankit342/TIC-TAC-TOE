import 'package:flutter/material.dart';
import 'package:flutter_application_2/tile_state.dart';
import 'board_tile.dart';
import 'tile_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final navigatorKey = GlobalKey<NavigatorState>();
  var _boardState = List.filled(9, TileState.EMPTY);
  var _currentTurn = TileState.CROSS;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(
          appBar: AppBar(
            title: Center(
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Tic Tac Toe ',
                      // non-emoji characters
                    ),
                    TextSpan(
                      text: '⭕❕⁣❌❕⭕', // emoji characters
                      style: TextStyle(
                        fontFamily: 'EmojiOne',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
              child: Center(
            child: Stack(children: [
              Image.asset('images/board.png'),
              _boardTiles(),
            ]),
          )),
        ));
  }

  Widget _boardTiles() {
    return Builder(builder: (context) {
      //final boardDimension = MediaQuery.of(context).size.width;
      var widthd = MediaQuery.of(context).size.width;
      final boardDimension = widthd;
      final tileDimension = boardDimension / 3;
      return Container(
          width: boardDimension,
          height: boardDimension,
          child: Column(
              children: chunk(_boardState, 3).asMap().entries.map((entry) {
            final chunkIndex = entry.key;
            final tileStateChunk = entry.value;
            return Row(
              children: tileStateChunk.asMap().entries.map((innerEntry) {
                final innerIndex = innerEntry.key;
                final tileState = innerEntry.value;
                final tileIndex = (chunkIndex * 3) + innerIndex;

                return BoardTile(
                    tileState,
                    dimension: tileDimension,
                    () => _updateTileStateForIndex(tileIndex));
              }).toList(),
            );
          }).toList()));
    });
  }

  var l = -1;
  void _updateTileStateForIndex(int selectedIndex) {
    if (_boardState[selectedIndex] == TileState.EMPTY) {
      setState(() {
        _boardState[selectedIndex] = _currentTurn;
        _currentTurn = _currentTurn == TileState.CROSS
            ? TileState.CIRCLE
            : TileState.CROSS;
      });
      final winner = _findWinner();

      if (winner != null) {
        print('The winner is: $winner');

        _showWinnerDialog(winner);
        l = 0;
      } else {
        l = l + 1;
        print('$l from counter');
      }
      if (l == 8 && winner == null) {
        showDialog(
            context: navigatorKey.currentState!.overlay!.context,
            barrierDismissible: false,
            builder: (_) {
              return AlertDialog(
                title: Text('Tie'),
                content: Image.network(
                  'https://media.tenor.com/tfxM6v-BvWQAAAAM/its-a-tie-tie.gif',
                  width: 100,
                  height: 100,
                  cacheHeight: 100,
                  cacheWidth: 100,
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        _resetGame(TileState.EMPTY);
                        Navigator.of(
                                navigatorKey.currentState!.overlay!.context)
                            .pop();
                      },
                      child: const Text('Restart Game'))
                ],
              );
            });
        l = 0;
      }
    }
  }

  TileState? _findWinner() {
    // ignore: prefer_function_declarations_over_variables
    TileState? Function(int, int, int) winnerForMatch = (a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if ((_boardState[a] == _boardState[b]) &&
            (_boardState[b] == _boardState[c])) {
          return _boardState[a];
        }
      }
      return null;
    };
    final checks = [
      winnerForMatch(0, 1, 2),
      winnerForMatch(3, 4, 5),
      winnerForMatch(6, 7, 8),
      winnerForMatch(0, 4, 8),
      winnerForMatch(2, 4, 6),
      winnerForMatch(0, 3, 6),
      winnerForMatch(1, 4, 7),
      winnerForMatch(2, 5, 8),
    ];

    TileState? winner;
    for (int i = 0; i < checks.length; i++) {
      if (checks[i] != null) {
        winner = checks[i];
        break;
      }
    }
    return winner;
  }

  void _showWinnerDialog(TileState tileState) {
    final context = navigatorKey.currentState!.overlay!.context;
    final won = tileState == TileState.CROSS ? 'X' : 'O';
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text('Winner is: $won \nhow much moves: $l'),
            content: Image.network(
              'https://media.tenor.com/0wHlOpLf4p0AAAAM/you-win-this-round.gif',
              width: 100,
              height: 100,
              cacheHeight: 100,
              cacheWidth: 100,
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    _resetGame(tileState);
                    Navigator.of(context).pop();
                  },
                  child: const Text('New Game'))
            ],
          );
        });
  }

  void _resetGame(TileState tileState) {
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      if (tileState == TileState.EMPTY) {
        tileState = TileState.CROSS;
      }
      _currentTurn =
          tileState == TileState.CROSS ? TileState.CROSS : TileState.CIRCLE;
      //_currentTurn = TileState.CROSS;
    });
  }
}
