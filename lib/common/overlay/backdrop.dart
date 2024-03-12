import 'package:flutter/widgets.dart';

class Backdrop extends StatelessWidget {
  final bool enabled;

  const Backdrop({
    super.key,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Container(
        color: Color.fromARGB(
          enabled ? 100 : 0, 
          0,
          0,
          0,
        ),
      ),
    );
  }
}
