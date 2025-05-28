import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:melody_match/core/logout_manager.dart';
import 'package:melody_match/match/match_service.dart';
import 'package:melody_match/match/widgets/matches_screen.dart';
import 'package:melody_match/user/user_state_manager.dart';
import 'package:melody_match/user/entities/user.dart';
import 'package:melody_match/user/widgets/user_card.dart';
import 'package:melody_match/user/widgets/user_profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserProfileScreen()),
              );
            },
            icon: Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MatchesScreen()),
              );
            },
            icon: Icon(CupertinoIcons.heart_fill),
          ),
        ],
      ),
      body: _FindUsersWidget(),
    );
  }
}

class _FindUsersWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FindUsersWidgetState();
}

class _FindUsersWidgetState extends State<_FindUsersWidget> {
  final MatchService _matchService = MatchService();
  final UserStateManager _userStateManager = UserStateManager.instance;

  List<User>? _matches;

  bool _isLoading = true;
  bool _isButtonLoading = false;

  bool _isError = false;
  String _errorMessage = '';

  void _createMatch(int id) async {
    await _matchService.createMatch(id: id);
    if (!mounted) return;
    _showNextMatch();
  }

  void _showNextMatch() async {
    int seenId = _matches!.first.id;
    _userStateManager.addSeenId(seenId);

    if ((_matches == null || _matches!.isEmpty) || _matches!.length == 1) {
      setState(() {
        _isButtonLoading = true;
      });
      await _findMatches();
      setState(() {
        _matches!.removeAt(0);
        _isButtonLoading = false;
      });
      return;
    }

    if (_matches!.length == 2) _findMatches();

    setState(() {
      _matches!.removeAt(0);
    });
  }

  @override
  void initState() {
    super.initState();
    _findMatches();
  }

  Future<void> _findMatches({bool isRefresh = false}) async {
    List<int> seenIds = await _userStateManager.getSeenIds();
    try {
      List<User> result = await _matchService.findMatchesForUser(
        seenIds: seenIds,
      );
      if (result.isEmpty && !isRefresh) {
        await _userStateManager.clearSeenIds();
        return _findMatches(isRefresh: true);
      }
      setState(() {
        if (_matches == null || _matches!.isEmpty) {
          _matches = result;
        } else {
          _matches?.addAll(result);
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _errorMessage = e.toString();
      });
      return;
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isError
        ? Center(child: 
        Column(children: [
          Text(_errorMessage),
          ElevatedButton(child: const Text('log out') , onPressed: () {
            LogoutManager.logout();
          },)
        ],),)
        : _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _matches == null || _matches!.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('No matches'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    _findMatches();
                  },
                  child: Text('try again'),
                ),
              ],
            ),
          )
        : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: UserCard(user: _matches!.first),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _isButtonLoading ? null : _showNextMatch,
                      icon: _isButtonLoading
                          ? Icon(Icons.do_disturb, size: 64,)
                          : Icon(
                              Icons.navigate_next,
                              color: Theme.of(context).colorScheme.primary,
                              size: 64,
                            ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: Theme.of(context).colorScheme.primary,
                        size: 64,
                      ),
                      onPressed: () => _createMatch(_matches!.first.id),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
