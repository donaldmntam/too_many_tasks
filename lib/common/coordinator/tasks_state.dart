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
  final List<Task> tasks;

  const Ready({
    required this.tasks
  });

  @override
  Ready copy() => Ready(
    tasks: tasks.toList(),
  );
}

final class FailedToLoad implements State {
  const FailedToLoad();

  @override
  FailedToLoad copy() => const FailedToLoad();
}
