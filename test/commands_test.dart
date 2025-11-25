import 'dart:math';

import 'package:calculator_cli/commands.dart';
import 'package:calculator_cli/calculator_state.dart';
import 'package:test/test.dart';

void main() {
  /* TODO write tests for commands
   *
   * - Enter
   *   - a new stack with given value at the end and old stack in history
   * - Clear
   *   - an empty state
   * - Undo
   *   - previous state restored from history
   * - Add
   *   - stack with the last two values added, and history so that the old state can be restored
   *   - does nothing when stack length is less than 2
   * - Subtract
   *   - stack with the last two values subtracted, and history so that old state
   *     can be restored
   *   - does nothing when stack length is less than 2
   * - Multiply
   *   - stack with the last two values multiplied, and history so that old state
   *   - does nothing when stack length is less than 2
   * - Divide
   *   - stack with the last two values divided, and history so that old state
   *   - does nothing when stack length is less than 2
  */

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

  test('AddCommand returns sum of the last to operands in the stack', () {
    final origStack = [1, 2];
    final newStack = Add().operate(origStack[0], origStack[1]);

    expect(newStack, equals(3));
    expect(newStack, isNot(equals(origStack)));
  });

  test(
      'SubstractCommand returns the substraction of the last to operands in the stack',
      () {
    final origStack = [1, 2];
    final newStack = Subtract().operate(origStack[0], origStack[1]);

    expect(newStack, equals(-1));
    expect(newStack, isNot(equals(origStack)));
  });

  test(
      'MultiplyCommand returns the multiplication of the last to operands in the stack',
      () {
    final origStack = [1, 2];
    final newStack = Multiply().operate(origStack[0], origStack[1]);

    expect(newStack, equals(2));
    expect(newStack, isNot(equals(origStack)));
  });

  test(
      'DivideCommand returns the divided value of the last to operands in the stack',
      () {
    final origStack = [10, 2];
    final newStack = Divide().operate(origStack[0], origStack[1]);

    expect(newStack, equals(5));
    expect(newStack, isNot(equals(origStack)));
  });
}
