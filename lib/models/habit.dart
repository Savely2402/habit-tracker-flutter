class Habit {
  final String id;
  final String title;
  final int target;
  int current;
  final DateTime createdAt;

  Habit({
    required this.id,
    required this.title,
    required this.target,
    this.current = 0,
    required this.createdAt,
  });

  Habit copyWith({
    String? id,
    String? title,
    int? target,
    int? current,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      target: target ?? this.target,
      current: current ?? this.current,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
