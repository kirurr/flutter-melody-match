import 'package:flutter/material.dart';
import 'package:melody_match/auth/auth_service.dart';
import 'package:melody_match/auth/entities/tokens.dart';
import 'package:melody_match/core/logout_manager.dart';
import 'package:melody_match/core/widgets/startup_screen.dart';
import 'package:melody_match/genre/entities/genre.dart';
import 'package:melody_match/genre/genre_service.dart';
import 'package:melody_match/user/entities/user.dart';
import 'package:melody_match/user/entities/user_preferences.dart';
import 'package:melody_match/user/user_service.dart';
import 'package:melody_match/user/user_state_manager.dart';

class UserPreferencesScreen extends StatelessWidget {
  final User? user;

  const UserPreferencesScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('user preferences'),
        actions: [
          IconButton(
            onPressed: () {
              LogoutManager.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(child: UserPreferencesForm(user: user)),
    );
  }
}

class UserPreferencesForm extends StatefulWidget {
  User? user;

  UserPreferencesForm({super.key, required this.user});

  @override
  State<UserPreferencesForm> createState() => _UserPreferencesFormState();
}

class _UserPreferencesFormState extends State<UserPreferencesForm> {
  final UserService _userService = UserService();
  final GenreService _genreService = GenreService();
  final UserStateManager _userStateManager = UserStateManager.instance;
  final AuthService _authService = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserPreferencesDesiredSex? _desiredSex = UserPreferencesDesiredSex.BOTH;

  Set<Genre> _selectedGenres = {};
  Set<Genre> _genres = {};

  bool _isLoading = false;
  bool _isError = false;
  String? _message;

  Tokens? _tokens;

  @override
  void initState() {
    super.initState();
    if (widget.user == null) _fetchUser();
    _initTokens();
  }

  void _fetchUser() async {
    widget.user = await _userService.getUserWithContacts();
    if (widget.user!.userPreferences == null ||
        widget.user!.userPreferences!.genres.isEmpty) {
      return;
    }
    _selectedGenres = widget.user!.userPreferences!.genres.toSet();
  }

  void _connectToSpotify() async {
    await _authService.startSpotifyOAuth2();
    await _assignSpotifyGenresToUser();
  }

  Future<void> _initTokens() async {
    _tokens = await _userStateManager.getTokens();
  }

  Future<void> _assignSpotifyGenresToUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _userService.createUserPreferences(
        desiredSex: _desiredSex!,
        genres: [Genre(id: 1, name: 'placeholder')],
      );
      await _userService.assignSpotifyGenresToUser(
        token: _tokens!.spotifyAccessToken!,
      );
      UserStateManager.user = await _userService.getUserWithContacts();
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

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => StartupScreen()),
    );
  }

  void _queryGenres(String name) async {
    if (name.isEmpty) {
      setState(() {
        _isError = false;
        _message = '';
      });
      return;
    }
    try {
      List<Genre> genres = await _genreService.findGenresByOneName(name);

      setState(() {
        _genres = genres.toSet();
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _message = e.toString();
      });
    }
  }

  void setDesiredSex(UserPreferencesDesiredSex? sex) {
    setState(() {
      _desiredSex = sex;
    });
  }

  void _addGenre(Genre genre) {
    setState(() {
      if (!_selectedGenres.contains(genre)) _selectedGenres.add(genre);
    });
  }

  void _removeGenre(Genre genre) {
    setState(() {
      if (_selectedGenres.contains(genre)) _selectedGenres.remove(genre);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _isError = false;
      _message = null;
    });

    if (_desiredSex == null) {
      setState(() {
        _isError = true;
        _message = 'please select desired sex';
      });
      return;
    }

    if (_selectedGenres.isEmpty) {
      setState(() {
        _isError = true;
        _message = 'please select genres';
      });
      return;
    }

    try {
      await _userService.createUserPreferences(
        desiredSex: _desiredSex!,
        genres: _selectedGenres.toList(),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const StartupScreen()),
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
          Column(
            children: [
              ListTile(
                title: const Text('male'),
                leading: Radio<UserPreferencesDesiredSex>(
                  value: UserPreferencesDesiredSex.MALE,
                  groupValue: _desiredSex,
                  onChanged: setDesiredSex,
                ),
              ),
              ListTile(
                title: const Text('female'),
                leading: Radio<UserPreferencesDesiredSex>(
                  value: UserPreferencesDesiredSex.FEMALE,
                  groupValue: _desiredSex,
                  onChanged: setDesiredSex,
                ),
              ),
              ListTile(
                title: const Text('both'),
                leading: Radio<UserPreferencesDesiredSex>(
                  value: UserPreferencesDesiredSex.BOTH,
                  groupValue: _desiredSex,
                  onChanged: setDesiredSex,
                ),
              ),
            ],
          ),
          const Text('selected genres'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            direction: Axis.horizontal,
            children: _selectedGenres
                .map(
                  (e) => _GenreItem(
                    key: ValueKey(e.id),
                    isSelected: true,
                    name: e.name,
                    onTap: () => _removeGenre(e),
                  ),
                )
                .toList(),
          ),
          TextFormField(
            onChanged: (v) => _queryGenres(v),
            decoration: const InputDecoration(labelText: 'find genres by name'),
          ),
          _genres.isEmpty
              ? ElevatedButton(
                  onPressed: _assignSpotifyGenresToUser,
                  child: const Text('submit and assign spotify genres to user'),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  direction: Axis.horizontal,
                  children: _genres
                      .map(
                        (e) => _GenreItem(
                          key: ValueKey(e.id),
                          isSelected: false,
                          name: e.name,
                          onTap: () => _addGenre(e),
                        ),
                      )
                      .toList(),
                ),
          ElevatedButton(onPressed: _submit, child: const Text('submit')),
          SelectableText(_message ?? ''),
        ],
      ),
    );
  }
}

class _GenreItem extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final bool isSelected;

  const _GenreItem({
    super.key,
    required this.name,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(name),
            Icon(isSelected ? Icons.remove : Icons.check, size: 16),
          ],
        ),
      ),
    );
  }
}
