// // // import 'dart:developer';
// // // import 'package:helpcivic/constants.dart';
// // // import 'package:mongo_dart/mongo_dart.dart';
// // //
// // // class MongoDatabase {
// // //   // Static variables to hold the database and collections
// // //   static var db;
// // //   static var usersCollection;
// // //   static var complaintsCollection;
// // //
// // //   // Connect method now saves the connection
// // //   static connect() async {
// // //     try {
// // //       db = await Db.create(MONGO_URL);
// // //       await db.open();
// // //       inspect(db); // For debugging
// // //       var status = db.serverStatus();
// // //       print("--- MongoDB Connection Status ---");
// // //       print(status);
// // //       print("---------------------------------");
// // //
// // //       // Initialize the collections
// // //       usersCollection = db.collection(USER_COLLECTION);
// // //       complaintsCollection = db.collection(COMPLAINTS_COLLECTION);
// // //     } catch (e) {
// // //       print("Error connecting to MongoDB: $e");
// // //     }
// // //   }
// // //
// // //   // --- NEW: Function to log in a user ---
// // //   static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
// // //     if (db == null || !db.isConnected) {
// // //       print("Database not connected.");
// // //       return null;
// // //     }
// // //     try {
// // //       // Find the user by email
// // //       final user = await usersCollection.findOne(where.eq('email', email));
// // //
// // //       // Check if user exists and if the password matches
// // //       // IMPORTANT: In a real app, passwords MUST be hashed. This is for demo purposes only.
// // //       if (user != null && user['password'] == password) {
// // //         print("Login successful for: ${user['name']}");
// // //         return user;
// // //       } else {
// // //         print("Invalid email or password.");
// // //         return null;
// // //       }
// // //     } catch (e) {
// // //       print("Error during login: $e");
// // //       return null;
// // //     }
// // //   }
// // //
// // //   // --- Function to insert a new user into the database ---
// // //   static Future<void> insertUser(Map<String, dynamic> userData) async {
// // //     if (db == null || !db.isConnected) {
// // //       print("Database not connected. Attempting to reconnect...");
// // //       await connect();
// // //     }
// // //     // Ensure we have a valid collection before trying to insert
// // //     if (usersCollection == null) {
// // //       print("Users collection is not initialized.");
// // //       return;
// // //     }
// // //     try {
// // //       await usersCollection.insertOne(userData);
// // //       print("User inserted successfully!");
// // //     } catch (e) {
// // //       print("Error inserting user: $e");
// // //     }
// // //   }
// // //
// // //   // Function to get all complaints from the database
// // //   static Future<List<Map<String, dynamic>>> getComplaints() async {
// // //     if (db == null || !db.isConnected) {
// // //       print("Database not connected. Attempting to reconnect...");
// // //       await connect();
// // //     }
// // //     // Ensure we have a valid collection before trying to query
// // //     if (complaintsCollection == null) {
// // //       print("Complaints collection is not initialized.");
// // //       return [];
// // //     }
// // //     try {
// // //       // Find all documents in the complaints collection and convert them to a list
// // //       final complaints = await complaintsCollection.find().toList();
// // //       return complaints;
// // //     } catch (e) {
// // //       print("Error fetching complaints: $e");
// // //       return []; // Return an empty list on error
// // //     }
// // //   }
// // //
// // //   // Function to insert a new complaint into the database
// // //   static Future<void> insertComplaint(Map<String, dynamic> complaintData) async {
// // //     if (db == null || !db.isConnected) {
// // //       print("Database not connected. Attempting to reconnect...");
// // //       await connect();
// // //     }
// // //     // Ensure we have a valid collection before trying to insert
// // //     if (complaintsCollection == null) {
// // //       print("Complaints collection is not initialized.");
// // //       return;
// // //     }
// // //     try {
// // //       await complaintsCollection.insertOne(complaintData);
// // //       print("Complaint inserted successfully!");
// // //     } catch (e) {
// // //       print("Error inserting complaint: $e");
// // //     }
// // //   }
// // // }
// // //
// //
// //
// // // import 'dart:developer';
// // // import 'package:helpcivic/constants.dart';
// // // import 'package:mongo_dart/mongo_dart.dart';
// // //
// // // class MongoDatabase {
// // //   static var db;
// // //   static var usersCollection;
// // //   static var complaintsCollection;
// // //
// // //   static connect() async {
// // //     try {
// // //       db = await Db.create(MONGO_URL);
// // //       await db.open();
// // //       inspect(db);
// // //       var status = db.serverStatus();
// // //       print("--- MongoDB Connection Status ---");
// // //       print(status);
// // //       print("---------------------------------");
// // //
// // //       usersCollection = db.collection(USER_COLLECTION);
// // //       complaintsCollection = db.collection(COMPLAINTS_COLLECTION);
// // //     } catch (e) {
// // //       print("Error connecting to MongoDB: $e");
// // //     }
// // //   }
// // //
// // //   static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
// // //     if (db == null || !db.isConnected) {
// // //       print("Database not connected.");
// // //       return null;
// // //     }
// // //     try {
// // //       final user = await usersCollection.findOne(where.eq('email', email));
// // //       if (user != null && user['password'] == password) {
// // //         print("Login successful for: ${user['name']}");
// // //         return user;
// // //       } else {
// // //         print("Invalid email or password.");
// // //         return null;
// // //       }
// // //     } catch (e) {
// // //       print("Error during login: $e");
// // //       return null;
// // //     }
// // //   }
// // //
// // //   // --- UPDATED: This function now checks for duplicates and returns a boolean ---
// // //   static Future<bool> insertUser(Map<String, dynamic> userData) async {
// // //     if (db == null || !db.isConnected) {
// // //       print("Database not connected.");
// // //       return false; // Return false to indicate failure
// // //     }
// // //     try {
// // //       // 1. Check if a user with this email already exists
// // //       final existingUser = await usersCollection.findOne(where.eq('email', userData['email']));
// // //
// // //       if (existingUser != null) {
// // //         // 2. If user exists, print a message and return false
// // //         print("User with this email already exists.");
// // //         return false;
// // //       } else {
// // //         // 3. If user does not exist, insert the new user and return true
// // //         await usersCollection.insertOne(userData);
// // //         print("User inserted successfully!");
// // //         return true;
// // //       }
// // //     } catch (e) {
// // //       print("Error inserting user: $e");
// // //       return false; // Return false on any other error
// // //     }
// // //   }
// // //
// // //   static Future<List<Map<String, dynamic>>> getComplaints() async {
// // //     if (db == null || !db.isConnected) {
// // //       print("Database not connected.");
// // //       return [];
// // //     }
// // //     try {
// // //       final complaints = await complaintsCollection.find().toList();
// // //       return complaints;
// // //     } catch (e) {
// // //       print("Error fetching complaints: $e");
// // //       return [];
// // //     }
// // //   }
// // //
// // //   static Future<void> insertComplaint(Map<String, dynamic> complaintData) async {
// // //     if (db == null || !db.isConnected) {
// // //       print("Database not connected.");
// // //       return;
// // //     }
// // //     try {
// // //       await complaintsCollection.insertOne(complaintData);
// // //       print("Complaint inserted successfully!");
// // //     } catch (e) {
// // //       print("Error inserting complaint: $e");
// // //     }
// // //   }
// // // }
// //
// // import 'dart:developer';
// // import 'package:helpcivic/constants.dart';
// // import 'package:mongo_dart/mongo_dart.dart';
// //
// // class MongoDatabase {
// //   static var db;
// //   static var usersCollection;
// //   static var complaintsCollection;
// //
// //   // Static variable to store the ID of the logged-in user
// //   static ObjectId? loggedInUserId;
// //
// //   static connect() async {
// //     try {
// //       db = await Db.create(MONGO_URL);
// //       await db.open();
// //       inspect(db);
// //       var status = db.serverStatus();
// //       print("--- MongoDB Connection Status ---");
// //       print(status);
// //       print("---------------------------------");
// //
// //       usersCollection = db.collection(USER_COLLECTION);
// //       complaintsCollection = db.collection(COMPLAINTS_COLLECTION);
// //     } catch (e) {
// //       print("Error connecting to MongoDB: $e");
// //     }
// //   }
// //
// //   static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
// //     if (db == null || !db.isConnected) return null;
// //     try {
// //       final user = await usersCollection.findOne(where.eq('email', email));
// //       if (user != null && user['password'] == password) {
// //         // Save the user's ID upon successful login
// //         loggedInUserId = user['_id'];
// //         print("Login successful for: ${user['name']}, ID: $loggedInUserId");
// //         return user;
// //       } else {
// //         return null;
// //       }
// //     } catch (e) {
// //       print("Error during login: $e");
// //       return null;
// //     }
// //   }
// //
// //   static Future<bool> insertUser(Map<String, dynamic> userData) async {
// //     if (db == null || !db.isConnected) return false;
// //     try {
// //       final existingUser = await usersCollection.findOne(where.eq('email', userData['email']));
// //       if (existingUser != null) {
// //         return false; // User already exists
// //       } else {
// //         final result = await usersCollection.insertOne(userData);
// //         if (result.isSuccess) {
// //           // Save the new user's ID upon successful registration
// //           loggedInUserId = userData['_id'];
// //           print("User inserted successfully! ID: $loggedInUserId");
// //         }
// //         return result.isSuccess;
// //       }
// //     } catch (e) {
// //       print("Error inserting user: $e");
// //       return false;
// //     }
// //   }
// //
// //   static Future<List<Map<String, dynamic>>> getComplaints() async {
// //     if (db == null || !db.isConnected || loggedInUserId == null) {
// //       print("Database not connected or user not logged in.");
// //       return [];
// //     }
// //     try {
// //       // Only fetch complaints where the 'userId' field matches the logged-in user's ID
// //       final complaints = await complaintsCollection.find(where.eq('userId', loggedInUserId)).toList();
// //       return complaints;
// //     } catch (e) {
// //       print("Error fetching complaints: $e");
// //       return [];
// //     }
// //   }
// //
// //   // This function now links the complaint to the user
// //   static Future<void> insertComplaint(Map<String, dynamic> complaintData) async {
// //     if (db == null || !db.isConnected || loggedInUserId == null) {
// //       print("Database not connected or user not logged in.");
// //       return;
// //     }
// //     try {
// //       // 1. Add the logged-in user's ID to the complaint data
// //       complaintData['userId'] = loggedInUserId;
// //
// //       // 2. Insert the complaint into the complaints collection
// //       await complaintsCollection.insertOne(complaintData);
// //       print("Complaint inserted successfully!");
// //
// //       // 3. Get the new complaint's ID
// //       final newComplaintId = complaintData['_id'];
// //
// //       // 4. Add the new complaint's ID to the user's 'complaints' array in the users collection
// //       await usersCollection.updateOne(
// //         where.id(loggedInUserId!),
// //         modify.push('complaints', newComplaintId),
// //       );
// //       print("Updated user's complaint array.");
// //
// //     } catch (e) {
// //       print("Error inserting complaint: $e");
// //     }
// //   }
// // }
// //
// // import 'dart:developer';
// // import 'package:helpcivic/constants.dart';
// // import 'package:mongo_dart/mongo_dart.dart';
// //
// // class MongoDatabase {
// //   static var db;
// //   static var usersCollection;
// //   static var complaintsCollection;
// //
// //   // Static variable to store the ID of the logged-in user
// //   static ObjectId? loggedInUserId;
// //
// //   static connect() async {
// //     try {
// //       db = await Db.create(MONGO_URL);
// //       await db.open();
// //       inspect(db);
// //       var status = db.serverStatus();
// //       print("--- MongoDB Connection Status ---");
// //       print(status);
// //       print("---------------------------------");
// //
// //       usersCollection = db.collection(USER_COLLECTION);
// //       complaintsCollection = db.collection(COMPLAINTS_COLLECTION);
// //     } catch (e) {
// //       print("Error connecting to MongoDB: $e");
// //     }
// //   }
// //
// //   static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
// //     if (db == null || !db.isConnected) return null;
// //     try {
// //       final user = await usersCollection.findOne(where.eq('email', email));
// //       if (user != null && user['password'] == password) {
// //         // Save the user's ID upon successful login
// //         loggedInUserId = user['_id'];
// //         print("Login successful for: ${user['name']}, ID: $loggedInUserId");
// //         return user;
// //       } else {
// //         return null;
// //       }
// //     } catch (e) {
// //       print("Error during login: $e");
// //       return null;
// //     }
// //   }
// //
// //   static Future<bool> insertUser(Map<String, dynamic> userData) async {
// //     if (db == null || !db.isConnected) return false;
// //     try {
// //       final existingUser = await usersCollection.findOne(where.eq('email', userData['email']));
// //       if (existingUser != null) {
// //         return false; // User already exists
// //       } else {
// //         // MongoDB creates the _id during the insert operation
// //         final result = await usersCollection.insertOne(userData);
// //         if (result.isSuccess) {
// //           // If you need the ID immediately after registration, you'll need to fetch the inserted document or rely on the driver populating it.
// //           // For now, we'll just assume login will happen next.
// //           print("User inserted successfully!");
// //         }
// //         return result.isSuccess;
// //       }
// //     } catch (e) {
// //       print("Error inserting user: $e");
// //       return false;
// //     }
// //   }
// //
// //   static Future<Map<String, dynamic>?> getUserById(ObjectId userId) async {
// //     if (db == null || !db.isConnected) {
// //       print("Database not connected.");
// //       return null;
// //     }
// //     try {
// //       // Find one document where the _id matches the provided userId
// //       final user = await usersCollection.findOne(where.id(userId));
// //       return user;
// //     } catch (e) {
// //       print("Error fetching user by ID: $e");
// //       return null;
// //     }
// //   }
// //
// //   static Future<List<Map<String, dynamic>>> getComplaints() async {
// //     if (db == null || !db.isConnected || loggedInUserId == null) {
// //       print("Database not connected or user not logged in.");
// //       return [];
// //     }
// //     try {
// //       // Only fetch complaints where the 'userId' field matches the logged-in user's ID
// //       final complaints = await complaintsCollection.find(where.eq('userId', loggedInUserId)).toList();
// //       return complaints;
// //     } catch (e) {
// //       print("Error fetching complaints: $e");
// //       return [];
// //     }
// //   }
// //
// //   // 👇 The CORRECTED function to link the complaint to the user
// //   static Future<String?> insertComplaint(Map<String, dynamic> complaintData) async {
// //     if (db == null || !db.isConnected || loggedInUserId == null) {
// //       print("Database not connected or user not logged in.");
// //       return null;
// //     }
// //     try {
// //       // 1. Add the logged-in user's ID to the complaint data
// //       // This is crucial for linking the complaint back to the user later.
// //       complaintData['userId'] = loggedInUserId;
// //
// //       // 2. Insert the complaint into the 'complaints' collection
// //       final WriteResult result = await complaintsCollection.insertOne(complaintData);
// //
// //       if (!result.isSuccess) {
// //         print("Failed to insert complaint into collection.");
// //         return null;
// //       }
// //
// //       print("Complaint inserted successfully!");
// //
// //       // 3. Get the new complaint's ID (which is now in the map after insertion)
// //       final newComplaintId = complaintData['_id'];
// //
// //       if (newComplaintId == null) {
// //         print("Error: Could not retrieve new complaint ID.");
// //         return null;
// //       }
// //
// //
// //       // 4. Add the new complaint's ID to the user's 'complaints' array in the 'users' collection
// //       await usersCollection.updateOne(
// //         where.id(loggedInUserId!), // Find the logged-in user
// //         modify.push('complaints', newComplaintId), // Push the new ID to the array
// //       );
// //       print("Updated user's complaint array with ID: $newComplaintId");
// //
// //       // Return the new complaint ID as a String (assuming ObjectId.toHexString())
// //       return newComplaintId.toHexString();
// //
// //     } catch (e) {
// //       print("Error inserting complaint: $e");
// //       return null;
// //     }
// //   }
// // }
// //
// // import 'dart:developer';
// // import 'package:helpcivic/constants.dart';
// // import 'package:mongo_dart/mongo_dart.dart';
// //
// // class MongoDatabase {
// //   static var db;
// //   static var usersCollection;
// //   static var complaintsCollection;
// //
// //   // Static variable to store the ID of the logged-in user
// //   static ObjectId? loggedInUserId;
// //
// //   static connect() async {
// //     try {
// //       db = await Db.create(MONGO_URL);
// //       await db.open();
// //       inspect(db);
// //       var status = db.serverStatus();
// //       print("--- MongoDB Connection Status ---");
// //       print(status);
// //       print("---------------------------------");
// //
// //       usersCollection = db.collection(USER_COLLECTION);
// //       complaintsCollection = db.collection(COMPLAINTS_COLLECTION);
// //     } catch (e) {
// //       print("Error connecting to MongoDB: $e");
// //     }
// //   }
// //
// //   static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
// //     if (db == null || !db.isConnected) return null;
// //     try {
// //       final user = await usersCollection.findOne(where.eq('email', email));
// //       if (user != null && user['password'] == password) {
// //         // Save the user's ID upon successful login
// //         loggedInUserId = user['_id'];
// //         print("Login successful for: ${user['name']}, ID: $loggedInUserId");
// //         return user;
// //       } else {
// //         return null;
// //       }
// //     } catch (e) {
// //       print("Error during login: $e");
// //       return null;
// //     }
// //   }
// //
// //   static Future<bool> insertUser(Map<String, dynamic> userData) async {
// //     if (db == null || !db.isConnected) return false;
// //     try {
// //       final existingUser = await usersCollection.findOne(where.eq('email', userData['email']));
// //       if (existingUser != null) {
// //         return false; // User already exists
// //       } else {
// //         // MongoDB creates the _id during the insert operation
// //         final result = await usersCollection.insertOne(userData);
// //         if (result.isSuccess) {
// //           // If you need the ID immediately after registration, you'll need to fetch the inserted document or rely on the driver populating it.
// //           // For now, we'll just assume login will happen next.
// //           print("User inserted successfully!");
// //         }
// //         return result.isSuccess;
// //       }
// //     } catch (e) {
// //       print("Error inserting user: $e");
// //       return false;
// //     }
// //   }
// //
// //   static Future<Map<String, dynamic>?> getUserById(ObjectId userId) async {
// //     if (db == null || !db.isConnected) {
// //       print("Database not connected.");
// //       return null;
// //     }
// //     try {
// //       // Find one document where the _id matches the provided userId
// //       final user = await usersCollection.findOne(where.id(userId));
// //       return user;
// //     } catch (e) {
// //       print("Error fetching user by ID: $e");
// //       return null;
// //     }
// //   }
// //
// //   static Future<List<Map<String, dynamic>>> getComplaints() async {
// //     if (db == null || !db.isConnected || loggedInUserId == null) {
// //       print("Database not connected or user not logged in.");
// //       return [];
// //     }
// //     try {
// //       // Only fetch complaints where the 'userId' field matches the logged-in user's ID
// //       final complaints = await complaintsCollection.find(where.eq('userId', loggedInUserId)).toList();
// //       return complaints;
// //     } catch (e) {
// //       print("Error fetching complaints: $e");
// //       return [];
// //     }
// //   }
// //
// //   // 👇 The CORRECTED function to link the complaint to the user
// //   static Future<String?> insertComplaint(Map<String, dynamic> complaintData) async {
// //     if (db == null || !db.isConnected || loggedInUserId == null) {
// //       print("Database not connected or user not logged in.");
// //       return null;
// //     }
// //     try {
// //       // 1. Add the logged-in user's ID to the complaint data
// //       // This is crucial for linking the complaint back to the user later.
// //       complaintData['userId'] = loggedInUserId;
// //
// //       // 2. Insert the complaint into the 'complaints' collection
// //       final WriteResult result = await complaintsCollection.insertOne(complaintData);
// //
// //       if (!result.isSuccess) {
// //         print("Failed to insert complaint into collection.");
// //         return null;
// //       }
// //
// //       print("Complaint inserted successfully!");
// //
// //       // 3. Get the new complaint's ID (which is now in the map after insertion)
// //       final newComplaintId = complaintData['_id'];
// //
// //       if (newComplaintId == null) {
// //         print("Error: Could not retrieve new complaint ID.");
// //         return null;
// //       }
// //
// //
// //       // 4. Add the new complaint's ID to the user's 'complaints' array in the 'users' collection
// //       await usersCollection.updateOne(
// //         where.id(loggedInUserId!), // Find the logged-in user
// //         modify.push('complaints', newComplaintId), // Push the new ID to the array
// //       );
// //       print("Updated user's complaint array with ID: $newComplaintId");
// //
// //       // Return the new complaint ID as a String (assuming ObjectId.toHexString())
// //       return newComplaintId.toHexString();
// //
// //     } catch (e) {
// //       print("Error inserting complaint: $e");
// //       return null;
// //     }
// //   }
// // }
//
// // this was workking
//
//
// import 'dart:developer';
// import 'package:helpcivic/constants.dart';
// import 'package:mongo_dart/mongo_dart.dart';
//
// // Assuming MUNICIPALITY_COLLECTION is defined in constants.dart
// // e.g., const String MUNICIPALITY_COLLECTION = 'municipality_complaints';
//
// class MongoDatabase {
//   static var db;
//   static var usersCollection;
//   static var complaintsCollection;
//   // 👇 NEW: Collection for aggregating complaints by municipality/district
//   static var municipalityComplaintsCollection;
//
//   // Static variable to store the ID of the logged-in user
//   static ObjectId? loggedInUserId;
//
//   static connect() async {
//     try {
//       db = await Db.create(MONGO_URL);
//       await db.open();
//       inspect(db);
//       var status = db.serverStatus();
//       print("--- MongoDB Connection Status ---");
//       print(status);
//       print("---------------------------------");
//
//       usersCollection = db.collection(USER_COLLECTION);
//       complaintsCollection = db.collection(COMPLAINTS_COLLECTION);
//       // 👇 Initialize the new municipality collection
//       municipalityComplaintsCollection = db.collection(MUNICIPAL_COMPLAINTS_COLLECTION);
//     } catch (e) {
//       print("Error connecting to MongoDB: $e");
//     }
//   }
//
//   // --- Utility function for municipality-based aggregation ---
//   static Future<void> _updateMunicipalityComplaint(
//       ObjectId complaintId,
//       String municipalityName,
//       String stateName,
//       String countryName,
//       ) async {
//     if (db == null || !db.isConnected) return;
//
//     // 1. Define the unique identifier for the municipality document
//     final filter = where.eq('municipalityName', municipalityName);
//
//     // 2. Define the update operation:
//     //    - Push the new complaint ID to the 'complaints' array.
//     //    - Use $setOnInsert to set meta-data only if a new document is created.
//     final update = modify
//         .push('complaints', complaintId) // Add the new complaint ID
//         .set('lastUpdated', DateTime.now().toIso8601String())
//         .setOnInsert('municipalityName', municipalityName)
//         .setOnInsert('stateName', stateName)
//         .setOnInsert('countryName', countryName)
//         .setOnInsert('createdAt', DateTime.now().toIso8601String());
//
//     try {
//       // Perform the update or insert (upsert) operation
//       final result = await municipalityComplaintsCollection.updateOne(
//         filter,
//         update,
//         upsert: true, // If document doesn't exist, create it.
//       );
//
//       if (result.nModified == 1 || result.upsertedId != null) {
//         print("Municipality record updated successfully: $municipalityName");
//       } else {
//         print("Failed to update municipality record for: $municipalityName");
//       }
//     } catch (e) {
//       print("Error updating municipality record: $e");
//     }
//   }
//   // -----------------------------------------------------------------
//
//   static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
//     if (db == null || !db.isConnected) return null;
//     try {
//       final user = await usersCollection.findOne(where.eq('email', email));
//       if (user != null && user['password'] == password) {
//         // Save the user's ID upon successful login
//         loggedInUserId = user['_id'];
//         print("Login successful for: ${user['name']}, ID: $loggedInUserId");
//         return user;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print("Error during login: $e");
//       return null;
//     }
//   }
//
//   static Future<bool> insertUser(Map<String, dynamic> userData) async {
//     if (db == null || !db.isConnected) return false;
//     try {
//       final existingUser = await usersCollection.findOne(where.eq('email', userData['email']));
//       if (existingUser != null) {
//         return false; // User already exists
//       } else {
//         // MongoDB creates the _id during the insert operation
//         final result = await usersCollection.insertOne(userData);
//         if (result.isSuccess) {
//           // If you need the ID immediately after registration, you'll need to fetch the inserted document or rely on the driver populating it.
//           // For now, we'll just assume login will happen next.
//           print("User inserted successfully!");
//         }
//         return result.isSuccess;
//       }
//     } catch (e) {
//       print("Error inserting user: $e");
//       return false;
//     }
//   }
//
//   static Future<Map<String, dynamic>?> getUserById(ObjectId userId) async {
//     if (db == null || !db.isConnected) {
//       print("Database not connected.");
//       return null;
//     }
//     try {
//       // Find one document where the _id matches the provided userId
//       final user = await usersCollection.findOne(where.id(userId));
//       return user;
//     } catch (e) {
//       print("Error fetching user by ID: $e");
//       return null;
//     }
//   }
//
//   static Future<List<Map<String, dynamic>>> getComplaints() async {
//     if (db == null || !db.isConnected || loggedInUserId == null) {
//       print("Database not connected or user not logged in.");
//       return [];
//     }
//     try {
//       // Only fetch complaints where the 'userId' field matches the logged-in user's ID
//       final complaints = await complaintsCollection.find(where.eq('userId', loggedInUserId)).toList();
//       return complaints;
//     } catch (e) {
//       print("Error fetching complaints: $e");
//       return [];
//     }
//   }
//
//   // 👇 The UPDATED function to link the complaint to the user and municipality
//   static Future<String?> insertComplaint(Map<String, dynamic> complaintData) async {
//     if (db == null || !db.isConnected || loggedInUserId == null) {
//       print("Database not connected or user not logged in.");
//       return null;
//     }
//     try {
//       // 1. Add the logged-in user's ID to the complaint data
//       complaintData['userId'] = loggedInUserId;
//
//       // 2. Insert the complaint into the 'complaints' collection
//       final WriteResult result = await complaintsCollection.insertOne(complaintData);
//
//       if (!result.isSuccess) {
//         print("Failed to insert complaint into collection.");
//         return null;
//       }
//
//       print("Complaint inserted successfully!");
//
//       // 3. Get the new complaint's ID (which is now in the map after insertion)
//       final newComplaintId = complaintData['_id'];
//
//       if (newComplaintId == null) {
//         print("Error: Could not retrieve new complaint ID.");
//         return null;
//       }
//
//       // 4. Add the new complaint's ID to the user's 'complaints' array
//       await usersCollection.updateOne(
//         where.id(loggedInUserId!), // Find the logged-in user
//         modify.push('complaints', newComplaintId), // Push the new ID to the array
//       );
//       print("Updated user's complaint array with ID: $newComplaintId");
//
//       // 5. CRITICAL: Update the municipality aggregation document
//       // 👇 FIX: Use null-coalescing to ensure non-null String values are passed.
//       await _updateMunicipalityComplaint(
//         newComplaintId,
//         (complaintData['municipalityName'] as String?) ?? 'Unknown Municipality',
//         (complaintData['stateName'] as String?) ?? 'Unknown State',
//         (complaintData['countryName'] as String?) ?? 'Unknown Country',
//       );
//
//       // Return the new complaint ID as a String
//       return newComplaintId.toHexString();
//
//     } catch (e) {
//       print("Error inserting complaint: $e");
//       return null;
//     }
//   }
// }

// working finne


import 'dart:developer';
import 'package:helpcivic/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

// Assuming MUNICIPALITY_COLLECTION points to your desired collection
// (e.g., 'municipalities_new' or 'municipality_complaints')

class MongoDatabase {
  static var db;
  static var usersCollection;
  static var complaintsCollection;
  // This collection will now store district summary data (counts)
  static var municipalityComplaintsCollection;

  // Static variable to store the ID of the logged-in user
  static ObjectId? loggedInUserId;

  static connect() async {
    // Prevent connecting if the database is already open
    if (db != null && db.isConnected) {
      print("MongoDB is already connected.");
      return;
    }

    try {
      db = await Db.create(MONGO_URL);
      await db.open();
      inspect(db);
      var status = db.serverStatus();
      print("--- MongoDB Connection Status ---");
      print(status);
      print("---------------------------------");

      usersCollection = db.collection(USER_COLLECTION);
      complaintsCollection = db.collection(COMPLAINTS_COLLECTION);
      // Initialize the municipality collection (now used for district summary)
      municipalityComplaintsCollection = db.collection(MUNICIPAL_COMPLAINTS_COLLECTION);
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    }
  }

  // New method to explicitly close the connection
  static Future<void> disconnect() async {
    if (db != null && db.isConnected) {
      await db.close();
      print("MongoDB connection closed.");
    }
  }

  // --- Utility function for district-based aggregation and counting ---
  static Future<void> _updateMunicipalityComplaint(
      ObjectId complaintId,
      String municipalityName, // This is treated as the district name
      String stateName,
      String countryName,
      ) async {
    if (db == null || !db.isConnected) return;

    // 1. Sanitize the municipality name for reliable filtering
    var sanitizedMunicipalityName = municipalityName.trim();

    // Ensure the district name is never an empty string.
    if (sanitizedMunicipalityName.isEmpty) {
      sanitizedMunicipalityName = 'Unknown District';
    }

    // 2. Define the unique identifier for the district document
    // NOTE: This confirms the mapping: complaint.municipalityName -> municipality_new.district_name
    final filter = where.eq('district_name', sanitizedMunicipalityName);

    // 3. Define the update operation:
    final update = modify
        .inc('pending', 1) // CRITICAL: Atomically increment the pending counter
        .set('lastUpdated', DateTime.now().toIso8601String())
        .setOnInsert('district_name', sanitizedMunicipalityName) // Set the district identifier
        .setOnInsert('stateName', stateName.trim()) // Store the state name
        .setOnInsert('countryName', countryName.trim()) // Store the country name
        .setOnInsert('createdAt', DateTime.now().toIso8601String())
        .setOnInsert('resolved', 0); // Initialize other counters if new

    try {
      // Perform the update or insert (upsert) operation
      final result = await municipalityComplaintsCollection.updateOne(
        filter,
        update,
        upsert: true, // If document doesn't exist, create it.
      );

      if (result.nModified == 1 || result.upsertedId != null) {
        print("District summary record updated successfully: $sanitizedMunicipalityName. Pending count incremented.");
      } else {
        print("Failed to update district summary record for: $sanitizedMunicipalityName");
      }
    } catch (e) {
      print("Error updating district summary record: $e");
    }
  }
  // -----------------------------------------------------------------

  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    if (db == null || !db.isConnected) return null;
    try {
      final user = await usersCollection.findOne(where.eq('email', email));
      if (user != null && user['password'] == password) {
        // Save the user's ID upon successful login
        loggedInUserId = user['_id'];
        print("Login successful for: ${user['name']}, ID: $loggedInUserId");
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  static Future<bool> insertUser(Map<String, dynamic> userData) async {
    if (db == null || !db.isConnected) return false;
    try {
      final existingUser = await usersCollection.findOne(where.eq('email', userData['email']));
      if (existingUser != null) {
        return false; // User already exists
      } else {
        // MongoDB creates the _id during the insert operation
        final result = await usersCollection.insertOne(userData);
        if (result.isSuccess) {
          // If you need the ID immediately after registration, you'll need to fetch the inserted document or rely on the driver populating it.
          // For now, we'll just assume login will happen next.
          print("User inserted successfully!");
        }
        return result.isSuccess;
      }
    } catch (e) {
      print("Error inserting user: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getUserById(ObjectId userId) async {
    if (db == null || !db.isConnected) {
      print("Database not connected.");
      return null;
    }
    try {
      // Find one document where the _id matches the provided userId
      final user = await usersCollection.findOne(where.id(userId));
      return user;
    } catch (e) {
      print("Error fetching user by ID: $e");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getComplaints() async {
    if (db == null || !db.isConnected || loggedInUserId == null) {
      print("Database not connected or user not logged in.");
      return [];
    }
    try {
      // Only fetch complaints where the 'userId' field matches the logged-in user's ID
      final complaints = await complaintsCollection.find(where.eq('userId', loggedInUserId)).toList();
      return complaints;
    } catch (e) {
      print("Error fetching complaints: $e");
      return [];
    }
  }

  // 👇 The UPDATED function to link the complaint to the user and municipality
  static Future<String?> insertComplaint(Map<String, dynamic> complaintData) async {
    if (db == null || !db.isConnected || loggedInUserId == null) {
      print("Database not connected or user not logged in.");
      return null;
    }
    String? newComplaintIdString;
    try {
      // 1. Add the logged-in user's ID to the complaint data
      complaintData['userId'] = loggedInUserId;

      // 2. Insert the complaint into the 'complaints' collection
      final WriteResult result = await complaintsCollection.insertOne(complaintData);

      if (!result.isSuccess) {
        print("Failed to insert complaint into collection.");
        return null;
      }

      print("Complaint inserted successfully!");

      // 3. Get the new complaint's ID (which is now in the map after insertion)
      final newComplaintId = complaintData['_id'];

      if (newComplaintId == null) {
        print("Error: Could not retrieve new complaint ID.");
        return null;
      }
      newComplaintIdString = newComplaintId.toHexString();

      // 4. Add the new complaint's ID to the user's 'complaints' array
      await usersCollection.updateOne(
        where.id(loggedInUserId!), // Find the logged-in user
        modify.push('complaints', newComplaintId), // Push the new ID to the array
      );
      print("Updated user's complaint array with ID: $newComplaintId");

      // 5. CRITICAL: Update the municipality aggregation document
      // Added explicit casting and null checks for robustness.
      await _updateMunicipalityComplaint(
        newComplaintId,
        (complaintData['municipalityName'] as String?) ?? 'Unknown Municipality',
        (complaintData['stateName'] as String?) ?? 'Unknown State',
        (complaintData['countryName'] as String?) ?? 'Unknown Country',
      );

      // We remove the aggressive disconnect/reconnect here to let the driver manage the connection pool naturally.

      // Return the new complaint ID as a String
      return newComplaintIdString;

    } catch (e, stackTrace) {
      print("Error inserting complaint: $e");
      print("Stack Trace: $stackTrace"); // Log the full stack trace for debugging

      // Still attempt to reset the connection on error as a defensive measure
      await disconnect();
      await MongoDatabase.connect();
      return null;
    }
  }
}
