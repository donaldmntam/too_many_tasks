import 'package:flutter/widgets.dart';
import './service.dart';
import './backdrop.dart';
import './bottom_sheet.dart';

class Overlay extends StatefulWidget {
  final Widget child;
  
  const Overlay({super.key, required this.child});
  
  @override
  State<Overlay> createState() => _State();
}

class _State extends State<Overlay> {
  BottomSheet? _bottomSheet;

  void shouldSetBottomSheet(BottomSheet? speechBubble) {
    _bottomSheet = speechBubble;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bottomSheet = _bottomSheet;

    return OverlayService(
      shouldSetBottomSheet: shouldSetBottomSheet,
      child: Stack(
        children: [
          widget.child,
          Backdrop(
            enabled: _bottomSheet != null,
            onTap: _bottomSheet?.onTapBackdrop,
          ),
          if (bottomSheet != null) Align(
            alignment: Alignment.bottomCenter,
            child: bottomSheet.builder(context),
          ),
        ],
      ),
    );
  }
}

