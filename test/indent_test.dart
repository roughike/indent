library indent.tests;

import 'package:expected_output/expected_output.dart';
import 'package:test/test.dart';
import 'package:indent/indent.dart';

void main() {
  for (final dataCase
      in dataCasesInFile(path: 'test/with_0_indentation.unit')) {
    test(dataCase.description, () {
      final actual = dataCase.input.indent(0);
      expect(actual, equals(dataCase.expectedOutput));
    });
  }

  test('null, empty, and blank inputs', () {
    expect(null.indent(), isNull);
    expect(''.indent(), equals(''));
    expect('    '.indent(), equals('    '));
  });
}
