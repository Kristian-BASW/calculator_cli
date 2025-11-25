import 'dart:math';

import 'package:calculator_cli/commands.dart';
import 'package:calculator_cli/calculator_state.dart';
import 'package:test/test.dart';

void main() {
  test('EnterCommand returns a new list with the given number applied', () {
    final List<num> origStack = [1, 2];
    var state = CalculatorState(stack: origStack, history: [origStack]);
    final newState = Enter(10).execute(state);

    expect(newState.stack, equals([1, 2, 10]));
    expect(newState.stack, isNot(equals(origStack)));
  });

  test('ClearCommand returns a new CalculatorState with an empty stack', () {
    final List<num> origStack = [1, 2];
    CalculatorState state =
        CalculatorState(stack: origStack, history: [origStack]);
    final newState = Clear().execute(state);

    expect(newState.stack, equals([]));
    expect(newState.stack, isNot(equals(origStack)));
  });

  test(
      'Undo returns a new CalculatorState with the previous stack and history where the latest item added is removed',
      () {
    final List<num> oldStack = [1];
    final List<num> newStack = [1, 2];
    CalculatorState state =
        CalculatorState(stack: newStack, history: [oldStack]);
    final newState = Undo().execute(state);

    expect(newState.stack, equals([1]));
    expect(newState.stack, isNot(newStack));
    expect(newState.history, isEmpty);
  });
  //#region AddCommand
  group('AddCommand', () {
    test('returns sum of the last to operands in the stack', () {
      final origStack = [1, 2];
      CalculatorState state =
          CalculatorState(stack: origStack, history: [origStack]);
      final newStack = Add().execute(state);

      expect(newStack.stack, equals([3]));
      expect(newStack.history, isNot(equals(origStack)));
    });

    test(
        'returns sum of the last two operands in the stack and not all of them',
        () {
      CalculatorState state = CalculatorState(stack: [
        1,
        2,
        3,
        4
      ], history: [
        [1],
        [1, 2],
        [1, 2, 3],
        [1, 2, 3, 4]
      ]);
      final newStack = Add().execute(state);

      expect(newStack.stack, equals([1, 2, 7]));
      expect(
          newStack.history,
          equals([
            [1],
            [1, 2],
            [1, 2, 3],
            [1, 2, 3, 4],
            [1, 2, 3, 4]
          ]));
    });

    test('do nothing, because the length of the list is the less than 2', () {
      CalculatorState state = CalculatorState(stack: [
        1
      ], history: [
        [1]
      ]);
      final newStack = Add().execute(state);

      expect(newStack.stack, equals([1]));
      expect(
          newStack.history,
          equals([
            [1]
          ]));
    });
  });
//#endregion

  //#region SubstractCommand
  group('SubstractCommand', () {
    test('returns substraction of the last two operands in the stack', () {
      var state = CalculatorState(stack: [
        1,
        2
      ], history: [
        [1],
        [1, 2]
      ]);
      final newState = Subtract().execute(state);

      expect(newState.stack, equals([-1]));
      expect(newState.stack, isNot([1, 2]));
      expect(newState.history.last, equals([1, 2]));
    });

    test(
        'returns substraction of the last two operands in the stack and not all of them',
        () {
      var state = CalculatorState(stack: [
        1,
        2,
        4,
        3
      ], history: [
        [1],
        [1, 2],
        [1, 2, 4],
      ]);
      final newState = Subtract().execute(state);

      expect(newState.stack, equals([1, 2, 1]));
      expect(newState.history.last, equals([1, 2, 4, 3]));
    });

    test('do nothing, because the length of the list is the less than 2', () {
      CalculatorState state = CalculatorState(stack: [
        1
      ], history: [
        [1]
      ]);
      final newState = Subtract().execute(state);

      expect(newState, equals(state));
    });
  });
  //#endregion

  //#region MultiplyCommand
  group('MultiplyCommand', () {
    test('returns the multiplication of the last two operands in the stack',
        () {
      CalculatorState state = CalculatorState(stack: [
        1,
        2
      ], history: [
        [1]
      ]);
      final newStack = Multiply().execute(state);

      expect(newStack.stack, equals([2]));
      expect(newStack.history.last, equals([1, 2]));
    });

    test(
        'returns the multiplication of the last two operands in the stack and not all of them',
        () {
      CalculatorState state = CalculatorState(stack: [
        1,
        2,
        3,
        4
      ], history: [
        [1],
        [1, 2],
        [1, 2, 3]
      ]);
      final newStack = Multiply().execute(state);

      expect(newStack.stack, equals([1, 2, 12]));
      expect(newStack.history.last, equals([1, 2, 3, 4]));
    });

    test('do nothing, due not enough elements in the stack', () {
      CalculatorState state = CalculatorState(stack: [1], history: []);
      final newStack = Multiply().execute(state);

      expect(newStack.stack, equals([1]));
      expect(newStack.history, isEmpty);
    });
  });
  //#endregion

  //#region DivideCommand

  group('DivideCommand', () {
    test('returns the divided value of the last to operands in the stack', () {
      // Arrange
      var state = CalculatorState(stack: [
        10,
        2
      ], history: [
        [10],
      ]);

      // Act
      final newStack = Divide().execute(state);

      // Assert
      expect(newStack.stack, equals([5]));
      expect(newStack.history.last, equals([10, 2]));
    });

    test(
        'returns the divided value of the last to operands in the stack and not all of them',
        () {
      // Arrange
      var state = CalculatorState(stack: [
        10,
        2,
        12,
        3
      ], history: [
        [10],
        [10, 2],
        [10, 2, 12, 3]
      ]);

      // Act
      final newStack = Divide().execute(state);

      // Assert
      expect(newStack.stack, equals([10, 2, 4]));
      expect(newStack.history.last, equals([10, 2, 12, 3]));
    });

    test('do nothing, due to not enough elements in the list', () {
      // Arrange
      var state = CalculatorState(stack: [10], history: []);

      // Act
      final newStack = Divide().execute(state);

      // Assert
      expect(newStack.stack, equals([10]));
      expect(newStack.history, isEmpty);
    });
  });

  //#endregion
}
