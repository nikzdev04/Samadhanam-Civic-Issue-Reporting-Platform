import 'package:flutter/material.dart';
import 'package:helpcivic/data/models/complaint_model.dart';
import 'package:helpcivic/features/complaints/widgets/status_timeline.dart';
import 'package:intl/intl.dart';
import 'dart:io'; // Import dart:io for File

class ComplaintDetailsScreen extends StatelessWidget {
  final Complaint complaint;

  const ComplaintDetailsScreen({super.key, required this.complaint});

  // Helper function to check if a string looks like a local file path
  bool _isLocalFile(String url) {
    // Local paths usually start with a slash and contain multiple slashes
    return url.startsWith('/') || url.startsWith('file://');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine if we should use Image.file or Image.network
    final isLocal = complaint.imageUrl != null && _isLocalFile(complaint.imageUrl!);

    return Scaffold(
      // ... (AppBar and Header Section code is fine) ...
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (Header Section is fine) ...

            const SizedBox(height: 24),

            // --- Image Section: NOW DYNAMICALLY CHOOSING Image.network or Image.file ---
            if (complaint.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: isLocal
                    ? Image.file( // Use Image.file for local paths
                  File(complaint.imageUrl!),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.red),
                  ),
                )
                    : Image.network( // Use Image.network for placeholder/future cloud URLs
                  complaint.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            if (complaint.imageUrl != null) const SizedBox(height: 24),

            // --- Description Section ---
            Text("Description", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              complaint.description,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const Divider(height: 48, thickness: 1),

            // --- Status Timeline Section ---
            Text("Status Timeline", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            // FIX: Changed 'events' to 'timeline' to match the widget's constructor
            StatusTimeline(timeline: complaint.timeline),
          ],
        ),
      ),
    );
  }
}
