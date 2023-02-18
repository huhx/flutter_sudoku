import 'package:app_common_flutter/extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("test firstOrNull", () {
    test("return null when list is empty", () {
      final List<int> userList = [];

      expect(userList.firstOrNull, null);
    });

    test("return first item when list is not empty", () {
      final List<int> userList = [3, 4];

      expect(userList.firstOrNull, 3);
    });
  });

  group("test lastOrNull", () {
    test("return null when list is empty", () {
      final List<int> userList = [];

      expect(userList.lastOrNull, null);
    });

    test("return last item when list is not empty", () {
      final List<int> userList = [3, 4];

      expect(userList.lastOrNull, 4);
    });
  });

  group("test addOrRemove", () {
    test("return list that remove item when contain item", () {
      final List<String> fruitList = ["apple", "orange"];

      expect(fruitList.addOrRemove("apple"), ["orange"]);
    });

    test("return list that add item when not contain item", () {
      final List<String> fruitList = ["apple", "orange"];

      expect(fruitList.addOrRemove("banana"), ["apple", "orange", "banana"]);
    });
  });
}
