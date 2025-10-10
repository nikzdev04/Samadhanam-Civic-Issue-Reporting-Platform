// Defines the structure for a single complaint object.
// This keeps our data organized and consistent throughout the app.

enum ComplaintStatus { pending, inProgress, resolved, rejected }

class TimelineEvent {
  final String status;
  final String description;
  final DateTime date;

  TimelineEvent({
    required this.status,
    required this.description,
    required this.date,
  });
}

class Complaint {
  final String id;
  final String title;
  final String location; // This will store the readable address
  final double? latitude;   // ADDED for geo-tagging
  final double? longitude;  // ADDED for geo-tagging
  final DateTime date;
  final ComplaintStatus status;
  final String description;
  final String? imageUrl;
  final List<TimelineEvent> timeline;

  Complaint({
    required this.id,
    required this.title,
    required this.location,
    this.latitude,
    this.longitude,
    required this.date,
    required this.status,
    required this.description,
    this.imageUrl,
    this.timeline = const [],
  }

  );


}

