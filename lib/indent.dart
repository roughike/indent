/// Support for doing something awesome.
///
/// More dartdocs go here.
library indent;

import 'dart:convert';

extension IndentedString on String {
  int get indentationLevel =>
      IndentingStringFormatter(this).findIndentationLevel();

  String stripExtraIndentation() =>
      IndentingStringFormatter(this).stripExtraIndentation();

  String withIndentationLevel([int indentationLevel = 0]) =>
      IndentingStringFormatter(this).withIndentationLevel(indentationLevel);

  String increaseIndentationBy(int howMuch) =>
      IndentingStringFormatter(this).increaseIndentationBy(howMuch);

  String decreaseIndentationBy(int howMuch) =>
      IndentingStringFormatter(this).decreaseIndentationBy(howMuch);
}

class IndentingStringFormatter {
  const IndentingStringFormatter(this._value);
  final String _value;

  int findIndentationLevel() {
    final lines = _processLines();
    return _findSmallestIndentationLevel(lines);
  }

  String withIndentationLevel([int indentationLevel = 0]) {
    final lines = _processLines();
    final currentIndentationLevel = _findSmallestIndentationLevel(lines);
    return _indent(lines, currentIndentationLevel, indentationLevel);
  }

  String stripExtraIndentation() => withIndentationLevel(0);

  String increaseIndentationBy(int howMuch) {
    final lines = _processLines();
    final currentIndentationLevel = _findSmallestIndentationLevel(lines);
    return _indent(
      lines,
      currentIndentationLevel,
      currentIndentationLevel + howMuch,
    );
  }

  String decreaseIndentationBy(int howMuch) {
    final lines = _processLines();
    final currentIndentationLevel = _findSmallestIndentationLevel(lines);
    return _indent(
      lines,
      currentIndentationLevel,
      currentIndentationLevel - howMuch,
    );
  }

  Iterable<_Line> _processLines() sync* {
    if (_valueIsNullOrBlank()) return;

    for (final line in LineSplitter.split(_value)) {
      final indentationMatch = _indentation.stringMatch(line);
      final indentationLevel =
          indentationMatch != null && indentationMatch.isNotEmpty
              ? indentationMatch.length
              : 0;

      yield _Line(indentationLevel, line.trim());
    }
  }

  bool _valueIsNullOrBlank() =>
      _value == null || _value.isEmpty || _value.trim().isEmpty;

  int _findSmallestIndentationLevel(Iterable<_Line> lines) {
    int smallestIndentation;

    for (final line in lines) {
      if (line.content.isEmpty) continue;

      if (smallestIndentation == null ||
          line.indentationLevel < smallestIndentation) {
        smallestIndentation = line.indentationLevel;
      }
    }

    return smallestIndentation ?? 0;
  }

  String _indent(
    Iterable<_Line> lines,
    int currentIndentationLevel,
    int indentationLevel,
  ) {
    final buffer = StringBuffer();

    for (final line in lines) {
      final diff = line.indentationLevel - currentIndentationLevel;
      final spaces = _generateIndentation(indentationLevel + diff);

      buffer
        ..write(spaces)
        ..writeln(line.content);
    }

    return buffer.toString();
  }

  String _generateIndentation(int indentationLevel) {
    return indentationLevel > 0
        ? List.generate(indentationLevel, _spaceGenerator).join()
        : '';
  }
}

class _Line {
  _Line(this.indentationLevel, this.content);
  final int indentationLevel;
  final String content;
}

final _indentation = RegExp(r'^(\s+)');
String _spaceGenerator(int index) => ' ';
