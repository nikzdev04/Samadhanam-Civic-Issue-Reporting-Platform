import 'package:flutter/material.dart';

class EmptyComplaints extends StatelessWidget {
  // Humne yeh nayi line add ki hai taaki widget function le sake
  final VoidCallback onReport;

  const EmptyComplaints({
    super.key,
    // Aur ise constructor mein zaroori banaya hai
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 80,
              color: theme.primaryColor.withOpacity(0.7),
            ),
            const SizedBox(height: 24),
            Text(
              'Aapne abhi tak koi shikayat darj nahi ki hai.',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Koi samasya dikhne par yahan report karein.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              // Ab button bahar se diye gaye function ko call karega
              onPressed: onReport,
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('Nayi Shikayat Darj Karein'),
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

