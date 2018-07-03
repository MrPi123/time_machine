// Portions of this work are Copyright 2018 The Time Machine Authors. All rights reserved.
// Portions of this work are Copyright 2018 The Noda Time Authors. All rights reserved.
// Use of this source code is governed by the Apache License 2.0, as found in the LICENSE.txt file.

import 'dart:async';

import 'package:time_machine/src/time_machine_internal.dart';

import 'package:test/test.dart';

import '../time_machine_testing.dart';
import 'pattern_test_base.dart';
import 'pattern_test_data.dart';
import 'test_cultures.dart';

Future main() async {
  await runTests();
}

@Test()
class OffsetPatternTest extends PatternTestBase<Offset> {
  /// A non-breaking space.
  static const String Nbsp = "\u00a0";

  /// Test data that can only be used to test formatting.
  @internal final List<Data> FormatOnlyData = [
    new Data.hms(3, 0, 0)
      ..culture = TestCultures.EnUs
      ..text = ""
      ..pattern = "%-",
    new Data.hms(5, 0, 0)
      ..culture = TestCultures.EnUs
      ..text = "+05"
      ..pattern = "g",
    new Data.hms(5, 12, 0)
      ..culture = TestCultures.EnUs
      ..text = "+05:12"
      ..pattern = "g",
    new Data.hms(5, 12, 34)
      ..culture = TestCultures.EnUs
      ..text = "+05:12:34"
      ..pattern = "g",

    // Losing information
    new Data.hms(5, 6, 7)
      ..culture = TestCultures.EnUs
      ..text = "05"
      ..pattern = "HH",
    new Data.hms(5, 6, 7)
      ..culture = TestCultures.EnUs
      ..text = "06"
      ..pattern = "mm",
    new Data.hms(5, 6, 7)
      ..culture = TestCultures.EnUs
      ..text = "07"
      ..pattern = "ss",
    new Data.hms(5, 6, 7)
      ..culture = TestCultures.EnUs
      ..text = "5"
      ..pattern = "%H",
    new Data.hms(5, 6, 7)
      ..culture = TestCultures.EnUs
      ..text = "6"
      ..pattern = "%m",
    new Data.hms(5, 6, 7)
      ..culture = TestCultures.EnUs
      ..text = "7"
      ..pattern = "%s",

    new Data(Offset.maxValue)
      ..culture = TestCultures.EnUs
      ..text = "+18"
      ..pattern = "g",
    new Data(Offset.maxValue)
      ..culture = TestCultures.EnUs
      ..text = "18"
      ..pattern = "%H",
    new Data(Offset.maxValue)
      ..culture = TestCultures.EnUs
      ..text = "0"
      ..pattern = "%m",
    new Data(Offset.maxValue)
      ..culture = TestCultures.EnUs
      ..text = "0"
      ..pattern = "%s",
    new Data(Offset.maxValue)
      ..culture = TestCultures.EnUs
      ..text = "m"
      ..pattern = "\\m",
    new Data(Offset.maxValue)
      ..culture = TestCultures.EnUs
      ..text = "m"
      ..pattern = "'m'",
    new Data(Offset.maxValue)
      ..culture = TestCultures.EnUs
      ..text = "mmmmmmmmmm"
      ..pattern = "'mmmmmmmmmm'",
    new Data(Offset.maxValue)
      ..culture = TestCultures.EnUs
      ..text = "z"
      ..pattern = "'z'",
    new Data(Offset.maxValue)
      ..culture = TestCultures.EnUs
      ..text = "zqw"
      ..pattern = "'zqw'",
    new Data.hms(3, 0, 0, true)
      ..culture = TestCultures.EnUs
      ..text = "-"
      ..pattern = "%-",
    new Data.hms(3, 0, 0)
      ..culture = TestCultures.EnUs
      ..text = "+"
      ..pattern = "%+",
    new Data.hms(3, 0, 0, true)
      ..culture = TestCultures.EnUs
      ..text = "-"
      ..pattern = "%+",
    new Data.hms(5, 12, 34)
      ..culture = TestCultures.EnUs
      ..text = "+05"
      ..pattern = "s",
    new Data.hms(5, 12, 34)
      ..culture = TestCultures.EnUs
      ..text = "+05:12"
      ..pattern = "m",
    new Data.hms(5, 12, 34)
      ..culture = TestCultures.EnUs
      ..text = "+05:12:34"
      ..pattern = "l",
  ];

  /// Test data that can only be used to test successful parsing.
  @internal final List<Data> ParseOnlyData = [
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "*"
      ..pattern = "%*",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "zqw"
      ..pattern = "'zqw'",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "-"
      ..pattern = "%-",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "+"
      ..pattern = "%+",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "-"
      ..pattern = "%+",
    new Data.hms(5, 0, 0)
      ..culture = TestCultures.EnUs
      ..text = "+05"
      ..pattern = "s",
    new Data.hms(5, 12, 0)
      ..culture = TestCultures.EnUs
      ..text = "+05:12"
      ..pattern = "m",
    new Data.hms(5, 12, 34)
      ..culture = TestCultures.EnUs
      ..text = "+05:12:34"
      ..pattern = "l",
    new Data(Offset.zero)
      ..pattern = "Z+HH:mm"
      ..text = "+00:00" // Lenient when parsing Z-prefixed patterns.
  ];

  /// Test data for invalid patterns
  @internal final List<Data> InvalidPatternData = [
    new Data(Offset.zero)
      ..pattern = ""
      ..message = TextErrorMessages.formatStringEmpty,
    new Data(Offset.zero)
      ..pattern = "%Z"
      ..message = TextErrorMessages.emptyZPrefixedOffsetPattern,
    new Data(Offset.zero)
      ..pattern = "HH:mmZ"
      ..message = TextErrorMessages.zPrefixNotAtStartOfPattern,
    new Data(Offset.zero)
      ..pattern = "%%H"
      ..message = TextErrorMessages.percentDoubled,
    new Data(Offset.zero)
      ..pattern = "HH:HH"
      ..message = TextErrorMessages.repeatedFieldInPattern
      ..parameters.addAll(['H']),
    new Data(Offset.zero)
      ..pattern = "mm:mm"
      ..message = TextErrorMessages.repeatedFieldInPattern
      ..parameters.addAll(['m']),
    new Data(Offset.zero)
      ..pattern = "ss:ss"
      ..message = TextErrorMessages.repeatedFieldInPattern
      ..parameters.addAll(['s']),
    new Data(Offset.zero)
      ..pattern = "+HH:-mm"
      ..message = TextErrorMessages.repeatedFieldInPattern
      ..parameters.addAll(['-']),
    new Data(Offset.zero)
      ..pattern = "-HH:+mm"
      ..message = TextErrorMessages.repeatedFieldInPattern
      ..parameters.addAll(['+']),
    new Data(Offset.zero)
      ..pattern = "!"
      ..message = TextErrorMessages.unknownStandardFormat
      ..parameters.addAll(['!', 'Offset']),
    new Data(Offset.zero)
      ..pattern = "%"
      ..message = TextErrorMessages.unknownStandardFormat
      ..parameters.addAll(['%', 'Offset']),
    new Data(Offset.zero)
      ..pattern = "%%"
      ..message = TextErrorMessages.percentDoubled,
    new Data(Offset.zero)
      ..pattern = "%\\"
      ..message = TextErrorMessages.escapeAtEndOfString,
    new Data(Offset.zero)
      ..pattern = "\\"
      ..message = TextErrorMessages.unknownStandardFormat
      ..parameters.addAll(['\\', 'Offset']),
    new Data(Offset.zero)
      ..pattern = "H%"
      ..message = TextErrorMessages.percentAtEndOfString,
    new Data(Offset.zero)
      ..pattern = "hh"
      ..message = TextErrorMessages.hour12PatternNotSupported
      ..parameters.addAll(['Offset']),
    new Data(Offset.zero)
      ..pattern = "HHH"
      ..message = TextErrorMessages.repeatCountExceeded
      ..parameters.addAll(['H', 2]),
    new Data(Offset.zero)
      ..pattern = "mmm"
      ..message = TextErrorMessages.repeatCountExceeded
      ..parameters.addAll(['m', 2]),
    new Data(Offset.zero)
      ..pattern = "mmmmmmmmmmmmmmmmmmm"
      ..message = TextErrorMessages.repeatCountExceeded
      ..parameters.addAll(['m', 2]),
    new Data(Offset.zero)
      ..pattern = "'qwe"
      ..message = TextErrorMessages.missingEndQuote
      ..parameters.addAll(['\'']),
    new Data(Offset.zero)
      ..pattern = "'qwe\\"
      ..message = TextErrorMessages.escapeAtEndOfString,
    new Data(Offset.zero)
      ..pattern = "'qwe\\'"
      ..message = TextErrorMessages.missingEndQuote
      ..parameters.addAll(['\'']),
    new Data(Offset.zero)
      ..pattern = "sss"
      ..message = TextErrorMessages.repeatCountExceeded
      ..parameters.addAll(['s', 2]),
  ];

  /// Tests for parsing failures (of values)
  @internal final List<Data> ParseFailureData = [
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = ""
      ..pattern = "g"
      ..message = TextErrorMessages.valueStringEmpty,
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "1"
      ..pattern = "HH"
      ..message = TextErrorMessages.mismatchedNumber
      ..parameters.addAll(["HH"]),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "1"
      ..pattern = "mm"
      ..message = TextErrorMessages.mismatchedNumber
      ..parameters.addAll(["mm"]),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "1"
      ..pattern = "ss"
      ..message = TextErrorMessages.mismatchedNumber
      ..parameters.addAll(["ss"]),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "12:34 "
      ..pattern = "HH:mm"
      ..message = TextErrorMessages.extraValueCharacters
      ..parameters.addAll([" "]),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "1a"
      ..pattern = "H "
      ..message = TextErrorMessages.mismatchedCharacter
      ..parameters.addAll([' ']),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "2:"
      ..pattern = "%H"
      ..message = TextErrorMessages.extraValueCharacters
      ..parameters.addAll([":"]),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "a"
      ..pattern = "%."
      ..message = TextErrorMessages.mismatchedCharacter
      ..parameters.addAll(['.']),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "a"
      ..pattern = "%:"
      ..message = TextErrorMessages.timeSeparatorMismatch,
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "a"
      ..pattern = "%H"
      ..message = TextErrorMessages.mismatchedNumber
      ..parameters.addAll(["H"]),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "a"
      ..pattern = "%m"
      ..message = TextErrorMessages.mismatchedNumber
      ..parameters.addAll(["m"]),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "a"
      ..pattern = "%s"
      ..message = TextErrorMessages.mismatchedNumber
      ..parameters.addAll(["s"]),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "a"
      ..pattern = ".H"
      ..message = TextErrorMessages.mismatchedCharacter
      ..parameters.addAll(['.']),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "a"
      ..pattern = "\\'"
      ..message = TextErrorMessages.escapedCharacterMismatch
      ..parameters.addAll(['\'']),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "axc"
      ..pattern = "'abc'"
      ..message = TextErrorMessages.quotedStringMismatch,
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "z"
      ..pattern = "%*"
      ..message = TextErrorMessages.mismatchedCharacter
      ..parameters.addAll(['*']),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "24"
      ..pattern = "HH"
      ..message = TextErrorMessages.fieldValueOutOfRange
      ..parameters.addAll([24, 'H', 'Offset']),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "60"
      ..pattern = "mm"
      ..message = TextErrorMessages.fieldValueOutOfRange
      ..parameters.addAll([60, 'm', 'Offset']),
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "60"
      ..pattern = "ss"
      ..message = TextErrorMessages.fieldValueOutOfRange
      ..parameters.addAll([60, 's', 'Offset']),
    new Data(Offset.zero)
      ..text = "+12"
      ..pattern = "-HH"
      ..message = TextErrorMessages.positiveSignInvalid,
  ];

  /// Common test data for both formatting and parsing. A test should be placed here unless is truly
  /// cannot be run both ways. This ensures that as many round-trip type tests are performed as possible.
  @internal final List<Data> FormatAndParseData = [
/*XXX*/ new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "."
      ..pattern = "%.", // decimal separator
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = ":"
      ..pattern = "%:", // date separator
/*XXX*/ new Data(Offset.zero)
      ..culture = TestCultures.DotTimeSeparator
      ..text = "."
      ..pattern = "%.", // decimal separator (always period)
    new Data(Offset.zero)
      ..culture = TestCultures.DotTimeSeparator
      ..text = "."
      ..pattern = "%:", // date separator
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "H"
      ..pattern = "\\H",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "HHss"
      ..pattern = "'HHss'",
    new Data.hms(0, 0, 12)
      ..culture = TestCultures.EnUs
      ..text = "12"
      ..pattern = "%s",
    new Data.hms(0, 0, 12)
      ..culture = TestCultures.EnUs
      ..text = "12"
      ..pattern = "ss",
    new Data.hms(0, 0, 2)
      ..culture = TestCultures.EnUs
      ..text = "2"
      ..pattern = "%s",
    new Data.hms(0, 12, 0)
      ..culture = TestCultures.EnUs
      ..text = "12"
      ..pattern = "%m",
    new Data.hms(0, 12, 0)
      ..culture = TestCultures.EnUs
      ..text = "12"
      ..pattern = "mm",
    new Data.hms(0, 2, 0)
      ..culture = TestCultures.EnUs
      ..text = "2"
      ..pattern = "%m",

    new Data.hms(12, 0, 0)
      ..culture = TestCultures.EnUs
      ..text = "12"
      ..pattern = "%H",
    new Data.hms(12, 0, 0)
      ..culture = TestCultures.EnUs
      ..text = "12"
      ..pattern = "HH",
    new Data.hms(2, 0, 0)
      ..culture = TestCultures.EnUs
      ..text = "2"
      ..pattern = "%H",
    new Data.hms(2, 0, 0)
      ..culture = TestCultures.EnUs
      ..text = "2"
      ..pattern = "%H",

    // Standard patterns with punctuation...
    new Data.hms(5, 0, 0)
      ..culture = TestCultures.EnUs
      ..text = "+05"
      ..pattern = "G",
    new Data.hms(5, 12, 0)
      ..culture = TestCultures.EnUs
      ..text = "+05:12"
      ..pattern = "G",
    new Data.hms(5, 12, 34)
      ..culture = TestCultures.EnUs
      ..text = "+05:12:34"
      ..pattern = "G",
    new Data.hms(5, 0, 0)
      ..culture = TestCultures.EnUs
      ..text = "+05"
      ..pattern = "g",
    new Data.hms(5, 12, 0)
      ..culture = TestCultures.EnUs
      ..text = "+05:12"
      ..pattern = "g",
    new Data.hms(5, 12, 34)
      ..culture = TestCultures.EnUs
      ..text = "+05:12:34"
      ..pattern = "g",
    new Data(Offset.minValue)
      ..culture = TestCultures.EnUs
      ..text = "-18"
      ..pattern = "g",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "Z"
      ..pattern = "G",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "+00"
      ..pattern = "g",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "+00"
      ..pattern = "s",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "+00:00"
      ..pattern = "m",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "+00:00:00"
      ..pattern = "l",
    new Data.hms(5, 0, 0)
      ..culture = TestCultures.FrFr
      ..text = "+05"
      ..pattern = "g",
    new Data.hms(5, 12, 0)
      ..culture = TestCultures.FrFr
      ..text = "+05:12"
      ..pattern = "g",
    new Data.hms(5, 12, 34)
      ..culture = TestCultures.FrFr
      ..text = "+05:12:34"
      ..pattern = "g",
    new Data(Offset.maxValue)
      ..culture = TestCultures.FrFr
      ..text = "+18"
      ..pattern = "g",
    new Data(Offset.minValue)
      ..culture = TestCultures.FrFr
      ..text = "-18"
      ..pattern = "g",
    new Data.hms(5, 0, 0)
      ..culture = TestCultures.DotTimeSeparator
      ..text = "+05"
      ..pattern = "g",
    new Data.hms(5, 12, 0)
      ..culture = TestCultures.DotTimeSeparator
      ..text = "+05.12"
      ..pattern = "g",
    new Data.hms(5, 12, 34)
      ..culture = TestCultures.DotTimeSeparator
      ..text = "+05.12.34"
      ..pattern = "g",
    new Data(Offset.maxValue)
      ..culture = TestCultures.DotTimeSeparator
      ..text = "+18"
      ..pattern = "g",
    new Data(Offset.minValue)
      ..culture = TestCultures.DotTimeSeparator
      ..text = "-18"
      ..pattern = "g",

    // Standard patterns without punctuation
    new Data.hms(5, 0, 0)
      ..culture = TestCultures.EnUs
      ..text = "+05"
      ..pattern = "I",
    new Data.hms(5, 12, 0)
      ..culture = TestCultures.EnUs
      ..text = "+0512"
      ..pattern = "I",
    new Data.hms(5, 12, 34)
      ..culture = TestCultures.EnUs
      ..text = "+051234"
      ..pattern = "I",
    new Data.hms(5, 0, 0)
      ..culture = TestCultures.EnUs
      ..text = "+05"
      ..pattern = "i",
    new Data.hms(5, 12, 0)
      ..culture = TestCultures.EnUs
      ..text = "+0512"
      ..pattern = "i",
    new Data.hms(5, 12, 34)
      ..culture = TestCultures.EnUs
      ..text = "+051234"
      ..pattern = "i",
    new Data(Offset.minValue)
      ..culture = TestCultures.EnUs
      ..text = "-18"
      ..pattern = "i",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "Z"
      ..pattern = "I",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "+00"
      ..pattern = "i",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "+00"
      ..pattern = "S",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "+0000"
      ..pattern = "M",
    new Data(Offset.zero)
      ..culture = TestCultures.EnUs
      ..text = "+000000"
      ..pattern = "L",
    new Data.hms(5, 0, 0)
      ..culture = TestCultures.FrFr
      ..text = "+05"
      ..pattern = "i",
    new Data.hms(5, 12, 0)
      ..culture = TestCultures.FrFr
      ..text = "+0512"
      ..pattern = "i",
    new Data.hms(5, 12, 34)
      ..culture = TestCultures.FrFr
      ..text = "+051234"
      ..pattern = "i",
    new Data(Offset.maxValue)
      ..culture = TestCultures.FrFr
      ..text = "+18"
      ..pattern = "i",
    new Data(Offset.minValue)
      ..culture = TestCultures.FrFr
      ..text = "-18"
      ..pattern = "i",
    new Data.hms(5, 0, 0)
      ..culture = TestCultures.DotTimeSeparator
      ..text = "+05"
      ..pattern = "i",
    new Data.hms(5, 12, 0)
      ..culture = TestCultures.DotTimeSeparator
      ..text = "+0512"
      ..pattern = "i",
    new Data.hms(5, 12, 34)
      ..culture = TestCultures.DotTimeSeparator
      ..text = "+051234"
      ..pattern = "i",
    new Data(Offset.maxValue)
      ..culture = TestCultures.DotTimeSeparator
      ..text = "+18"
      ..pattern = "i",
    new Data(Offset.minValue)
      ..culture = TestCultures.DotTimeSeparator
      ..text = "-18"
      ..pattern = "i",

    // Explicit patterns
    new Data.hms(0, 30, 0, true)
      ..culture = TestCultures.EnUs
      ..text = "-00:30"
      ..pattern = "+HH:mm",
    new Data.hms(0, 30, 0, true)
      ..culture = TestCultures.EnUs
      ..text = "-00:30"
      ..pattern = "-HH:mm",
    new Data.hms(0, 30, 0, false)
      ..culture = TestCultures.EnUs
      ..text = "00:30"
      ..pattern = "-HH:mm",

    // Z-prefixes
    new Data(Offset.zero)
      ..text = "Z"
      ..pattern = "Z+HH:mm:ss",
    new Data.hms(5, 12, 34)
      ..text = "+05:12:34"
      ..pattern = "Z+HH:mm:ss",
    new Data.hms(5, 12)
      ..text = "+05:12"
      ..pattern = "Z+HH:mm",
  ];

  @internal Iterable<Data> get ParseData => [ParseOnlyData, FormatAndParseData].expand((x) => x);

  @internal Iterable<Data> get FormatData => [FormatOnlyData, FormatAndParseData].expand((x) => x);

  @Test()
  @TestCaseSource(#ParseData)
  void ParsePartial(PatternTestData<Offset> data) {
    data.TestParsePartial();
  }

  @Test()
  void ParseNull() => AssertParseNull(OffsetPattern.generalInvariant);

  /* -- It is very ignored here -- not even ported.
  @Test()
  void NumberFormatIgnored()
  {
    // var builder = new DateTimeFormatInfoBuilder(TestCultures.EnUs.dateTimeFormat);
    // builder.NumberFormat.PositiveSign = "P";
    var culture = TestCultures.EnUs;
    culture.NumberFormat.PositiveSign = "P";
    culture.NumberFormat.NegativeSign = "N";
    var pattern = OffsetPattern.Create("+HH:mm", culture);

    expect("+05:00", pattern.Format(new Offset.fromHours(5)));
    expect("-05:00", pattern.Format(new Offset.fromHours(-5)));
  }*/

  @Test()
  void CreateWithCurrentCulture() {
    // using (CultureSaver.SetCultures(TestCultures.DotTimeSeparator))
    Culture.current = TestCultures.DotTimeSeparator;
    {
      var pattern = OffsetPattern.createWithCurrentCulture("H:mm");
      var text = pattern.format(new Offset.fromHoursAndMinutes(1, 30));
      expect("1.30", text);
    }
  }
}

/// A container for test data for formatting and parsing [Offset] objects.
/*sealed*/class Data extends PatternTestData<Offset> {
  // Ignored anyway...
  /*protected*/ @override Offset get defaultTemplate => Offset.zero;

  Data(Offset value) : super(value);

  Data.hms(int hours, int minutes, [int seconds = 0, bool negative = false]) // : this(Offset.FromHoursAndMinutes(hours, minutes))
      : this(negative ? TestObjects.CreateNegativeOffset(hours, minutes, seconds) :
  TestObjects.CreatePositiveOffset(hours, minutes, seconds));

  /*
  Data(int hours, int minutes, int seconds)
      : this(TestObjects.CreatePositiveOffset(hours, minutes, seconds))
  {
  }

  Data(int hours, int minutes, int seconds, bool negative)
      : this(negative ? TestObjects.CreateNegativeOffset(hours, minutes, seconds) :
  TestObjects.CreatePositiveOffset(hours, minutes, seconds))
  {
  }*/

  @internal
  @override
  IPattern<Offset> CreatePattern() =>
      OffsetPattern.createWithInvariantCulture(super.pattern)
          .withCulture(culture);

  @internal
  @override
  IPartialPattern<Offset> CreatePartialPattern() =>
      OffsetPatterns.underlyingPattern(
      OffsetPattern
          .createWithInvariantCulture(super.pattern)
          .withCulture(culture));
}



