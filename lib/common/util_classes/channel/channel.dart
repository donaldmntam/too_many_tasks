final class Channel<T> {
  // _State<T> _state = _Inactive();
  void Function(T)? _listener;

  void listen(void Function(T signal) listener) {
    _listener = listener;
  }

  void transmit(T signal) {
    _listener?.call(signal);
  }

  void stopListening() {
    _listener = null;
  }
}

// sealed class _State<T> {}

// final class _Inactive<T> implements _State<T> {
//   final List<T> signals;

//   _Inactive([
//     List<T>? signals
//   ]) : signals = List.empty(growable: true);
// }

// final class _Active<T> implements _State<T> {
//   final void Function(T signal) messageListener;

//   const _Active(
//     this.messageListener,
//   );
// }