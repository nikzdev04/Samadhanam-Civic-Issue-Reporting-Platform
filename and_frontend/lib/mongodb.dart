import 'dart:developer';
import 'package:helpcivic/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  // Static variables to hold the database and collections
  static var db;
  static var usersCollection;
  static var complaintsCollection;

  // Connect method now saves the connection
  static connect() async {
    try {
      db = await Db.create(MONGO_URL);
      await db.open();
      inspect(db); // For debugging
      var status = db.serverStatus();
      print("--- MongoDB Connection Status ---");
      print(status);
      print("---------------------------------");

      // Initialize the collections
      usersCollection = db.collection(USER_COLLECTION);
      complaintsCollection = db.collection(COMPLAINTS_COLLECTION);
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    }
  }

  // --- NEW: Function to log in a user ---
  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    if (db == null || !db.isConnected) {
      print("Database not connected.");
      return null;
    }
    try {
      // Find the user by email
      final user = await usersCollection.findOne(where.eq('email', email));

      // Check if user exists and if the password matches
      // IMPORTANT: In a real app, passwords MUST be hashed. This is for demo purposes only.
      if (user != null && user['password'] == password) {
        print("Login successful for: ${user['name']}");
        return user;
      } else {
        print("Invalid email or password.");
        return null;
      }
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  // --- Function to insert a new user into the database ---
  static Future<void> insertUser(Map<String, dynamic> userData) async {
    if (db == null || !db.isConnected) {
      print("Database not connected. Attempting to reconnect...");
      await connect();
    }
    // Ensure we have a valid collection before trying to insert
    if (usersCollection == null) {
      print("Users collection is not initialized.");
      return;
    }
    try {
      await usersCollection.insertOne(userData);
      print("User inserted successfully!");
    } catch (e) {
      print("Error inserting user: $e");
    }
  }

  // Function to get all complaints from the database
  static Future<List<Map<String, dynamic>>> getComplaints() async {
    if (db == null || !db.isConnected) {
      print("Database not connected. Attempting to reconnect...");
      await connect();
    }
    // Ensure we have a valid collection before trying to query
    if (complaintsCollection == null) {
      print("Complaints collection is not initialized.");
      return [];
    }
    try {
      // Find all documents in the complaints collection and convert them to a list
      final complaints = await complaintsCollection.find().toList();
      return complaints;
    } catch (e) {
      print("Error fetching complaints: $e");
      return []; // Return an empty list on error
    }
  }

  // Function to insert a new complaint into the database
  static Future<void> insertComplaint(Map<String, dynamic> complaintData) async {
    if (db == null || !db.isConnected) {
      print("Database not connected. Attempting to reconnect...");
      await connect();
    }
    // Ensure we have a valid collection before trying to insert
    if (complaintsCollection == null) {
      print("Complaints collection is not initialized.");
      return;
    }
    try {
      await complaintsCollection.insertOne(complaintData);
      print("Complaint inserted successfully!");
    } catch (e) {
      print("Error inserting complaint: $e");
    }
  }
}

