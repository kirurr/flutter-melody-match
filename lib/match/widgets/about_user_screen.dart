import 'package:flutter/material.dart';
import 'package:melody_match/match/widgets/contact_widget.dart';
import 'package:melody_match/user/entities/user.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserCard(user: user),
            Column(
              children: user.userData!.contacts
                  .map((e) => ContactItem(contact: e))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
