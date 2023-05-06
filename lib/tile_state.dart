import 'dart:math';

enum TileState { CROSS, CIRCLE, EMPTY }

List<List<TileState>> chunk(List<TileState> list, int size) {
  return List.generate(
      (list.length / size).ceil(),
      (index) =>
          list.sublist(index * size, min(index * size + size, list.length)));
}
