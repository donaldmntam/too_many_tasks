// import 'channel.dart';

// interface class Slave<T> {
//   _State<T> _state;

//   Slave(Channel<T> channel) : _state = _Active(channel);

//   void listen(void Function(T) listener) => switch (_state) {
//     _Active(channel: final channel) => channel.listen(listener),
//     _Disposed() => (),
//   };

//   void dispose() => switch (_state) {
//     _Active() => this._state = const _Disposed(),
//     _Disposed() => (),
//   };
// }

// class Master<T> {
//   _State<T> _state;

//   Master(Channel<T> channel) : _state = _Active(channel);

//   void transmit(T message) => switch (_state) {
//     _Active(channel: final channel) => channel.transmit(message),
//     _Disposed() => (),
//   };

//   void stop() => switch (_state) {
//     _Active(channel: final channel) => channel.drop(),
//     _Disposed() => (),
//   };

//   void dispose() => switch (_state) {
//     _Active() => this._state = const _Disposed(),
//     _Disposed() => (),
//   };
// }

// (Slave<T>, Master<T>) channel<T>() {
//   final channel = Channel<T>();
//   return (Slave(channel), Master(channel));
// }

// sealed class _State<T> {}

// final class _Active<T> implements _State<T> {
//   final Channel<T> channel;

//   const _Active(this.channel);
// }

// final class _Disposed<T> implements _State<T> {
//   const _Disposed();
// }