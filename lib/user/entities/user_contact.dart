class UserContact {
  final int id;
  final String name;
  final String value;

  const UserContact({required this.id, required this.name, required this.value});

  factory UserContact.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'value': String value,
      } =>
          UserContact(id: id, name: name, value: value),
      _ => throw Exception('Invalid userContact json'),
    };
  }
}