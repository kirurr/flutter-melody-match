import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:melody_match/user/entities/user_contact.dart';

class ContactItem extends StatelessWidget {
  final UserContact contact;

  const ContactItem({super.key, required this.contact});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text('${contact.name}:'),
          TextButton(
            onPressed: () =>
                Clipboard.setData(ClipboardData(text: contact.value)),
            child: Text(contact.value),
          ),
        ],
      ),
    );
  }
}
