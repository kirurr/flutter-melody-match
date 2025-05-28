import 'package:flutter/material.dart';
import 'package:melody_match/user/entities/user.dart';
import 'package:melody_match/user/entities/user_contact.dart';
import 'package:melody_match/user/widgets/user_card.dart';

class AboutUserScreen extends StatelessWidget {
  User user;

  AboutUserScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('about user'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          UserCard(user: user),
          Column(
            children: user.userData!.contacts.map((e) => _ContactItem(contact: e)).toList(),
          )
        ],
      )
    );
  }
}

class _ContactItem extends StatelessWidget {
  final UserContact contact;

  const _ContactItem({required this.contact});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text('${contact.name}: ${contact.value}'),
        ],
      ),
    );
  }
}