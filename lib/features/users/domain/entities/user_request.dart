class UserRequest {
  const UserRequest({
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  });

  final String name;
  final String email;
  final String gender;
  final String status;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'status': status,
    };
  }
}
