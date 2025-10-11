// import 'package:flutter/material.dart';
// import '../../../data/models/complaint_model.dart';
// import 'package:intl/intl.dart'; // For date formatting
//
// class ComplaintCard extends StatelessWidget {
//   final Complaint complaint;
//   const ComplaintCard({super.key, required this.complaint});
//
//   // Helper to get status color and text
//   Map<String, dynamic> _getStatusProperties(ComplaintStatus status) {
//     switch (status) {
//       case ComplaintStatus.pending:
//         return {'color': Colors.orange.shade400, 'text': 'Pending'};
//       case ComplaintStatus.inProgress:
//         return {'color': Colors.blue.shade400, 'text': 'In Progress'};
//       case ComplaintStatus.resolved:
//         return {'color': Colors.green.shade400, 'text': 'Resolved'};
//       case ComplaintStatus.rejected:
//         return {'color': Colors.red.shade400, 'text': 'Rejected'};
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final status = _getStatusProperties(complaint.status);
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       child: InkWell(
//         onTap: () {
//           // TODO: Navigate to Complaint Details Screen
//         },
//         borderRadius: BorderRadius.circular(16.0),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Flexible(
//                     child: Text(
//                       complaint.title,
//                       style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: status['color'].withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(20.0),
//                     ),
//                     child: Text(
//                       status['text'],
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         color: status['color'],
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade600),
//                   const SizedBox(width: 4),
//                   Text(complaint.location, style: theme.textTheme.bodyMedium),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 children: [
//                   Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade600),
//                   const SizedBox(width: 4),
//                   Text(DateFormat('dd MMM, yyyy').format(complaint.date), style: theme.textTheme.bodyMedium),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:helpcivic/app/router.dart';
import 'package:helpcivic/data/models/complaint_model.dart';
import 'package:intl/intl.dart';
import 'dart:io'; // CRUCIAL: Import dart:io for File

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;

  const ComplaintCard({super.key, required this.complaint});

  // Helper to check if a string looks like a local file path
  bool _isLocalFile(String url) {
    // Check if the URL starts with common local path prefixes
    return url.startsWith('/') || url.startsWith('file://');
  }

  // Helper to get status color and icon
  (Color, IconData) _getStatusInfo(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.pending:
        return (Colors.orange.shade700, Icons.hourglass_top_rounded);
      case ComplaintStatus.inProgress:
        return (Colors.blue.shade700, Icons.construction_rounded);
      case ComplaintStatus.resolved:
        return (Colors.green.shade700, Icons.check_circle_rounded);
      case ComplaintStatus.rejected:
        return (Colors.red.shade700, Icons.cancel_rounded);
      case ComplaintStatus.escalated:
        return (Colors.purple.shade700, Icons.gavel_rounded);
    }
  }

  Widget _buildComplaintImage(BuildContext context) {
    if (complaint.imageUrl == null) return const SizedBox.shrink();

    final isLocal = _isLocalFile(complaint.imageUrl!);

    // Common properties for the image container
    const double image_height = 150;
    const double image_width = double.infinity;
    const BoxFit fit = BoxFit.cover;

    Widget imageWidget;

    if (isLocal) {
      // Use Image.file for local paths
      imageWidget = Image.file(
        File(complaint.imageUrl!),
        height: image_height,
        width: image_width,
        fit: fit,
        // Error handling for local files (e.g., file was deleted)
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.broken_image, color: Colors.red, size: 50),
          );
        },
      );
    } else {
      // Use Image.network for network URLs (placeholders or future cloud storage)
      imageWidget = Image.network(
        complaint.imageUrl!,
        height: image_height,
        width: image_width,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
          );
        },
      );
    }

    return SizedBox(
      height: image_height,
      width: image_width,
      child: imageWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusIcon) = _getStatusInfo(complaint.status);
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRouter.complaintDetails,
            arguments: complaint,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CALL THE NEW IMAGE BUILDER HERE
            _buildComplaintImage(context),
            // ------------------------------------
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    complaint.title,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey.shade600, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          complaint.location,
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade800),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey.shade600, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM, yyyy').format(complaint.date),
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade800),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        // Capitalize the first letter of the status
                        complaint.status.toString().split('.').last.replaceFirstMapped(RegExp(r'^\w'), (match) => match.group(0)!.toUpperCase()),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'View Details',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.primaryColor),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}