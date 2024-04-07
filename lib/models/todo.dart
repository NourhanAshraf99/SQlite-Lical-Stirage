class Todo {
  final int id;
  final String title;
  final String? createAt;
  final String? updatedAt;

  Todo(
      {required this.id,
      required this.title,
      required this.createAt,
      required this.updatedAt});

  factory Todo.fromSqfliteDatabase(Map<String, dynamic> map) => Todo(
      id: map['id'] ?? '0',
      title: map['title'] ?? '',
      createAt: map['createAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['created_at'], isUtc: true)
              .toIso8601String(),
      updatedAt: map['updatedAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['updatedAt'], isUtc: true)
              .toIso8601String());
}
