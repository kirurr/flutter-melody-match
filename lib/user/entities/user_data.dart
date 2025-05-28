import 'package:melody_match/user/entities/user_contact.dart';

enum UserDataSex { MALE, FEMALE }

class UserData {
  final int id;
  final int userId;
  final int age;
  final UserDataSex sex;
  final String displayName;
  final String about;
  final String imageUrl;
  final List<UserContact> contacts;

  const UserData({
    required this.id,
    required this.userId,
    required this.age,
    required this.sex,
    required this.displayName,
    required this.about,
    required this.imageUrl,
    required this.contacts,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') ||
        !json.containsKey('userId') ||
        !json.containsKey('age') ||
        !json.containsKey('sex') ||
        !json.containsKey('displayName') ||
        !json.containsKey('about') ||
        !json.containsKey('imageUrl')) {
      throw Exception('Invalid userData json');
    }

    final id = json['id'] as int;
    final userId = json['userId'] as int;
    final age = json['age'] as int;
    final sex = json['sex'] as String;
    final displayName = json['displayName'] as String;
    final about = json['about'] as String;
    final imageUrl = json['imageUrl'] as String;

    final contacts = json['contacts'] as List<dynamic>?;

    return UserData(
      id: id,
      userId: userId,
      age: age,
      sex: sex == 'MALE' ? UserDataSex.MALE : UserDataSex.FEMALE,
      displayName: displayName,
      about: about,
      imageUrl: imageUrl,
      contacts: contacts?.isEmpty ?? true
          ? List<UserContact>.empty()
          : contacts!.map((e) => UserContact.fromJson(e)).toList(),
    );
  }
}
