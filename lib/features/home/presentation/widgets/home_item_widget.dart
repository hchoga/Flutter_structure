import 'package:flutter/material.dart';
import 'package:touch/features/home/domain/entities/home_entity.dart';

/// Home item widget - reusable component
class HomeItemWidget extends StatelessWidget {
  final HomeEntity home;
  final VoidCallback onTap;

  const HomeItemWidget({super.key, required this.home, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(home.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                home.description,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
