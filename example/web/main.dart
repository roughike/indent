import 'dart:async';
import 'dart:html';

import 'package:indent/indent.dart';

void main() {
  final TextAreaElement text = document.getElementById('text');
  _startMonitoringIndentationLevel(text);

  text.value = text.value.indent(10);

  document.getElementById('decrease').onClick.listen((_) {
    text.value = text.value.indentBy(-1);
  });

  document.getElementById('increase').onClick.listen((_) {
    text.value = text.value.indentBy(1);
  });

  document.getElementById('strip-extra-indent').onClick.listen((_) {
    text.value = text.value.unindent();
  });

  document.getElementById('with-ten-indentation').onClick.listen((_) {
    text.value = text.value.indent(10);
  });
}

void _startMonitoringIndentationLevel(TextAreaElement text) {
  // Yup, you should not do this in real world. This is just a lazy
  // quick hack in an example app of a string indentation library.
  // Don't come at me, you!
  Timer.periodic(const Duration(milliseconds: 100), (_) {
    document.getElementById('indentation-level').innerText =
        text.value.getIndentationLevel().toString();
  });
}
