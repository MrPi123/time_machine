// Portions of this work are Copyright 2018 The Time Machine Authors. All rights reserved.
// Portions of this work are Copyright 2018 The Noda Time Authors. All rights reserved.
// Use of this source code is governed by the Apache License 2.0, as found in the LICENSE.txt file.

import 'package:meta/meta.dart';

import 'package:time_machine/src/time_machine_internal.dart';
import 'package:time_machine/src/text/globalization/time_machine_globalization.dart';
import 'package:time_machine/src/utility/time_machine_utilities.dart';
import 'package:time_machine/src/text/time_machine_text.dart';
import 'package:time_machine/src/text/patterns/time_machine_patterns.dart';

@internal
abstract class OffsetPatterns {
  static final PatternBclSupport<Offset> bclSupport = new PatternBclSupport<Offset>(OffsetPattern._defaultFormatPattern, (fi) => fi.offsetPatternParser);
  static IPartialPattern<Offset> underlyingPattern(OffsetPattern offsetPattern) => offsetPattern._underlyingPattern;

  static OffsetPattern create(String patternText, TimeMachineFormatInfo formatInfo) => OffsetPattern._create(patternText, formatInfo);
}

/// Represents a pattern for parsing and formatting [Offset] values.
@immutable
class OffsetPattern implements IPattern<Offset> {
  /// The "general" offset pattern (e.g. +HH, +HH:mm, +HH:mm:ss, +HH:mm:ss.fff) for the invariant culture.
  static final OffsetPattern generalInvariant = createWithInvariantCulture("g");

  /// The "general" offset pattern (e.g. +HH, +HH:mm, +HH:mm:ss, +HH:mm:ss.fff) for the invariant culture,
  /// but producing (and allowing) Z as a value for a zero offset.
  static final OffsetPattern generalInvariantWithZ = createWithInvariantCulture("G");

  static const String _defaultFormatPattern = "g";

  /// Gets the pattern text for this pattern, as supplied on creation.
  final String patternText;

  /// Returns the pattern that this object delegates to. Mostly useful to avoid this class
  /// implementing an @internal interface.
  final IPartialPattern<Offset> _underlyingPattern;

  OffsetPattern._(this.patternText, this._underlyingPattern);

  /// Parses the given text value according to the rules of this pattern.
  ///
  /// This method never throws an exception (barring a bug in Time Machine itself). Even errors such as
  /// the argument being null are wrapped in a parse result.
  ///
  /// [text]: The text value to parse.
  /// Returns: The result of parsing, which may be successful or unsuccessful.
  ParseResult<Offset> parse(String text) => _underlyingPattern.parse(text);

  /// Formats the given offset as text according to the rules of this pattern.
  ///
  /// [value]: The offset to format.
  /// Returns: The offset formatted according to this pattern.
  String format(Offset value) => _underlyingPattern.format(value);

  /// Formats the given value as text according to the rules of this pattern,
  /// appending to the given [StringBuilder].
  ///
  /// [value]: The value to format.
  /// [builder]: The `StringBuilder` to append to.
  /// Returns: The builder passed in as [builder].
  StringBuffer appendFormat(Offset value, StringBuffer builder) => _underlyingPattern.appendFormat(value, builder);

  /// Creates a pattern for the given pattern text and format info.
  ///
  /// [patternText]: Pattern text to create the pattern for
  /// [formatInfo]: Localization information
  /// Returns: A pattern for parsing and formatting offsets.
  /// [InvalidPatternException]: The pattern text was invalid.
  static OffsetPattern _create(String patternText, TimeMachineFormatInfo formatInfo) {
    Preconditions.checkNotNull(patternText, 'patternText');
    Preconditions.checkNotNull(formatInfo, 'formatInfo');
    var pattern = formatInfo.offsetPatternParser.parsePattern(patternText) as IPartialPattern<Offset>;
    return new OffsetPattern._(patternText, pattern);
  }

  /// Creates a pattern for the given pattern text and culture.
  ///
  /// See the user guide for the available pattern text options.
  ///
  /// [patternText]: Pattern text to create the pattern for
  /// [cultureInfo]: The culture to use in the pattern
  /// Returns: A pattern for parsing and formatting offsets.
  /// [InvalidPatternException]: The pattern text was invalid.
  static OffsetPattern createWithCulture(String patternText, Culture cultureInfo) =>
      _create(patternText, TimeMachineFormatInfo.getFormatInfo(cultureInfo));

  /// Creates a pattern for the given pattern text in the current thread's current culture.
  ///
  /// See the user guide for the available pattern text options. Note that the current culture
  /// is captured at the time this method is called - it is not captured at the point of parsing
  /// or formatting values.
  ///
  /// [patternText]: Pattern text to create the pattern for
  /// Returns: A pattern for parsing and formatting offsets.
  /// [InvalidPatternException]: The pattern text was invalid.
  static OffsetPattern createWithCurrentCulture(String patternText) =>
      _create(patternText, TimeMachineFormatInfo.currentInfo);

  /// Creates a pattern for the given pattern text in the invariant culture.
  ///
  /// See the user guide for the available pattern text options. Note that the current culture
  /// is captured at the time this method is called - it is not captured at the point of parsing
  /// or formatting values.
  ///
  /// [patternText]: Pattern text to create the pattern for
  /// Returns: A pattern for parsing and formatting offsets.
  /// [InvalidPatternException]: The pattern text was invalid.
  static OffsetPattern createWithInvariantCulture(String patternText) => _create(patternText, TimeMachineFormatInfo.invariantInfo);

  /// Creates a pattern for the same original pattern text as this pattern, but with the specified
  /// culture.
  ///
  /// [cultureInfo]: The culture to use in the new pattern.
  /// Returns: A new pattern with the given culture.
  OffsetPattern withCulture(Culture cultureInfo) => _create(patternText, TimeMachineFormatInfo.getFormatInfo(cultureInfo));
}
