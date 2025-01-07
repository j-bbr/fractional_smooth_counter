import 'package:flutter/widgets.dart';

/// A controller for a [SmoothCounter].
class SmoothCounterController extends ValueNotifier<double> {
  SmoothCounterController({
    this.initialCount = 0,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutCubic,
  }) : super(initialCount);

  /// The initial count of the counter.
  /// default: 0
  final double initialCount;

  /// The duration of the animation.
  /// default: 500ms
  final Duration duration;

  /// The curve of the animation.
  /// default: easeOutCubic
  final Curve curve;

  /// The current count of the counter.
  /// Same as [value].
  double get count => value;

  /// Sets the current count of the counter.
  /// Same as [value].
  set count(double newValue) => value = newValue;
}
