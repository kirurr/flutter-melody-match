import 'package:flutter/material.dart';
import 'package:melody_match/auth/widgets/user_contacts_screen.dart';
import 'package:melody_match/core/logout_manager.dart';
import 'package:melody_match/user/entities/user_data.dart';
import 'package:melody_match/user/user_service.dart';
import 'package:melody_match/user/user_state_manager.dart';
import 'package:melody_match/utils/utils.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('user data'),
        actions: [
          IconButton(
            onPressed: () {
              LogoutManager.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(child: UserDataForm()),
    );
  }
}

class UserDataForm extends StatefulWidget {
  const UserDataForm({super.key});

  @override
  State<UserDataForm> createState() => _UserDataFormState();
}

class _UserDataFormState extends State<UserDataForm> {
  final UserService _userService = UserService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  UserDataSex? _sex = UserDataSex.MALE;

  bool _isLoading = false;
  bool _isError = false;
  String? _message;

  void setSex(UserDataSex? sex) {
    setState(() {
      _sex = sex;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _isError = false;
      _message = null;
    });

    if (_sex == null) {
      setState(() {
        _isError = true;
        _message = 'please select sex';
      });
      return;
    }

    try {
      await _userService.createUserData(
        age: int.parse(_ageController.text),
        sex: _sex!,
        displayName: _displayNameController.text,
        about: _aboutController.text,
        imageUrl: _imageUrlController.text,
      );
      UserStateManager.user = await _userService.getUserWithContacts();

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const UserContactsScreen()),
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
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'age'),
            validator: (v) {
              if (v == null || v.isEmpty) return 'age is required';
              final bool isVaid = isNumeric(v);
              return isVaid ? null : 'invalid age';
            },
          ),
          Column(
            children: [
              ListTile(
                title: const Text('male'),
                leading: Radio<UserDataSex>(
                  value: UserDataSex.MALE,
                  groupValue: _sex,
                  onChanged: setSex,
                ),
              ),
              ListTile(
                title: const Text('female'),
                leading: Radio<UserDataSex>(
                  value: UserDataSex.FEMALE,
                  groupValue: _sex,
                  onChanged: setSex,
                ),
              ),
            ],
          ),
          TextFormField(
            controller: _displayNameController,
            decoration: const InputDecoration(labelText: 'display name'),
            validator: (v) =>
                v == null || v.isEmpty ? 'display name is required' : null,
          ),
          TextFormField(
            controller: _aboutController,
            decoration: const InputDecoration(labelText: 'about'),
            validator: (v) =>
                v == null || v.isEmpty ? 'about is required' : null,
          ),
          TextFormField(
            controller: _imageUrlController,
            decoration: const InputDecoration(labelText: 'image url'),
            validator: (v) =>
                v == null || v.isEmpty ? 'image url is required' : null,
          ),
          ElevatedButton(onPressed: _submit, child: const Text('submit')),
          Text(_message ?? ''),
        ],
      ),
    );
  }
}
