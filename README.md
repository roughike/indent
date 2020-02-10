# indent

[![pub package](https://img.shields.io/pub/v/indent.svg)](https://pub.dartlang.org/packages/indent)
 [![Build Status](https://travis-ci.org/roughike/indent.svg?branch=master)](https://travis-ci.org/roughike/indent) 
 [![Coverage Status](https://coveralls.io/repos/github/roughike/indent/badge.svg?branch=master)](https://coveralls.io/github/roughike/indent?branch=master)

Change indentation in multiline Dart strings while preserving the existing relative indentation.

A

GIF speaks more than a thousand words:

![A screencast of the example app in action](https://github.com/roughike/indent/raw/master/indent.gif)

## Features

### unindent()

If you found this library from a Google search, you're probably looking for the `unindent()` method.
It's the use case this library was originally created for.

For example, this:

```dart
print('''
          Hello
        there
             World!
'''.unindent());
```

outputs this:

```
  Hello
there
     World!
```

It gets rid of the common indentation while preserving the relative indentation. This is like [Kotlin's trimIndent()](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.text/trim-indent.html) or Java 12's `align()`.

### indent(int indentationLevel)

Indents a string with the desired indentation level while preserving relative indentation.

For example, this:

```dart
print('''
   Hello
World
'''.indent(2));
```

prints:

```
     Hello
  World
```

If the starting indentation level is higher than the desired one, the value will be unindented accordingly.

This:

```dart
print('''
          Hello
       World
'''.indent(2));
```

also prints:

```
     Hello
  World
```

### indentBy(int howMuch)

Changes the indentation level in a string by `howMuch`.

For example, this:

```dart
print('''
       Hello
    World
'''.indentBy(2));
```

prints:

```
       Hello
    World
```

while this:

```dart
print('''
       Hello
    World
'''.indentBy(-4));
```

prints:

```
   Hello
World
```
