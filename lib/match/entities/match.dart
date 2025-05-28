class Match {
  int id;
  int userId;
  int likedUserId;
  bool isAccepted;

  Match({
    required this.id,
    required this.userId,
    required this.likedUserId,
    required this.isAccepted,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') ||
        !json.containsKey('userId') ||
        !json.containsKey('likedUserId') ||
        !json.containsKey('isAccepted')) {
      throw Exception('Invalid match json');
    }

    final id = json['id'] as int;
    final userId = json['userId'] as int;
    final likedUserId = json['likedUserId'] as int;
    final isAccepted = json['isAccepted'] as bool;

    return Match(
      id: id,
      userId: userId,
      likedUserId: likedUserId,
      isAccepted: isAccepted,
    );
  }
}
