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
  BottomSheet? _speechBubble;

  void shouldSetSpeechBubble(BottomSheet? speechBubble) {
    _speechBubble = speechBubble;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bottomSheet = _speechBubble;

    return OverlayService(
      shouldSetBottomSheet: shouldSetSpeechBubble,
      child: Stack(
        children: [
          widget.child,
          Backdrop(enabled: _speechBubble != null),
          if (bottomSheet != null) Align(
            alignment: Alignment.bottomCenter,
            child: bottomSheet.builder(context),
          ),
        ],
      ),
    );
  }
}

