/*
 * Copyright (c) 2022 MyLittleSuite
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'dart:collection';

import 'package:customized_flavorizr/exception/existing_flavor_dimensions_exception.dart';
import 'package:customized_flavorizr/exception/malformed_resource_exception.dart';
import 'package:customized_flavorizr/parser/models/flavorizr.dart';
import 'package:customized_flavorizr/parser/models/flavors/android/res_value.dart';
import 'package:customized_flavorizr/processors/commons/string_processor.dart';

class ModifiedMainTargetProcessor extends StringProcessor {
  static const String entryPoint = '{';
  final String flavorName;
  ModifiedMainTargetProcessor(
    this.flavorName, {
    String? input,
    required Flavorizr config,
  }) : super(
          input: input,
          config: config,
        );

  @override
  String execute() {
    final int androidPosition = this.input!.indexOf(entryPoint);

    if (androidPosition < 0) {
      throw MalformedResourceException(this.input!);
    }

    StringBuffer buffer = StringBuffer();
    _appendImport(buffer);
    _appendStartContent(buffer, androidPosition);
    _appendFlavorsDimension(buffer);

    _appendEndContent(buffer, androidPosition);

    return buffer.toString();
  }

  void _appendImport(StringBuffer buffer) {
    buffer.writeln("import 'flavors.dart';");
  }

  void _appendStartContent(StringBuffer buffer, int androidPosition) {
    buffer.writeln(this.input!.substring(0, androidPosition + entryPoint.length));
  }

  void _appendFlavorsDimension(StringBuffer buffer) {
    buffer.writeln('  F.appFlavor = Flavor.${flavorName.toUpperCase()};');
  }

  void _appendEndContent(StringBuffer buffer, int androidPosition) {
    buffer.write(this.input!.substring(androidPosition + entryPoint.length + 1));
  }

  @override
  String toString() => 'ModifiedMainTargetProcessor';
}
