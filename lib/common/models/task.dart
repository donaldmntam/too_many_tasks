typedef Task = ({
  String name,
  DateTime dueDate,
  bool done,
});

extension ExtendedTask on Task {
  Task copy({
    String? name,
    DateTime? dueDate,
    bool? done,
  }) => (
    name: name ?? this.name,
    dueDate: dueDate ?? this.dueDate,
    done: done ?? this.done,
  );
}

typedef TaskPreset = ({
  String name,
});