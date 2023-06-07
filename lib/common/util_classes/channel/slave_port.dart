// import 'channel.dart';
// import 'ports.dart';

// class SlavePort<M, S> {
//   final Channel<MasterSignal<M>> _masterChannel;
//   final Channel<S> _slaveChannel;
//   _State<M> _state = _NotListening();

//   SlavePort({
//     required Channel<MasterSignal<M>> masterChannel,
//     required Channel<S> slaveChannel,
//   }) : _masterChannel = masterChannel,
//     _slaveChannel = slaveChannel {
//     _masterChannel.listen((signal) {
//       switch (signal) {
//         case MasterMessage(message: final message):
//           switch (_state) {
//             case _NotListening(signals: final signals):
//               signals.add(signal);
//             case _Listening(messageListener: final messageListener):
//               messageListener(message);
//             case _Dropped():
//               break;
//           }
//         case MasterDropRequest():
//           _drop();
//       }
//     });
//   }

//   void listen(void Function(M) listener) {
//     final state = _state;
//     switch (state) {
//       case _NotListening(signals: final signals):
//         for (final signal in signals) {
//           switch (signal) {
//             case MasterMessage<M>(message: final message):
//               listener(message);
//             case MasterDropRequest():
//               _drop();
//           }
//         }
//         _state = _Listening(listener);
//       case _Listening():
//         throw "SlavePort listened for more than once!";
//       case _Dropped():  
//         break;
//     }
//   }

//   void transmit(S message) {
//     final state = _state;
//     switch (state) {
//       case _Dropped():
//         break;
//       default:
//         _slaveChannel.transmit(message);
//     }
//   }

//   void _drop() {
//     final state = _state;
//     if (state is! _Dropped) {
//       throw "Slave channel dropped more than once!";
//     }
//     _state = const _Dropped();
//   }
// }

// sealed class _State<T> {}

// final class _NotListening<T> implements _State<T> {
//   final List<MasterSignal<T>> signals;

//   _NotListening([
//     List<MasterSignal<T>>? signals
//   ]) : signals = List.empty(growable: true);
// }

// final class _Listening<T> implements _State<T> {
//   final void Function(T signal) messageListener;

//   const _Listening(
//     this.messageListener,
//   );
// }

// final class _Dropped implements _State<Never> {
//   const _Dropped();
// }