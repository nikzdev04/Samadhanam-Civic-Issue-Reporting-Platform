import 'package:helpcivic/data/models/complaint_model.dart';
import 'dart:math';

// Yeh ek mock API service hai jo network requests ko simulate karti hai.
// Asli app mein, yeh class http ya dio jaise package ka istemal karke
// ek real backend server se communicate karegi.

class ApiService {
  // Hum ab complaints ko memory mein store karenge taaki list update ho sake.
  final List<Complaint> _mockComplaints = [
    Complaint(
        id: 'C001',
        title: 'Station Road par paani jama hai',
        location: 'Station Road, Kareli, Uttar Pradesh',
        latitude: 25.4358,
        longitude: 81.8463,
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: ComplaintStatus.inProgress,
        description:
        'Barish ke baad se Station Road par paani bhar gaya hai, aane jaane mein bahut dikkat ho rahi hai. Naali bhi aage se band hai.',
        imageUrl:
        'https://placehold.co/600x400/cccccc/ffffff?text=Water+Logging',
        timeline: [
          TimelineEvent(
              status: 'Jama Ki Gayi',
              description: 'Shikayat user dwara jama ki gayi.',
              date: DateTime.now().subtract(const Duration(days: 2))),
          TimelineEvent(
              status: 'Dekh Li Gayi',
              description: 'Nagar Palika Parishad dwara shikayat dekhi gayi.',
              date: DateTime.now().subtract(const Duration(days: 1))),
          TimelineEvent(
              status: 'Kaam Jaari Hai',
              description: 'Safai karmi team ko bheja ja raha hai.',
              date: DateTime.now().subtract(const Duration(hours: 8))),
        ]),
    Complaint(
        id: 'C002',
        title: 'Bijli ka khamba tedha hai',
        location: 'Allahabad Road, Kareli ke paas',
        latitude: 25.4410,
        longitude: 81.8515,
        date: DateTime.now().subtract(const Duration(days: 15)),
        status: ComplaintStatus.resolved,
        description:
        'Tez hawa ke baad se Allahabad Road par ek bijli ka khamba khatarnak roop se jhuk gaya hai. Kabhi bhi gir sakta hai.',
        imageUrl:
        'https://placehold.co/600x400/cccccc/ffffff?text=Electric+Pole',
        timeline: [
          TimelineEvent(
              status: 'Jama Ki Gayi',
              description: 'Shikayat user dwara jama ki gayi.',
              date: DateTime.now().subtract(const Duration(days: 15))),
          TimelineEvent(
              status: 'Hal Ho Gayi',
              description: 'Vidyut Vibhag ne khambe ko theek kar diya hai.',
              date: DateTime.now().subtract(const Duration(days: 3))),
        ]),
    Complaint(
        id: 'C003',
        title: 'Sabzi Mandi mein kachra',
        location: 'Sabzi Mandi, Kareli',
        latitude: 25.4385,
        longitude: 81.8490,
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: ComplaintStatus.pending,
        description:
        'Sabzi Mandi ke kone mein kachre ka dher laga hai, jisse bahut badboo aa rahi hai. Ise turant hatwaya jaaye.',
        imageUrl: 'https://placehold.co/600x400/cccccc/ffffff?text=Kachra',
        timeline: [
          TimelineEvent(
              status: 'Jama Ki Gayi',
              description: 'Shikayat user dwara jama ki gayi.',
              date: DateTime.now().subtract(const Duration(days: 1))),
        ]),
  ];

  // User ki saari complaints fetch karne ko simulate karta hai.
  Future<List<Complaint>> getMyComplaints() async {
    // 1 second ka network delay simulate karega.
    await Future.delayed(const Duration(seconds: 1));
    // Ab hum memory se list return karenge.
    return List.from(_mockComplaints.reversed);
  }

  // Nayi complaint submit karne ko simulate karta hai.
  Future<bool> submitComplaint({
    required String title,
    required String description,
    required String imagePath,
    required String location,
    double? latitude, // ADDED
    double? longitude, // ADDED
  }) async {
    // 1.5 second ka network delay simulate karega.
    await Future.delayed(const Duration(milliseconds: 1500));

    // Ek nayi complaint banayenge aur use list mein add karenge.
    final newComplaint = Complaint(
      id: 'C${Random().nextInt(1000)}',
      title: title,
      location: location,
      latitude: latitude, // ADDED
      longitude: longitude, // ADDED
      date: DateTime.now(),
      status: ComplaintStatus.pending,
      description: description,
      imageUrl: imagePath,
      timeline: [
        TimelineEvent(
          status: 'Jama Ki Gayi',
          description: 'Shikayat user dwara jama ki gayi.',
          date: DateTime.now(),
        ),
      ],
    );

    _mockComplaints.add(newComplaint);

    print('--- Nayi Shikayat Jama Ki Gayi ---');
    print('Title: $title');
    print('Location: $location ($latitude, $longitude)'); // Updated log
    print('Total Shikayatein: ${_mockComplaints.length}');
    print('---------------------------------');

    // Success (true) return karega.
    return true;
  }
}