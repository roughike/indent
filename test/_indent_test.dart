library indent.tests;

import 'package:expected_output/expected_output.dart';
import 'package:test/test.dart';
import 'package:indent/indent.dart';

void main() {
  _runDataCase(
    'indentation_level_counts',
    (input) => input.getIndentationLevel(),
    (output) => int.parse(output),
  );

  // withIndentationLevel(0) and stripExtraIndentation are the same thing
  _runDataCase('with_0_indentation', (input) => input.indent(0));
  _runDataCase('with_0_indentation', (input) => input.unindent());
  _runDataCase('with_3_indentation', (input) => input.indent(3));

  _runDataCase('increase_indentation_by_3', (input) => input.indentBy(3));
  _runDataCase('decrease_indentation_by_3', (input) => input.indentBy(-3));

  _runDataCase('trim_margin_with_pipe', (input) => input.trimMargin());
  _runDataCase('trim_margin_with_pipe', (input) => input.trimMargin('|'));
  _runDataCase('trim_margin_with_hashbang', (input) => input.trimMargin('#!'));

  test('does not count empty line as indentation', () {
    expect(
      '''
    
        Hello World!
    '''
          .getIndentationLevel(),
      8,
    );
  });

  test('null, empty, and blank inputs', () {
    expect(null.indent(0), '');
    expect(''.indent(0), equals(''));
    expect('    '.indent(0), equals(''));
  });
}

void _runDataCase(
  String filename,
  dynamic Function(String) inputTransformer, [
  dynamic Function(String) outputTransformer,
]) {
  for (final dataCase in dataCasesInFile(path: 'test/$filename.unit')) {
    outputTransformer ??= (output) => output;

    test(dataCase.description, () {
      final actual = inputTransformer(dataCase.input);
      final expected = outputTransformer(dataCase.expectedOutput);
      expect(actual, equals(expected));
    });
  }
}
