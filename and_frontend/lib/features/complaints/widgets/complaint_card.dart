import 'package:flutter/material.dart';
import '../../../data/models/complaint_model.dart';
import 'package:intl/intl.dart'; // For date formatting

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  const ComplaintCard({super.key, required this.complaint});

  // Helper to get status color and text
  Map<String, dynamic> _getStatusProperties(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.pending:
        return {'color': Colors.orange.shade400, 'text': 'Pending'};
      case ComplaintStatus.inProgress:
        return {'color': Colors.blue.shade400, 'text': 'In Progress'};
      case ComplaintStatus.resolved:
        return {'color': Colors.green.shade400, 'text': 'Resolved'};
      case ComplaintStatus.rejected:
        return {'color': Colors.red.shade400, 'text': 'Rejected'};
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = _getStatusProperties(complaint.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to Complaint Details Screen
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      complaint.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: status['color'].withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      status['text'],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: status['color'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(complaint.location, style: theme.textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(DateFormat('dd MMM, yyyy').format(complaint.date), style: theme.textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}