# indent

[![pub package](https://img.shields.io/pub/v/indent.svg)](https://pub.dartlang.org/packages/indent)
 [![Build Status](https://travis-ci.org/roughike/indent.svg?branch=master)](https://travis-ci.org/roughike/indent) 
 [![Coverage Status](https://coveralls.io/repos/github/roughike/indent/badge.svg?branch=master)](https://coveralls.io/github/roughike/indent?branch=master)

Utilities for changing indentation in a String for Dart while preserving relative indentation.

An ugly optimized GIF speaks more than a thousand words:

![A screencast of the example app in action](https://github.com/roughike/indent/raw/master/indent.gif)

## Methods

If you found this library from a Google search, you're probably looking for the `unindent()` method. It's a little similar to Java 12's `align()`, or maybe Scala's `stripMargin()`. I wouldn't know though.

Here's what `unindent` does:

```dart
final unindented = const Indentation('''
          Hello
        there
             World!
''').unindent();
```

becomes:

```
  Hello
there
     World!
```
