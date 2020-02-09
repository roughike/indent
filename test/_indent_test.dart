library indent.tests;

import 'package:expected_output/expected_output.dart';
import 'package:test/test.dart';
import 'package:indent/indent.dart';

void main() {
  _runDatacase(
    'indentation_level_counts',
    (input) => input.getIndentationLevel(),
    (output) => int.parse(output),
  );

  // withIndentationLevel(0) and stripExtraIndentation are the same thing
  _runDatacase('with_0_indentation', (input) => input.withIndentationLevel(0));
  _runDatacase('with_0_indentation', (input) => input.unindent());
  _runDatacase(
    'with_3_indentation',
    (input) => input.withIndentationLevel(3),
  );

  _runDatacase('increase_indentation_by_3', (input) => input.indentBy(3));
  _runDatacase('decrease_indentation_by_3', (input) => input.indentBy(-3));

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
    expect(null.withIndentationLevel(0), '');
    expect(''.withIndentationLevel(0), equals(''));
    expect('    '.withIndentationLevel(0), equals(''));
  });
}

void _runDatacase(
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
