import 'package:flutter/material.dart';
import 'package:melody_match/match/entities/match.dart';
import 'package:melody_match/match/entities/user_data_match.dart';
import 'package:melody_match/match/match_service.dart';
import 'package:melody_match/match/widgets/about_user_screen.dart';
import 'package:melody_match/user/entities/user.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});
  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final MatchService _matchService = MatchService();
  List<MatchWithUser> _unacceptedMatches = [];
  List<User> _acceptedMatches = [];

  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchMatches();
  }

  Future<void> _fetchMatches() async {
    setState(() {
      _isLoading = true;
    });

    await _getAcceptedMatches();
    await _getUnacceptedMatches();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _acceptMatch(int id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _matchService.acceptMatch(id: id);
      await _fetchMatches();
    } catch (e) {
      setState(() {
        _isError = true;
        _errorMessage = e.toString();
      });
    } finally {}
  }

  Future<void> _getUnacceptedMatches() async {
    try {
      List<MatchWithUser> matches = await _matchService
          .getUnacceptedMatchesWithUserData();

      if (matches.isEmpty) {
        setState(() {
          _unacceptedMatches.clear();
        });
        return;
      }
      setState(() {
        _unacceptedMatches = matches;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _getAcceptedMatches() async {
    try {
      List<User> matches = await _matchService.getAcceptedMatchesWithUserData();

      if (matches.isEmpty) {
        setState(() {
          _acceptedMatches.clear();
        });
        return;
      }
      setState(() {
        _acceptedMatches = matches;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('matches'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Column(
                      children: _acceptedMatches.isEmpty
                          ? [const Text('no accepted matches')]
                          : _acceptedMatches
                                .map((e) => _MatchItem(user: e))
                                .toList(),
                    ),
                    Divider(),
                    Column(
                      children: _unacceptedMatches.isEmpty
                          ? [const Text('no unaccepted matches')]
                          : _unacceptedMatches
                                .map(
                                  (e) => _UnacceptedMatchItem(
                                    match: e,
                                    onAccept: () => _acceptMatch(e.match.id),
                                  ),
                                )
                                .toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _UnacceptedMatchItem extends StatelessWidget {
  final MatchWithUser match;
  final VoidCallback onAccept;

  const _UnacceptedMatchItem({required this.match, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AboutUserScreen(user: match.user),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(match.user.userData!.displayName),
                const Icon(Icons.navigate_next),
              ],
            ),
          ),
          TextButton(
            onPressed: onAccept,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('accept match'),
                const Icon(Icons.navigate_next),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchItem extends StatelessWidget {
  final User user;

  const _MatchItem({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AboutUserScreen(user: user)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(user.userData!.displayName),
                const Icon(Icons.navigate_next),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
