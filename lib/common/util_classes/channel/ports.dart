import 'channel.dart';

class MasterPort<M, S> {
  final Channel<M> _masterChannel;
  Channel<S>? _slaveChannel;

  MasterPort(this._masterChannel);

  void listen(void Function(S) listener) {
    final slaveChannel = _slaveChannel;
    if (slaveChannel == null) {
      throwOnNullSlaveChannel();
    }
    slaveChannel.listen(listener);
  }

  void transmit(M message) {
    final slaveChannel = _slaveChannel;
    if (slaveChannel == null) {
      throwOnNullSlaveChannel();
    }
    _masterChannel.transmit(message);
  }

  void dropSlave() {
    final slaveChannel = _slaveChannel;
    if (slaveChannel == null) {
      throwOnNullSlaveChannel();
    }
    slaveChannel.stopListening();
    _slaveChannel = null;
  }
}

class SlavePort<M, S> {
  final Channel<M> _masterChannel;
  final Channel<S> _slaveChannel;
  _SlaveState<M> _state = _SlaveNotListening();

  SlavePort(
    Channel<M> masterChannel,
    Channel<S> slaveChannel,
  ) : _masterChannel = masterChannel,
    _slaveChannel = slaveChannel {
    _masterChannel.listen((signal) {
      switch (_state) {
        case _SlaveNotListening(signals: final signals):
          signals.add(signal);
        case _SlaveListening(messageListener: final messageListener):
          messageListener(signal);
        case _SlaveDropped():
          break;
      }
    });
  }

  void listen(void Function(M) listener) {
    final state = _state;
    switch (state) {
      case _SlaveNotListening(signals: final signals):
        for (final signal in signals) {
          listener(signal);
        }
        _state = _SlaveListening(listener);
      case _SlaveListening():
        throw "SlavePort listened for more than once!";
      case _SlaveDropped():  
        break;
    }
  }

  void transmit(S message) {
    final state = _state;
    switch (state) {
      case _SlaveDropped():
        break;
      default:
        _slaveChannel.transmit(message);
    }
  }
  // void _drop() {
  //   final state = _state;
  //   if (state is! _SlaveDropped) {
  //     throw "Slave channel dropped more than once!";
  //   }
  //   _state = const _SlaveDropped();
  // }
}

sealed class _SlaveState<T> {}

final class _SlaveNotListening<T> implements _SlaveState<T> {
  final List<T> signals;

  _SlaveNotListening([
    List<T>? signals
  ]) : signals = List.empty(growable: true);
}

final class _SlaveListening<T> implements _SlaveState<T> {
  final void Function(T signal) messageListener;

  const _SlaveListening(
    this.messageListener,
  );
}

final class _SlaveDropped implements _SlaveState<Never> {
  const _SlaveDropped();
}

MasterPort<M, S> masterPort<M, S>() {
  return MasterPort(Channel());
}

(MasterPort<M, S>, SlavePort<M, S>) ports<M, S>() {
  final masterChannel = Channel<M>();
  final slaveChannel = Channel<S>();
  final masterPort = MasterPort<M, S>(masterChannel);
  final slavePort = SlavePort<M, S>(masterChannel, slaveChannel);
  return (masterPort, slavePort);
}

void connect<M, S>(MasterPort<M, S> masterPort, SlavePort<M, S> slavePort) {
  masterPort._slaveChannel = slavePort._slaveChannel;
}

Never throwOnNullSlaveChannel() {
  throw "MasterPort was called to transmit before it was connected!";
}