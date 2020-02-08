/// Support for doing something awesome.
///
/// More dartdocs go here.
library indent;

import 'dart:convert';

final _indentation = RegExp(r'^(\s+)');

extension IndentedString on String {
  String indent([int indentationLevel = 0]) =>
      IndentingStringFormatter(this).indent(indentationLevel);
}

class IndentingStringFormatter {
  const IndentingStringFormatter(this._value);
  final String _value;

  String indent([int indentationLevel = 0]) {
    if (_value == null || _value.isEmpty || _value.trim().isEmpty) {
      return _value;
    }

    final lines = _processLines();
    final smallestIndentationLevel = _findSmallestIndentation(lines);
    final buffer = StringBuffer();

    for (final line in lines) {
      if (line.indentationLevel == 0) {
        buffer.writeln(line.content);
        continue;
      }

      final diff = line.indentationLevel - smallestIndentationLevel;
      final spaces = _generateIndentation(indentationLevel + diff);

      buffer
        ..write(spaces)
        ..writeln(line.content);
    }

    return buffer.toString();
  }

  Iterable<_Line> _processLines() sync* {
    for (final line in LineSplitter.split(_value)) {
      final indentationMatch = _indentation.stringMatch(line);
      final indentationLevel =
          indentationMatch != null && indentationMatch.isNotEmpty
              ? indentationMatch.length
              : 0;

      yield _Line(indentationLevel, line.trim());
    }
  }

  int _findSmallestIndentation(Iterable<_Line> lines) {
    int smallestIndentation;

    for (final line in lines) {
      if (smallestIndentation == null ||
          line.indentationLevel < smallestIndentation) {
        smallestIndentation = line.indentationLevel;
      }
    }

    return smallestIndentation ?? 0;
  }

  String _generateIndentation(int indentationLevel) {
    return indentationLevel > 0
        ? List.generate(indentationLevel, (_) => ' ').join()
        : '';
  }
}

class _Line {
  _Line(this.indentationLevel, this.content);
  final int indentationLevel;
  final String content;
}
