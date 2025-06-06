import 'package:flutter/material.dart';
import 'package:melody_match/core/logout_manager.dart';
import 'package:melody_match/user/entities/user_contact.dart';

class UserContactsForm extends StatefulWidget {
  final Future<void> Function(List<UserContact> contacts) onSubmit;
  final List<UserContact> initialContacts;

  const UserContactsForm({
    super.key,
    required this.onSubmit,
    this.initialContacts = const [],
  });

  @override
  State<UserContactsForm> createState() => _UserContactsFormState();
}

class _UserContactsFormState extends State<UserContactsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  bool _isLoading = false;
  bool _isError = false;
  String? _message;

  final List<UserContact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _contacts.addAll(widget.initialContacts);
  }

  void _removeContact(UserContact contact) {
    setState(() {
      _contacts.remove(contact);
    });
  }

  void _addContact() {
    if (!_formKey.currentState!.validate()) return;

    UserContact contact = UserContact(
      id: 0,
      name: _nameController.text,
      value: _valueController.text,
    );

    setState(() {
      _contacts.add(contact);
      _nameController.clear();
      _valueController.clear();
    });
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _isError = false;
      _message = null;
    });

    if (_contacts.isEmpty) {
      setState(() {
        _message = 'please add contacts';
      });
      return;
    }

    try {
      await widget.onSubmit(_contacts);
    } catch (e) {
      setState(() {
        _isError = true;
        _message = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_isError) {
      return Center(
        child: Column(
          children: [
            Text(_message ?? ''),
            ElevatedButton(
              onPressed: () {
                LogoutManager.logout();
              },
              child: Text('logout'),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'name'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'name is required' : null,
            ),
            TextFormField(
              controller: _valueController,
              decoration: const InputDecoration(labelText: 'value'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'value is required' : null,
            ),
            ElevatedButton(
              onPressed: _addContact,
              child: const Text('add contact'),
            ),
            Wrap(
              spacing: 8,
              children: _contacts
                  .map(
                    (e) => _ContactItem(
                      contact: e,
                      onDelete: () => _removeContact(e),
                    ),
                  )
                  .toList(),
            ),
            Text(_message ?? ''),
            ElevatedButton(onPressed: _submit, child: const Text('submit')),
          ],
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final UserContact contact;
  final VoidCallback onDelete;

  const _ContactItem({required this.contact, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(contact.name), Text(contact.value)],
          ),
          IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
        ],
      ),
    );
  }
}
