import 'package:flutter/material.dart';
import 'package:melody_match/user/entities/user.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 400,
          child: Stack(
            children: [
              Image.network(
                loadingBuilder:
                    (
                      BuildContext context,
                      Widget child,
                      ImageChunkEvent? loadingProgress,
                    ) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return Center(child: Text('Error loading image'));
                    },
                fit: BoxFit.cover,
                height: 400,
                width: MediaQuery.of(context).size.width,
                user.userData!.imageUrl,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.userData!.displayName,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                '${user.userData!.age.toString()} years',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                user.userData!.sex.name.toLowerCase(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Divider(
                indent: 32,
                endIndent: 32,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  user.userData!.about,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Divider(
                indent: 32,
                endIndent: 32,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                spacing: 8,
                  children: user.userPreferences!.genres
                      .map((e) => _GenreItem(name: e.name))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GenreItem extends StatelessWidget {
  final String name;

  const _GenreItem({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text(name)],
      ),
    );
  }
}
