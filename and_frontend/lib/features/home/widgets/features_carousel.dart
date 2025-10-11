import 'package:flutter/material.dart';

class FeaturesCarousel extends StatelessWidget {
  const FeaturesCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      // This is the corrected line
      {'icon': Icons.edit_note_rounded, 'title': 'Quick Reporting', 'color': Colors.blue.shade300},
      {'icon': Icons.track_changes_rounded, 'title': 'Live Tracking', 'color': Colors.green.shade300},
      {'icon': Icons.card_giftcard_rounded, 'title': 'Earn Rewards', 'color': Colors.orange.shade300},
      {'icon': Icons.groups_rounded, 'title': 'Community', 'color': Colors.purple.shade300},
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        scrollDirection: Axis.horizontal,
        itemCount: features.length,
        itemBuilder: (context, index) {
          final feature = features[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
                color: feature['color'].withOpacity(0.15),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: feature['color'].withOpacity(0.3))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(feature['icon'], size: 40, color: feature['color']),
                const SizedBox(height: 12),
                Text(
                  feature['title'],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
