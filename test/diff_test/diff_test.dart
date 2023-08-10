import 'package:flutter_test/flutter_test.dart';
import 'package:too_many_tasks/common/functions/iterable_functions.dart';
import 'package:too_many_tasks/common/functions/list_functions.dart';

typedef TestCase<T, R> = (
  Iterable<T> oldList,
  Iterable<T> newList,
  List<R> expected,
);

sealed class Result {}

final class A implements Result {
  final String char;

  const A(this.char);

  @override
  bool operator ==(Object? other) {
    if (other is! A) return false;
    return char == other.char;
  }
  
  @override
  int get hashCode => char.hashCode;
}

final class D implements Result {
  final String char;

  const D(this.char);

  @override
  bool operator ==(Object? other) {
    if (other is! D) return false;
    return char == other.char;
  }
  
  @override
  int get hashCode => char.hashCode;
}

final class U implements Result {
  final String char;

  const U(this.char);

  @override
  bool operator ==(Object? other) {
    if (other is! U) return false;
    return char == other.char;
  }
  
  @override
  int get hashCode => char.hashCode;
}

final List<TestCase<String, Result>> testCases = [
  (
    "abd".split(""),
    "acd".split(""),
    const [U("a"), D("b"), A("c"), U("d")],
  )
];

void main() {
  for (var i = 0; i < testCases.length; i++) {
    test("test ${i + 1}", () {
      final (oldList, newList, expected) = testCases[i];
      final actual = diff(
        oldList,
        newList,
        comparator: (s1, s2) => s1 == s2,
        onAddition: (s) => A(s),
        onUnchanged: (s) => U(s),
        onDeletion: (s) => D(s),
      );
      expect(actual, expected);
    });
  }
}
