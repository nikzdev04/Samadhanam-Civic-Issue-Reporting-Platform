import 'package:flutter/material.dart';
import 'package:helpcivic/data/models/complaint_model.dart';
import 'package:helpcivic/features/complaints/widgets/status_timeline.dart';
import 'package:intl/intl.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  final Complaint complaint;

  const ComplaintDetailsScreen({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Section ---
            Text(complaint.title, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(complaint.location, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(DateFormat.yMMMd().format(complaint.date), style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 24),

            // --- Image Section ---
            if (complaint.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  complaint.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
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
