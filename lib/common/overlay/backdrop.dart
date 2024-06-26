import 'package:flutter/widgets.dart';

class Backdrop extends StatelessWidget {
  final bool enabled;
  final void Function()? onTap;

  const Backdrop({
    super.key,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Color.fromARGB(
            enabled ? 100 : 0, 
            0,
            0,
            0,
          ),
        ),
      ),
    );
  }
}
