import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/task_list/functions/task_functions.dart';
import 'package:too_many_tasks/task_list/widgets/task_card/state.dart';

typedef TestCase = ({
  Tasks oldTasks,
  Tasks newTasks,
  bool Function(List<State>) expected,
});

final List<TestCase> testCases = [
  (
    oldTasks: [
      (
        name: "task 1",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
      (
        name: "task 2",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
      (
        name: "task 3",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
    ].lock,
    newTasks: [
      (
        name: "task 1",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
      (
        name: "task 2",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
    ].lock,
    expected: (states) => states.length == 3 &&
      states[0] is Ready &&
      states[1] is Ready &&
      states[2] is BeingRemoved,
  ),
  (
    oldTasks: [
      (
        name: "task 1",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
      (
        name: "task 2",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
    ].lock,
    newTasks: [
      (
        name: "task 1",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
      (
        name: "task 2",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
      (
        name: "task 3",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
    ].lock,
    expected: (states) => states.length == 3 &&
      states[0] is Ready &&
      states[1] is Ready &&
      states[2] is BeingAdded,
  ),
  (
    oldTasks: [
      (
        name: "task 1",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
      (
        name: "task 2",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
    ].lock,
    newTasks: [
      (
        name: "task 1",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
      (
        name: "task 2",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
      (
        name: "task 3",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
      (
        name: "task 4",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),
      (
        name: "task 5",
        dueDate: DateTime(2023),
        done: true,
        pinned: true,
      ),

    ].lock,
    expected: (states) => states.length == 5 && 
      states[0] is Ready && 
      states[1] is Ready &&
      states[2] is BeingAdded &&
      states[3] is BeingAdded &&
      states[4] is BeingAdded,
  )
];

void main() {
  var number = 0;
  for (final testCase in testCases) {
    number++;
    test('card states test $number', () {
      final states = cardStates(testCase.oldTasks, testCase.newTasks);
      expect(testCase.expected(states), true);
    });
  }
}
