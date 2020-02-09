import 'dart:convert';

import 'package:indent/indent.dart';

/// Utilities for changing indentation in a [String] while preserving existing
/// relative indentation.
///
/// See also [IndentedString] in string_extensions.dart.
class Indentation {
  const Indentation(this._value);
  final String _value;

  /// Returns the indentation level of [_value].
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
  int getIndentationLevel() {
    final lines = _processLines();
    return _findSmallestIndentationLevel(lines);
  }

  /// Returns [_value] with all extra indentation stripped while preserving
  /// relative indentation.
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
  /// Calling [unindent] is equivalent of calling [withLevel] with the value of 0.
  String unindent() => withLevel(0);

  /// Returns [_value] with [indentationLevel] applied while preserving relative
  /// indentation.
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
  String withLevel(int indentationLevel) {
    final lines = _processLines();
    final currentIndentationLevel = _findSmallestIndentationLevel(lines);
    return _indent(lines, currentIndentationLevel, indentationLevel);
  }

  /// Returns [_value] with indentation level changed by [howMuch].
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
  String indentBy(int howMuch) {
    final lines = _processLines();
    final currentIndentationLevel = _findSmallestIndentationLevel(lines);
    return _indent(
      lines,
      currentIndentationLevel,
      currentIndentationLevel + howMuch,
    );
  }

  // Turns the string into _Line classes that contain the indentation level and
  // unindented contents of each line.
  //
  // This is to avoid having to find the indentation level two times per line:
  // first time in the "find smallest indentation level" loop, and second time
  // in the loop that applies the indentation.
  Iterable<_Line> _processLines() sync* {
    if (_valueIsNullOrBlank()) return;

    for (final line in LineSplitter.split(_value)) {
      final indentationMatch = _whitespace.stringMatch(line);
      final indentationLevel =
          indentationMatch != null && indentationMatch.isNotEmpty
              ? indentationMatch.length
              : 0;

      yield _Line(indentationLevel, line.substring(indentationLevel));
    }
  }

  bool _valueIsNullOrBlank() =>
      _value == null || _value.isEmpty || _value.trim().isEmpty;

  int _findSmallestIndentationLevel(Iterable<_Line> lines) {
    int smallestIndentation;

    for (final line in lines) {
      // Empty or blank lines do not have indentation.
      if (line.content.isEmpty) continue;

      if (smallestIndentation == null ||
          line.indentationLevel < smallestIndentation) {
        // If the smallest indentation level is not found yet, or if we found a
        // smaller level than the previous one, we update it.
        smallestIndentation = line.indentationLevel;
      }
    }

    return smallestIndentation ?? 0;
  }

  String _indent(
    Iterable<_Line> lines,
    int currentIndentationLevel,
    int desiredIndentationLevel,
  ) {
    final buffer = StringBuffer();

    for (final line in lines) {
      if (line.content.isEmpty) {
        // Do not indent empty lines.
        buffer.writeln();
        continue;
      }

      final diff = line.indentationLevel - currentIndentationLevel;
      final spaces = _generateIndentation(desiredIndentationLevel + diff);

      buffer
        ..write(spaces)
        ..writeln(line.content);
    }

    return buffer.toString();
  }

  // Generates an appropriate amount of spaces for the desired indentation level.
  String _generateIndentation(int indentationLevel) {
    return indentationLevel > 0
        ? List.generate(indentationLevel, _spaceGenerator).join()
        : '';
  }
}

// A class that holds information about the indentation level and the trimmed
// contents of one line in a string.
//
// Exists for reusing the indentation level information so that it doesn't have
// to be recalculated twice for each line.
class _Line {
  _Line(this.indentationLevel, this.content);
  final int indentationLevel;
  final String content;
}

// This is a top-level function to avoid redefining an anonymous inner function
// for every line in the input string.
String _spaceGenerator(int index) => ' ';
final _whitespace = RegExp(r'^(\s+)');