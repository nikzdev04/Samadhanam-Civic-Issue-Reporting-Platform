// import 'package:helpcivic/data/models/complaint_model.dart';
// import 'dart:math';
//
// // This is a mock API service that simulates network requests for the demo.
// class ApiService {
//   // We will store the complaints in memory to simulate a database.
//   final List<Complaint> _mockComplaints = [
//     Complaint(
//         id: 'C001',
//         title: 'Large Pothole on Station Road',
//         location: 'Station Road, Kareli, Uttar Pradesh',
//         latitude: 25.4358,
//         longitude: 81.8463,
//         date: DateTime.now().subtract(const Duration(days: 2)),
//         status: ComplaintStatus.inProgress,
//         description:
//         'A large and dangerous pothole has formed in the middle of the street. It needs immediate attention.',
//         imageUrl:
//         'https://placehold.co/600x400/cccccc/ffffff?text=Pothole',
//         timeline: [
//           TimelineEvent(
//               status: 'Submitted',
//               description: 'Complaint submitted by user.',
//               date: DateTime.now().subtract(const Duration(days: 2))),
//           TimelineEvent(
//               status: 'In Progress',
//               description: 'A team has been assigned to inspect the issue.',
//               date: DateTime.now().subtract(const Duration(hours: 8))),
//         ]),
//   ];
//
//   // Simulates fetching all complaints for the user.
//   Future<List<Complaint>> getMyComplaints() async {
//     await Future.delayed(const Duration(seconds: 1));
//     return List.from(_mockComplaints.reversed);
//   }
//
//   // Simulates submitting a new complaint.
//   // CORRECTED: The parameter name is now 'imageUrl' to match the calling screen.
//   Future<bool> submitComplaint({
//     required String title,
//     required String description,
//     required String imageUrl, // Expects 'imageUrl'
//     required String location,
//     double? latitude,
//     double? longitude,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 1500));
//
//     final newComplaint = Complaint(
//       id: 'C${Random().nextInt(1000)}',
//       title: title,
//       location: location,
//       latitude: latitude,
//       longitude: longitude,
//       date: DateTime.now(),
//       status: ComplaintStatus.pending,
//       description: description,
//       // The passed 'imageUrl' is used here, which is a placeholder from the report screen.
//       imageUrl: imageUrl,
//       timeline: [
//         TimelineEvent(
//           status: 'Submitted',
//           description: 'Complaint was submitted by the user.',
//           date: DateTime.now(),
//         ),
//       ],
//     );
//
//     _mockComplaints.add(newComplaint);
//
//     // Returns 'true' to indicate success, as expected by the calling screen.
//     return true;
//   }
// }
//



// api_service.dart
import 'package:helpcivic/data/models/complaint_model.dart';
import 'package:helpcivic/mongodb.dart';
import 'package:helpcivic/mongodb.dart'; // 👈 Import your MongoDatabase

// This is a mock API service that simulates network requests for the demo.
class ApiService {
  // Removed _mockComplaints - we will use the actual database

  // Simulates fetching all complaints for the user.
  Future<List<Complaint>> getMyComplaints() async {
    try {
      final complaintMaps = await MongoDatabase.getComplaints();
      // Map the MongoDB data to your Dart model
      return complaintMaps.map((json) => Complaint.fromJson(json)).toList();
    } catch (e) {
      print('Error in getMyComplaints: $e');
      return [];
    }
  }

  // Simulates submitting a new complaint.
  // Now calls MongoDatabase.insertComplaint and returns a boolean for success.
  Future<bool> submitComplaint({
    required String title,
    required String description,
    required String imageUrl,
    required String location,
    double? latitude,
    double? longitude,
  }) async {
    // 1. Prepare the data map for MongoDB insertion
    final complaintData = {
      'title': title,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'raisedDate': DateTime.now().toIso8601String(),
      'status': ComplaintStatus.pending.toString().split('.').last, // 'pending'
      'description': description,
      'imageUrl': imageUrl,
      'timeline': [
        {
          'status': 'Submitted',
          'description': 'Complaint was submitted by the user.',
          'date': DateTime.now().toIso8601String(),
        },
      ],
      // 'userId' will be added in MongoDatabase.insertComplaint
    };

    // 2. Call the database function
    final String? complaintId = await MongoDatabase.insertComplaint(complaintData);

    // 3. Check for success and return boolean
    return complaintId != null;
  }
}