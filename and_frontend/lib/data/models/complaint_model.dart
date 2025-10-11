// // Defines the structure for a single complaint object.
// // This keeps our data organized and consistent throughout the app.
//
// // Helper function to parse status from string to enum
// import 'package:mongo_dart/mongo_dart.dart';
//
// ComplaintStatus _statusFromString(String status) {
//   return ComplaintStatus.values.firstWhere(
//         (e) => e.toString().split('.').last.toLowerCase() == status.toLowerCase(),
//     orElse: () => ComplaintStatus.pending,
//   );
// }
//
// enum ComplaintStatus { pending, inProgress, resolved, rejected, escalated }
//
// class TimelineEvent {
//   final String status;
//   final String description;
//   final DateTime date;
//
//   TimelineEvent({
//     required this.status,
//     required this.description,
//     required this.date,
//   });
//
//   // Factory constructor to create a TimelineEvent from JSON
//   factory TimelineEvent.fromJson(Map<String, dynamic> json) {
//     return TimelineEvent(
//       status: json['status'] ?? 'Unknown Status',
//       description: json['description'] ?? 'No description',
//       date: DateTime.parse(json['date']),
//     );
//   }
// }
//
// class Complaint {
//   final String id;
//   final String title;
//   final String location;
//   final double? latitude;
//   final double? longitude;
//   final DateTime date;
//   final ComplaintStatus status;
//   final String description;
//   final String? imageUrl;
//   final List<TimelineEvent> timeline;
//
//   Complaint({
//     required this.id,
//     required this.title,
//     required this.location,
//     this.latitude,
//     this.longitude,
//     required this.date,
//     required this.status,
//     required this.description,
//     this.imageUrl,
//     this.timeline = const [],
//   });
//
//   // --- NEW: Factory constructor to create a Complaint from JSON ---
//   // This is the method that was missing.
//   factory Complaint.fromJson(Map<String, dynamic> json) {
//     final dynamic rawId = json['_id'];
//     String idString;
//
//     if (rawId is ObjectId) {
//       idString = rawId.toHexString(); // Convert ObjectId to String
//     } else if (rawId != null) {
//       idString = rawId.toString(); // Handle String or other types
//     } else {
//       idString = 'UnknownID';
//     }
//
//     return Complaint(
//       id: idString, // Use the converted String ID
//       // ... rest of the fields ...
//       title: json['title'] ?? 'No Title',
//       location: json['location'] ?? 'No Location',
//       latitude: (json['latitude'] as num?)?.toDouble(),
//       longitude: (json['longitude'] as num?)?.toDouble(),
//       date: DateTime.parse(json['raisedDate'] ?? json['createdAt']),
//       status: _statusFromString(json['status'] ?? 'Pending'),
//       description: json['description'] ?? 'No Description',
//       imageUrl: json['imageUrl'],
//       timeline: (json['timeline'] as List<dynamic>?)
//           ?.map((eventJson) => TimelineEvent.fromJson(eventJson))
//           .toList() ??
//           [],
//     );
//   }
// // -----------------------------------------------------------------
// }


// workinggg



import 'package:mongo_dart/mongo_dart.dart';

ComplaintStatus _statusFromString(String status) {
  return ComplaintStatus.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() == status.toLowerCase(),
    orElse: () => ComplaintStatus.pending,
  );
}

enum ComplaintStatus { pending, inProgress, resolved, rejected, escalated }

class TimelineEvent {
  final String status;
  final String description;
  final DateTime date;

  TimelineEvent({
    required this.status,
    required this.description,
    required this.date,
  });

  // Factory constructor to create a TimelineEvent from JSON
  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
      status: json['status'] ?? 'Unknown Status',
      description: json['description'] ?? 'No description',
      date: DateTime.parse(json['date']),
    );
  }
}

class Complaint {
  final String id;
  final String title;
  final String location;
  final double? latitude;
  final double? longitude;
  final DateTime date;
  final ComplaintStatus status;
  final String description;
  final String? imageUrl;
  final List<TimelineEvent> timeline;
  // 👇 NEW LOCATION FIELDS
  final String? municipalityName;
  final String? stateName;
  final String? countryName;

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
    // 👇 NEW LOCATION FIELDS IN CONSTRUCTOR
    this.municipalityName,
    this.stateName,
    this.countryName,
  });

  // --- Factory constructor to create a Complaint from JSON ---
  factory Complaint.fromJson(Map<String, dynamic> json) {
    final dynamic rawId = json['_id'];
    String idString;

    if (rawId is ObjectId) {
      idString = rawId.toHexString(); // Convert ObjectId to String
    } else if (rawId != null) {
      idString = rawId.toString(); // Handle String or other types
    } else {
      idString = 'UnknownID';
    }

    return Complaint(
      id: idString, // Use the converted String ID
      title: json['title'] ?? 'No Title',
      location: json['location'] ?? 'No Location',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      date: DateTime.parse(json['raisedDate'] ?? json['createdAt']),
      status: _statusFromString(json['status'] ?? 'Pending'),
      description: json['description'] ?? 'No Description',
      imageUrl: json['imageUrl'],
      timeline: (json['timeline'] as List<dynamic>?)
          ?.map((eventJson) => TimelineEvent.fromJson(eventJson))
          .toList() ??
          [],
      // 👇 NEW LOCATION FIELDS FROM JSON
      municipalityName: json['municipalityName'],
      stateName: json['stateName'],
      countryName: json['countryName'],
    );
  }
}
