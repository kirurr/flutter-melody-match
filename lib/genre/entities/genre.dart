class Genre {
  final int id;
  final String name;

  const Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
      } =>
        Genre(
          id: id,
          name: name,
        ),
      _ => throw Exception('Invalid genre json'),
    };
  }
}
