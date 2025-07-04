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
  const EngineMaskWidget({
    super.key,
    required this.child,
  });

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
  const EngineUnmaskWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(final BuildContext context) => ClarityUnmask(
    child: child,
  );
}
