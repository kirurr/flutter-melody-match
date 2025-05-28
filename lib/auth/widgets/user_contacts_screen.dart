import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:melody_match/auth/widgets/user_preferences_screen.dart';
import 'package:melody_match/core/logout_manager.dart';
import 'package:melody_match/user/entities/user_contact.dart';
import 'package:melody_match/user/entities/user_data.dart';
import 'package:melody_match/user/user_service.dart';
import 'package:melody_match/user/user_state_manager.dart';
import 'package:melody_match/utils/utils.dart';

class UserContactsScreen extends StatefulWidget {
  const UserContactsScreen({super.key});

  @override
  State<UserContactsScreen> createState() => _UserContactsScreenState();
}

class _UserContactsScreenState extends State<UserContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('user contacts'),
        actions: [
          IconButton(
            onPressed: () {
              LogoutManager.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(child: UserContactsForm()),
    );
  }
}

class UserContactsForm extends StatefulWidget {
  const UserContactsForm({super.key});

  @override
  State<UserContactsForm> createState() => _UserContactsFormState();
}

class _UserContactsFormState extends State<UserContactsForm> {
  final UserService _userService = UserService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  bool _isLoading = false;
  bool _isError = false;
  String? _message;

  List<UserContact> _contacts = [];

  void _removeContact(UserContact contact) {
    setState(() {
      _contacts.remove(contact);
    });
  }

  void _addContact() {
    if (!_formKey.currentState!.validate()) return;

    UserContact contact = UserContact(
      id: _contacts.isEmpty ? 0 : _contacts.last.id + 1,
      name: _nameController.text,
      value: _valueController.text,
    );

    setState(() {
      _contacts.add(contact);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _isError = false;
      _message = null;
    });

    if (_contacts.isEmpty) {
      setState(() {
        _isError = true;
        _message = 'please add contacts';
      });
      return;
    }

    try {
      await _userService.createContacts(_contacts);
      UserStateManager.user = await _userService.getUserWithContacts();

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const UserPreferencesScreen(user: null,)),
      );
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
    return Form(
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
          ElevatedButton(onPressed: _addContact, child: const Text('add contact')),
          Text('contacts: '),
          Wrap(
            children: _contacts.map((e) => _ContactItem(contact: e, onDelete: () => _removeContact(e))).toList(),
           ),
          Text(_message ?? ''),
          ElevatedButton(onPressed: _submit, child: const Text('submit')),
        ],
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(children: [Text(contact.name), Text(contact.value)]),
          IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
        ],
      ),
    );
  }
}
