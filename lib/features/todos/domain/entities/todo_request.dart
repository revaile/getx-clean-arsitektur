class TodoRequest  {
  const TodoRequest({
    // required this.id,
    // required this.userId,
    required this.title,
    required this.dueOn,
    required this.status,
  });

  // final int id;
  // final int userId;
  final String title;
  final String dueOn;
  final String status;

    Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dueOn': dueOn,
      'status': status,
    };
  }
}
