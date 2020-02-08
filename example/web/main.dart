import 'dart:html';

import 'package:indent/indent.dart';

void main() {
  final TextAreaElement text = document.getElementById('text');
  _updateIndentationLevelInfo(text);
  text.onKeyUp
      .listen((e) => _updateIndentationLevelInfo(e.target as TextAreaElement));
  text.onChange
      .listen((e) => _updateIndentationLevelInfo(e.target as TextAreaElement));

  text.value = text.value.withIndentationLevel(10);

  document.getElementById('decrease').onClick.listen((_) {
    text.value = text.value.decreaseIndentationBy(1);
  });

  document.getElementById('increase').onClick.listen((_) {
    text.value = text.value.increaseIndentationBy(1);
  });

  document.getElementById('strip-extra-indent').onClick.listen((_) {
    text.value = text.value.stripExtraIndentation();
  });
}

void _updateIndentationLevelInfo(TextAreaElement text) {
  document.getElementById('indentation-level').innerText =
      text.value.indentationLevel.toString();
}
