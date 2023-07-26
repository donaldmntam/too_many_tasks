typedef Task = ({
  String name,
  DateTime dueDate,
  bool done,
  bool pinned,
});

extension ExtendedTask on Task {
  Task copy({
    String? name,
    DateTime? dueDate,
    bool? done,
    bool? pinned,
  }) => (
    name: name ?? this.name,
    dueDate: dueDate ?? this.dueDate,
    done: done ?? this.done,
    pinned: pinned ?? this.pinned,
  );
}

typedef TaskPreset = ({
  String name,
});