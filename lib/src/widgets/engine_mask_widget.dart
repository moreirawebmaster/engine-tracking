import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/material.dart';

/// Widget to mask sensitive content in recordings
///
/// Use this widget to wrap elements that contain sensitive information
/// that should not appear in recorded sessions.
///
/// Example:
/// ```dart
/// EngineMaskWidget(
///   child: Text('Sensitive information'),
/// )
/// ```
class EngineMaskWidget extends StatelessWidget {
  /// Creates a new EngineMaskWidget
  ///
  /// [child] The widget to mask
  const EngineMaskWidget({
    required this.child,
    super.key,
  });

  /// The widget to mask from recordings
  final Widget child;

  @override
  Widget build(final BuildContext context) => ClarityMask(
    child: child,
  );
}

/// Widget to unmask content within a masked area
///
/// Use this widget when you need to show specific content
/// within an area that has been masked with EngineMaskWidget.
///
/// Example:
/// ```dart
/// EngineMaskWidget(
///   child: Column(
///     children: [
///       Text('Sensitive information'),
///       EngineUnmaskWidget(
///         child: Text('Non-sensitive information'),
///       ),
///     ],
///   ),
/// )
/// ```
class EngineUnmaskWidget extends StatelessWidget {
  /// Creates a new EngineUnmaskWidget
  ///
  /// [child] The widget to unmask
  const EngineUnmaskWidget({
    required this.child,
    super.key,
  });

  /// The widget to unmask in recordings
  final Widget child;

  @override
  Widget build(final BuildContext context) => ClarityUnmask(
    child: child,
  );
}
