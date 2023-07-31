import 'package:too_many_tasks/common/models/task.dart';

sealed class State {
  State copy();
}

final class Start implements State {
  const Start();

  @override
  Start copy() => const Start();
}

final class Loading implements State {
  const Loading();

  @override
  Loading copy() => const Loading();
}

final class Ready implements State {
  final List<TaskPreset> presets;

  const Ready({
    required this.presets
  });

  @override
  Ready copy() => Ready(
    presets: presets.toList(),
  );
}

final class FailedToLoad implements State {
  const FailedToLoad();

  @override
  FailedToLoad copy() => const FailedToLoad();
}
