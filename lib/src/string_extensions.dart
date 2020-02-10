import 'indentation.dart';

/// Extension methods for easier indentation of strings while preserving relative
/// indentation.
extension IndentedString on String {
  /// Returns the indentation level of this string.
  ///
  /// An indentation level is determined by finding a non-empty line with the
  /// least amount of leading whitespace.
  ///
  /// For example, with input:
  ///
  ///   Hello
  ///  World
  ///
  /// the indentation level is 1, because the line with " World" has the least
  /// amount of leading whitespace.
  int getIndentationLevel() => Indentation(this).getLevel();

  /// Returns this string with all extra indentation stripped while preserving
  /// the relative indentation.
  ///
  /// For example, the input:
  ///
  ///          Hello
  ///        there
  ///           World
  ///
  /// will become:
  ///
  ///   Hello
  /// there
  ///    World
  ///
  /// Calling [unindent] is equivalent of calling [indent] with
  /// the value of 0.
  String unindent() => Indentation(this).unindent();

  /// Returns this string with [indentationLevel] applied while preserving
  /// relative indentation.
  ///
  /// For example, the input:
  ///
  ///  Hello
  /// World
  ///
  /// applied with [indentationLevel] of 3 results in:
  ///
  ///     Hello
  ///    World
  ///
  /// If the starting indentation level is higher than [indentationLevel], the
  /// value will be unindented accordingly.
  ///
  /// For example, the input:
  ///
  ///        Hello
  ///       World
  ///
  /// applied with [indentationLevel] of 3 also results in:
  ///
  ///     Hello
  ///    World
  String indent(int indentationLevel) =>
      Indentation(this).indent(indentationLevel);

  /// Returns this string with indentation level changed by [howMuch].
  ///
  /// For example, the input:
  ///
  ///    Hello
  ///   World
  ///
  /// with [howMuch] of 2 will result in:
  ///
  ///      Hello
  ///     World
  ///
  /// If [howMuch] is negative, the indentation level will be decreased.
  ///
  /// For example, the input:
  ///
  ///    Hello
  ///   World
  ///
  /// with [howMuch] of -2 will result in:
  ///
  ///  Hello
  /// World
  String indentBy(int howMuch) => Indentation(this).indentBy(howMuch);
}
