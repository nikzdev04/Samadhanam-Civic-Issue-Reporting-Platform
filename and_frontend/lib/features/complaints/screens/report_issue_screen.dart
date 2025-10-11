// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:helpcivic/data/services/api_service.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ReportIssueScreen extends StatefulWidget {
//   const ReportIssueScreen({super.key});
//
//   @override
//   State<ReportIssueScreen> createState() => _ReportIssueScreenState();
// }
//
// class _ReportIssueScreenState extends State<ReportIssueScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _apiService = ApiService();
//
//   XFile? _imageFile;
//   String? _currentAddress;
//   Position? _currentPosition; // To store geo-coordinates
//   bool _isSubmitting = false;
//
//   Future<void> _takePicture() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 80, // Slightly compress the image
//     );
//
//     if (image != null) {
//       setState(() {
//         _imageFile = image;
//       });
//       // Fetch location after taking the photo
//       _getCurrentLocation();
//     }
//   }
//
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Location services are disabled. Please enable them.')));
//       return;
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions were not granted.')));
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//               'Location permissions are permanently denied, we cannot request permissions.')));
//       return;
//     }
//
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       List<Placemark> placemarks =
//       await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];
//
//       setState(() {
//         _currentPosition = position; // Save the geo-coordinates
//         _currentAddress =
//         "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
//       });
//     } catch (e) {
//       print(e);
//       setState(() {
//         _currentAddress = 'Could not fetch location.';
//       });
//     }
//   }
//
//   Future<void> _submitComplaint() async {
//     if (_formKey.currentState!.validate()) {
//       if (_imageFile == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please take a photo to continue.')),
//         );
//         return;
//       }
//
//       setState(() {
//         _isSubmitting = true;
//       });
//
//       bool success = await _apiService.submitComplaint(
//         title: _titleController.text,
//         description: _descriptionController.text,
//         imagePath: _imageFile!.path,
//         location: _currentAddress ?? 'Could not fetch location',
//         latitude: _currentPosition?.latitude,   // Pass latitude
//         longitude: _currentPosition?.longitude, // Pass longitude
//       );
//
//
//
//       if (!mounted) return; // Check if the widget is still in the tree
//
//       setState(() {
//         _isSubmitting = false;
//       });
//
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Complaint submitted successfully!')),
//         );
//         // Go back to the previous screen
//         Navigator.pop(context, true); // Pop with a 'true' result to indicate success
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to submit complaint. Please try again.')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Report a New Complaint'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // --- Image Display Area ---
//               Container(
//                 height: 200,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade400),
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.grey.shade100,
//                 ),
//                 child: _imageFile == null
//                     ? Center(
//                   child: Text(
//                     'Image will appear here',
//                     style: TextStyle(color: Colors.grey.shade600),
//                   ),
//                 )
//                     : ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.file(
//                     File(_imageFile!.path),
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//
//               // --- Location Display ---
//               if (_currentAddress != null)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Text(
//                     '📍 Location: $_currentAddress',
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//
//               // --- Take Picture Button ---
//               ElevatedButton.icon(
//                 onPressed: _takePicture,
//                 icon: const Icon(Icons.camera_alt_rounded),
//                 label: const Text('Take Live Photo'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//               const SizedBox(height: 24),
//
//               // --- Form Fields ---
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Complaint Title',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.label_important_outline_rounded),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title for the complaint.';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Full Description',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.notes_rounded),
//                 ),
//                 maxLines: 4,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please provide a detailed description.';
//                   }
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 24),
//
//               // --- Submit Button ---
//               ElevatedButton(
//                 onPressed: _isSubmitting ? null : _submitComplaint,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   backgroundColor: Theme.of(context).primaryColor,
//                   foregroundColor: Colors.white,
//                 ),
//                 child: _isSubmitting
//                     ? const SizedBox(
//                   height: 24,
//                   width: 24,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 3,
//                   ),
//                 )
//                     : const Text('Submit Complaint'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:helpcivic/data/services/api_service.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
//
// class ReportIssueScreen extends StatefulWidget {
//   const ReportIssueScreen({super.key});
//
//   @override
//   State<ReportIssueScreen> createState() => _ReportIssueScreenState();
// }
//
// class _ReportIssueScreenState extends State<ReportIssueScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final ApiService _apiService = ApiService();
//
//   File? _imageFile;
//   String? _currentAddress;
//   Position? _currentPosition;
//   bool _isSubmitting = false;
//
//   Future<void> _takePicture() async {
//     final picker = ImagePicker();
//     try {
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//       );
//
//       if (pickedFile != null) {
//         setState(() {
//           _imageFile = File(pickedFile.path);
//         });
//         _getCurrentLocation();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to take picture: $e')),
//         );
//       }
//     }
//   }
//
//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Location services are disabled. Please enable them.')));
//       return false;
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions are denied.')));
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Location permissions are permanently denied, we cannot request permissions.')));
//       return false;
//     }
//     return true;
//   }
//
//   Future<void> _getCurrentLocation() async {
//     final hasPermission = await _handleLocationPermission();
//     if (!hasPermission) return;
//
//     try {
//       _currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           _currentPosition!.latitude, _currentPosition!.longitude);
//       Placemark place = placemarks[0];
//       setState(() {
//         _currentAddress =
//         "${place.street}, ${place.locality}, ${place.postalCode}";
//       });
//     } catch (e) {
//       print("Error getting location: $e");
//       setState(() {
//         _currentAddress = "Could not fetch location.";
//       });
//     }
//   }
//
//
//   Future<void> _submitComplaint() async {
//     if (_formKey.currentState!.validate() && _imageFile != null && _currentPosition != null) {
//       setState(() {
//         _isSubmitting = true;
//       });
//
//       // CRITICAL: Get the local file path to save to MongoDB
//       final String localImagePath = _imageFile!.path;
//
//       try {
//         final bool success = await _apiService.submitComplaint(
//             title: _titleController.text,
//             description: _descriptionController.text,
//             location: _currentAddress ?? 'Location not available',
//             latitude: _currentPosition!.latitude,
//             longitude: _currentPosition!.longitude,
//             // CHANGED: Pass the local file path instead of the static URL
//             imageUrl: localImagePath); // 👈 NOW SAVING THE LOCAL PATH!
//
//         if (success && mounted) {  // 👈 Check for success
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Complaint submitted successfully!')),
//           );
//           Navigator.pop(context, true);
//         }
//         else if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Failed to submit complaint. Please try again.')),
//           );
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error submitting complaint: ${e.toString()}')),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isSubmitting = false;
//           });
//         }
//       }
//     } else if (_imageFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please take a photo to continue.')),
//       );
//     } else if (_currentPosition == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not get location. Please ensure location services are on.')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Report New Issue'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               GestureDetector(
//                 onTap: _takePicture,
//                 child: Container(
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade400),
//                   ),
//                   child: _imageFile != null
//                       ? ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.file(_imageFile!, fit: BoxFit.cover),
//                   )
//                       : const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.camera_alt,
//                           size: 50, color: Colors.grey),
//                       SizedBox(height: 8),
//                       Text('Tap to Take a Live Photo'),
//                     ],
//                   ),
//                 ),
//               ),
//               if (_currentAddress != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: Text(
//                     'Location: $_currentAddress',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.black54),
//                   ),
//                 ),
//               const SizedBox(height: 24),
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Complaint Title',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.title),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Complaint Description',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.description),
//                 ),
//                 maxLines: 4,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               _isSubmitting
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton.icon(
//                 onPressed: _submitComplaint,
//                 icon: const Icon(Icons.send),
//                 label: const Text('Submit Complaint'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   textStyle: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//

// import 'dart:io';
// // import 'dart:typed_data'; // Not needed with tflite_v2
// import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart' show rootBundle; // Not needed with tflite_v2
// import 'package:helpcivic/data/services/api_service.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
//
// // NEW TFLITE_V2 IMPORT
// import 'package:tflite_v2/tflite_v2.dart';
// // import 'package:image/image.dart' as img; // Not needed with tflite_v2
//
//
// class ReportIssueScreen extends StatefulWidget {
//   const ReportIssueScreen({super.key});
//
//   @override
//   State<ReportIssueScreen> createState() => _ReportIssueScreenState();
// }
//
// class _ReportIssueScreenState extends State<ReportIssueScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final ApiService _apiService = ApiService();
//
//   File? _imageFile;
//   String? _currentAddress;
//   Position? _currentPosition;
//   bool _isSubmitting = false;
//
//   // State variables re-configured for TFLite_V2
//   List? _outputs; // Used to hold the raw output from Tflite.runModelOnImage
//   bool _modelLoading = true;
//   String? _classifiedLabel; // To store the classification result
//
//   // --- MODEL CONSTANTS (tflite_v2 uses these for internal processing) ---
//   // Revert back to simpler mean/std values used by Tflite API
//   final double _imageMean = 127.5;
//   final double _imageStd = 127.5;
//   final int _numResults = 2; // Maximum number of results to return
//
//
//   @override
//   void initState() {
//     super.initState();
//     loadModel(); // Load the TFLite model when the screen initializes
//   }
//
//   // Model Loading Function (Updated for tflite_v2)
//   Future<void> loadModel() async {
//     try {
//       await Tflite.loadModel(
//         model: "assets/model_unquant.tflite", // Make sure this path is correct
//         labels: "assets/labels.txt", // Make sure this path is correct
//         numThreads: 1,
//       );
//       print("TFLite Model loaded successfully using tflite_v2.");
//     } catch (e) {
//       print("Error loading TFLite model with tflite_v2: $e");
//     } finally {
//       if(mounted) {
//         setState(() {
//           _modelLoading = false;
//         });
//       }
//     }
//   }
//
//   // Image Classification Function (Updated for tflite_v2)
//   Future<void> classifyImage(File image) async {
//     if (_modelLoading) return;
//
//     // Use Tflite.runModelOnImage which handles resizing and normalization internally
//     var output = await Tflite.runModelOnImage(
//       path: image.path,
//       imageMean: _imageMean, // Using values for your unquantized model
//       imageStd: _imageStd,   // Using values for your unquantized model
//       numResults: _numResults,
//       threshold: 0.2,
//       asynch: true,
//     );
//
//     if(mounted) {
//       setState(() {
//         _outputs = output;
//
//         // Get the label of the top result, which is at index 0
//         if (_outputs != null && _outputs!.isNotEmpty) {
//           // The output format is List<Map<String, dynamic>> where keys are 'label', 'confidence', etc.
//           _classifiedLabel = _outputs![0]["label"];
//         } else {
//           _classifiedLabel = "Unclassified Issue";
//         }
//
//         // Set the title controller with the classified label if it's the first time
//         if (_titleController.text.isEmpty && _classifiedLabel != null) {
//           _titleController.text = _classifiedLabel!;
//         }
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     Tflite.close(); // Use the static close method
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   // --- Helper Functions (takePicture, Location, Submit) remain the same ---
//
//   Future<void> _takePicture() async {
//     final picker = ImagePicker();
//     try {
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//       );
//
//       if (pickedFile != null) {
//         final image = File(pickedFile.path);
//         setState(() {
//           _imageFile = image;
//           _outputs = null; // Clear previous output
//           _classifiedLabel = null;
//         });
//
//         // CRITICAL: Classify the image after taking the picture
//         await classifyImage(image);
//
//         _getCurrentLocation();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to take picture: $e')),
//         );
//       }
//     }
//   }
//
//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Location services are disabled. Please enable them.')));
//       return false;
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions are denied.')));
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Location permissions are permanently denied, we cannot request permissions.')));
//       return false;
//     }
//     return true;
//   }
//
//   Future<void> _getCurrentLocation() async {
//     final hasPermission = await _handleLocationPermission();
//     if (!hasPermission) return;
//
//     try {
//       _currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           _currentPosition!.latitude, _currentPosition!.longitude);
//       Placemark place = placemarks[0];
//       setState(() {
//         _currentAddress =
//         "${place.street}, ${place.locality}, ${place.postalCode}";
//       });
//     } catch (e) {
//       print("Error getting location: $e");
//       setState(() {
//         _currentAddress = "Could not fetch location.";
//       });
//     }
//   }
//
//
//   Future<void> _submitComplaint() async {
//     // Ensure all data is ready, including the classified label
//     if (_formKey.currentState!.validate() &&
//         _imageFile != null &&
//         _currentPosition != null &&
//         _classifiedLabel != null &&
//         _classifiedLabel != "Unclassified Issue") { // Adjusted condition
//
//       setState(() {
//         _isSubmitting = true;
//       });
//
//       final String localImagePath = _imageFile!.path;
//       // Include the classification in the description
//       final String descriptionWithClassification =
//           '**Classified as: $_classifiedLabel**\n\n' + _descriptionController.text;
//
//       try {
//         final bool success = await _apiService.submitComplaint(
//             title: _titleController.text,
//             // Use the combined description
//             description: descriptionWithClassification,
//             location: _currentAddress ?? 'Location not available',
//             latitude: _currentPosition!.latitude,
//             longitude: _currentPosition!.longitude,
//             imageUrl: localImagePath);
//
//         if (success && mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Complaint submitted successfully!')),
//           );
//           Navigator.pop(context, true);
//         }
//         else if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Failed to submit complaint. Please try again.')),
//           );
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error submitting complaint: ${e.toString()}')),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isSubmitting = false;
//           });
//         }
//       }
//     } else if (_imageFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please take a photo to continue.')),
//       );
//     } else if (_currentPosition == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not get location. Please ensure location services are on.')),
//       );
//     } else if (_classifiedLabel == null || _classifiedLabel == "Unclassified Issue") {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Image classification is still processing or returned no confident result. Please wait or check photo quality.')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Report New Issue'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // --- Image Picker Area ---
//               GestureDetector(
//                 onTap: _takePicture,
//                 child: Container(
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade400),
//                   ),
//                   child: _imageFile != null
//                       ? ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.file(_imageFile!, fit: BoxFit.cover),
//                   )
//                       : const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.camera_alt,
//                           size: 50, color: Colors.grey),
//                       SizedBox(height: 8),
//                       Text('Tap to Take a Live Photo'),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // --- Classification Result Display ---
//               if (_classifiedLabel != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: Text(
//                     'AI Classification: $_classifiedLabel',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         // Change color based on classification status
//                         color: _classifiedLabel == "Unclassified Issue" ? Colors.red : Colors.green,
//                         fontSize: 16),
//                   ),
//                 )
//               else if (_imageFile != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: Text(
//                     _modelLoading ? 'Loading Model...' : 'Classifying Image...',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
//                   ),
//                 ),
//
//               // --- Location Display ---
//               if (_currentAddress != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: Text(
//                     'Location: $_currentAddress',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.black54),
//                   ),
//                 ),
//
//               const SizedBox(height: 24),
//               // --- Title Field (can be pre-filled by classification) ---
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                   labelText: _classifiedLabel != null ? 'Complaint Title (AI Suggestion)' : 'Complaint Title',
//                   border: const OutlineInputBorder(),
//                   prefixIcon: const Icon(Icons.title),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               // --- Description Field ---
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Complaint Description',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.description),
//                 ),
//                 maxLines: 4,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               // --- Submission Button ---
//               _isSubmitting || _modelLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton.icon(
//                 onPressed: _submitComplaint,
//                 icon: const Icon(Icons.send),
//                 label: const Text('Submit Complaint'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   textStyle: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// working one upar bala

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:helpcivic/data/services/api_service.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
//
// // NEW TFLITE_V2 IMPORT
// import 'package:tflite_v2/tflite_v2.dart';
//
//
// class ReportIssueScreen extends StatefulWidget {
//   const ReportIssueScreen({super.key});
//
//   @override
//   State<ReportIssueScreen> createState() => _ReportIssueScreenState();
// }
//
// class _ReportIssueScreenState extends State<ReportIssueScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final ApiService _apiService = ApiService();
//
//   File? _imageFile;
//   String? _currentAddress;
//   Position? _currentPosition;
//   bool _isSubmitting = false;
//
//   // State variables re-configured for TFLite_V2
//   List? _outputs; // Used to hold the raw output from Tflite.runModelOnImage
//   bool _modelLoading = true;
//   String? _classifiedLabel; // To store the classification result
//
//   // --- 🚩 FIX: TFLITE INTERPRETER BUSY FLAG ---
//   bool _isTfliteBusy = false;
//   // ---------------------------------------------
//
//   // --- MODEL CONSTANTS (tflite_v2 uses these for internal processing) ---
//   final double _imageMean = 0.0;
//   final double _imageStd = 255.0;
//   final int _numResults = 2; // Maximum number of results to return
//
//
//   @override
//   void initState() {
//     super.initState();
//     loadModel(); // Load the TFLite model when the screen initializes
//   }
//
//   // Model Loading Function (Updated for tflite_v2)
//   Future<void> loadModel() async {
//     try {
//       await Tflite.loadModel(
//         model: "assets/ml/urban_issues_model.tflite", // Make sure this path is correct
//         labels: "assets/ml/labels.txt", // Make sure this path is correct
//         numThreads: 1,
//       );
//       print("TFLite Model loaded successfully using tflite_v2.");
//     } catch (e) {
//       print("Error loading TFLite model with tflite_v2: $e");
//     } finally {
//       if(mounted) {
//         setState(() {
//           _modelLoading = false;
//         });
//       }
//     }
//   }
//
//   // Image Classification Function (UPDATED with Busy Check)
//   Future<void> classifyImage(File image) async {
//     if (_modelLoading) return;
//
//     // --- 🚩 FIX: BUSY CHECK ---
//     if (_isTfliteBusy) {
//       print("TFLite Interpreter is busy. Skipping inference.");
//       return;
//     }
//     _isTfliteBusy = true; // Set the flag to true
//     // -------------------------
//
//     // Optional: Update UI to show 'Classifying...' while processing
//     if(mounted) {
//       setState(() {
//         _classifiedLabel = "Classifying...";
//       });
//     }
//
//     try {
//       // Use Tflite.runModelOnImage which handles resizing and normalization internally
//       var output = await Tflite.runModelOnImage(
//         path: image.path,
//         imageMean: _imageMean, // Using values for your unquantized model
//         imageStd: _imageStd,   // Using values for your unquantized model
//         numResults: _numResults,
//         threshold: 0.2,
//         asynch: true,
//       );
//
//       if(mounted) {
//         setState(() {
//           _outputs = output;
//           String? resultLabel;
//
//           // Get the label of the top result, which is at index 0
//           if (_outputs != null && _outputs!.isNotEmpty) {
//             // The output format is List<Map<String, dynamic>> where keys are 'label', 'confidence', etc.
//             resultLabel = _outputs![0]["label"];
//           } else {
//             resultLabel = "Unclassified Issue";
//           }
//
//           _classifiedLabel = resultLabel;
//
//           // Set the title controller with the classified label if it's the first time
//           if (_titleController.text.isEmpty && resultLabel != null) {
//             _titleController.text = resultLabel;
//           }
//         });
//       }
//     } catch (e) {
//       print("Error during image classification: $e");
//       if(mounted) {
//         setState(() {
//           _classifiedLabel = "Classification Failed";
//         });
//       }
//     } finally {
//       // --- 🚩 FIX: RESET BUSY FLAG ---
//       _isTfliteBusy = false;
//       // --------------------------------
//     }
//   }
//
//   @override
//   void dispose() {
//     Tflite.close(); // Use the static close method
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   // --- Helper Functions (takePicture, Location, Submit) remain the same ---
//
//   Future<void> _takePicture() async {
//     final picker = ImagePicker();
//     try {
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//       );
//
//       if (pickedFile != null) {
//         final image = File(pickedFile.path);
//         setState(() {
//           _imageFile = image;
//           _outputs = null; // Clear previous output
//           _classifiedLabel = null; // Clear previous label
//         });
//
//         // CRITICAL: Classify the image after taking the picture
//         await classifyImage(image);
//
//         _getCurrentLocation();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to take picture: $e')),
//         );
//       }
//     }
//   }
//
//   // ... (Rest of _handleLocationPermission, _getCurrentLocation, and _submitComplaint remains the same) ...
//
//   Future<bool> _handleLocationPermission() async {
//     // ... (Your implementation) ...
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Location services are disabled. Please enable them.')));
//       return false;
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions are denied.')));
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Location permissions are permanently denied, we cannot request permissions.')));
//       return false;
//     }
//     return true;
//   }
//
//   Future<void> _getCurrentLocation() async {
//     final hasPermission = await _handleLocationPermission();
//     if (!hasPermission) return;
//
//     try {
//       _currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           _currentPosition!.latitude, _currentPosition!.longitude);
//       Placemark place = placemarks[0];
//       setState(() {
//         _currentAddress =
//         "${place.street}, ${place.locality}, ${place.postalCode}";
//       });
//     } catch (e) {
//       print("Error getting location: $e");
//       setState(() {
//         _currentAddress = "Could not fetch location.";
//       });
//     }
//   }
//
//
//   Future<void> _submitComplaint() async {
//     // Ensure all data is ready, including the classified label
//     if (_formKey.currentState!.validate() &&
//         _imageFile != null &&
//         _currentPosition != null &&
//         _classifiedLabel != null &&
//         _classifiedLabel != "Unclassified Issue") { // Adjusted condition
//
//       setState(() {
//         _isSubmitting = true;
//       });
//
//       final String localImagePath = _imageFile!.path;
//       // Include the classification in the description
//       final String descriptionWithClassification =
//           '**Classified as: $_classifiedLabel**\n\n' + _descriptionController.text;
//
//       try {
//         final bool success = await _apiService.submitComplaint(
//             title: _titleController.text,
//             // Use the combined description
//             description: descriptionWithClassification,
//             location: _currentAddress ?? 'Location not available',
//             latitude: _currentPosition!.latitude,
//             longitude: _currentPosition!.longitude,
//             imageUrl: localImagePath);
//
//         if (success && mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Complaint submitted successfully!')),
//           );
//           Navigator.pop(context, true);
//         }
//         else if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Failed to submit complaint. Please try again.')),
//           );
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error submitting complaint: ${e.toString()}')),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isSubmitting = false;
//           });
//         }
//       }
//     } else if (_imageFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please take a photo to continue.')),
//       );
//     } else if (_currentPosition == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not get location. Please ensure location services are on.')),
//       );
//     } else if (_classifiedLabel == null || _classifiedLabel == "Unclassified Issue" || _classifiedLabel == "Classifying...") {
//       // Added "Classifying..." to the check for better UX
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Image classification is still processing or returned no confident result. Please wait or check photo quality.')),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Report New Issue'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // --- Image Picker Area ---
//               GestureDetector(
//                 onTap: _takePicture,
//                 child: Container(
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade400),
//                   ),
//                   child: _imageFile != null
//                       ? ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.file(_imageFile!, fit: BoxFit.cover),
//                   )
//                       : const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.camera_alt,
//                           size: 50, color: Colors.grey),
//                       SizedBox(height: 8),
//                       Text('Tap to Take a Live Photo'),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // --- Classification Result Display (UPDATED for 'busy' state) ---
//               if (_classifiedLabel != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: Text(
//                     // Display the processing message if busy
//                     _classifiedLabel == "Classifying..." ? 'AI Classification: Classifying Image...' : 'AI Classification: $_classifiedLabel',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         // Change color based on classification status or busy state
//                         color: _classifiedLabel == "Unclassified Issue" || _classifiedLabel == "Classification Failed" ? Colors.red : (_classifiedLabel == "Classifying..." ? Colors.orange : Colors.green),
//                         fontSize: 16),
//                   ),
//                 )
//               else if (_imageFile != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: Text(
//                     _modelLoading ? 'Loading Model...' : 'Awaiting Classification...',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
//                   ),
//                 ),
//
//               // --- Location Display ---
//               if (_currentAddress != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: Text(
//                     'Location: $_currentAddress',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.black54),
//                   ),
//                 ),
//
//               const SizedBox(height: 24),
//               // --- Title Field (can be pre-filled by classification) ---
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                   labelText: _classifiedLabel != null ? 'Complaint Title (AI Suggestion)' : 'Complaint Title',
//                   border: const OutlineInputBorder(),
//                   prefixIcon: const Icon(Icons.title),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               // --- Description Field ---
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Complaint Description',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.description),
//                 ),
//                 maxLines: 4,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               // --- Submission Button ---
//               _isSubmitting || _modelLoading || _isTfliteBusy
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton.icon(
//                 onPressed: _submitComplaint,
//                 icon: const Icon(Icons.send),
//                 label: const Text('Submit Complaint'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   textStyle: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// upper one working with ml

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:helpcivic/data/services/api_service.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
//
// // NEW TFLITE_V2 IMPORT
// import 'package:tflite_v2/tflite_v2.dart';
//
//
// class ReportIssueScreen extends StatefulWidget {
//   const ReportIssueScreen({super.key});
//
//   @override
//   State<ReportIssueScreen> createState() => _ReportIssueScreenState();
// }
//
// class _ReportIssueScreenState extends State<ReportIssueScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final ApiService _apiService = ApiService();
//
//   File? _imageFile;
//   String? _currentAddress;
//   Position? _currentPosition;
//   bool _isSubmitting = false;
//
//   // --- 🚩 NEW: Geographical Context Variables ---
//   String? _municipalityName; // City/Locality
//   String? _administrativeArea; // State/Province
//   String? _country;
//   // ---------------------------------------------
//
//   // State variables re-configured for TFLite_V2
//   List? _outputs;
//   bool _modelLoading = true;
//   String? _classifiedLabel;
//
//   // --- 🚩 FIX: TFLITE INTERPRETER BUSY FLAG ---
//   bool _isTfliteBusy = false;
//   // ---------------------------------------------
//
//   final double _imageMean = 0.0;
//   final double _imageStd = 255.0;
//   final int _numResults = 2;
//
//
//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//   }
//
//   // Model Loading Function
//   Future<void> loadModel() async {
//     try {
//       await Tflite.loadModel(
//         model: "assets/ml/urban_issues_model.tflite",
//         labels: "assets/ml/labels.txt",
//         numThreads: 1,
//       );
//       print("TFLite Model loaded successfully using tflite_v2.");
//     } catch (e) {
//       print("Error loading TFLite model with tflite_v2: $e");
//     } finally {
//       if(mounted) {
//         setState(() {
//           _modelLoading = false;
//         });
//       }
//     }
//   }
//
//   // Image Classification Function
//   Future<void> classifyImage(File image) async {
//     if (_modelLoading) return;
//     if (_isTfliteBusy) {
//       print("TFLite Interpreter is busy. Skipping inference.");
//       return;
//     }
//     _isTfliteBusy = true;
//
//     if(mounted) {
//       setState(() {
//         _classifiedLabel = "Classifying...";
//       });
//     }
//
//     try {
//       var output = await Tflite.runModelOnImage(
//         path: image.path,
//         imageMean: _imageMean,
//         imageStd: _imageStd,
//         numResults: _numResults,
//         threshold: 0.2,
//         asynch: true,
//       );
//
//       if(mounted) {
//         setState(() {
//           _outputs = output;
//           String? resultLabel;
//
//           if (_outputs != null && _outputs!.isNotEmpty) {
//             resultLabel = _outputs![0]["label"];
//           } else {
//             resultLabel = "Unclassified Issue";
//           }
//
//           _classifiedLabel = resultLabel;
//
//           if (_titleController.text.isEmpty && resultLabel != null) {
//             _titleController.text = resultLabel;
//           }
//         });
//       }
//     } catch (e) {
//       print("Error during image classification: $e");
//       if(mounted) {
//         setState(() {
//           _classifiedLabel = "Classification Failed";
//         });
//       }
//     } finally {
//       _isTfliteBusy = false;
//     }
//   }
//
//   @override
//   void dispose() {
//     Tflite.close();
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _takePicture() async {
//     final picker = ImagePicker();
//     try {
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//       );
//
//       if (pickedFile != null) {
//         final image = File(pickedFile.path);
//         setState(() {
//           _imageFile = image;
//           _outputs = null;
//           _classifiedLabel = null;
//         });
//
//         await classifyImage(image);
//         _getCurrentLocation();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to take picture: $e')),
//         );
//       }
//     }
//   }
//
//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Location services are disabled. Please enable them.')));
//       return false;
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions are denied.')));
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Location permissions are permanently denied, we cannot request permissions.')));
//       return false;
//     }
//     return true;
//   }
//
//   // --- 🚩 UPDATED: Extract Municipality/State/Country from Placemark ---
//   Future<void> _getCurrentLocation() async {
//     final hasPermission = await _handleLocationPermission();
//     if (!hasPermission) return;
//
//     try {
//       _currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           _currentPosition!.latitude, _currentPosition!.longitude);
//       Placemark place = placemarks[0];
//
//       setState(() {
//         // Full Address
//         _currentAddress =
//         "${place.street}, ${place.locality}, ${place.postalCode}";
//
//         // Geographical Context
//         _municipalityName = place.locality; // City name (e.g., Gwalior)
//         _administrativeArea = place.administrativeArea; // State/Province (e.g., Madhya Pradesh)
//         _country = place.country;
//       });
//       print("Municipality detected: $_municipalityName");
//     } catch (e) {
//       print("Error getting location: $e");
//       setState(() {
//         _currentAddress = "Could not fetch location.";
//         _municipalityName = null;
//         _administrativeArea = null;
//         _country = null;
//       });
//     }
//   }
//   // ------------------------------------------------------------------------
//
//   // --- 🚩 UPDATED: Pass Municipality/State/Country to ApiService ---
//   Future<void> _submitComplaint() async {
//     // Check that necessary geographical data is also present
//     if (_formKey.currentState!.validate() &&
//         _imageFile != null &&
//         _currentPosition != null &&
//         _classifiedLabel != null &&
//         _classifiedLabel != "Unclassified Issue" &&
//         _municipalityName != null &&
//         _administrativeArea != null &&
//         _country != null) {
//
//       setState(() {
//         _isSubmitting = true;
//       });
//
//       final String localImagePath = _imageFile!.path;
//       final String descriptionWithClassification =
//           '**Classified as: $_classifiedLabel**\n\n' + _descriptionController.text;
//
//       try {
//         final bool success = await _apiService.submitComplaint(
//           title: _titleController.text,
//           description: descriptionWithClassification,
//           location: _currentAddress ?? 'Location not available',
//           latitude: _currentPosition!.latitude,
//           longitude: _currentPosition!.longitude,
//           imageUrl: localImagePath,
//           // Pass all required geographical context
//           municipalityName: _municipalityName!,
//           administrativeArea: _administrativeArea!,
//           country: _country!,
//         );
//
//         if (success && mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Complaint submitted successfully!')),
//           );
//           Navigator.pop(context, true);
//         }
//         else if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Failed to submit complaint. Please try again.')),
//           );
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error submitting complaint: ${e.toString()}')),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isSubmitting = false;
//           });
//         }
//       }
//     } else if (_imageFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please take a photo to continue.')),
//       );
//     } else if (_currentPosition == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not get location. Please ensure location services are on.')),
//       );
//     } else if (_classifiedLabel == null || _classifiedLabel == "Unclassified Issue" || _classifiedLabel == "Classifying...") {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Image classification is still processing or returned no confident result. Please wait or check photo quality.')),
//       );
//     } else if (_municipalityName == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not determine city/municipality for routing.')),
//       );
//     }
//   }
//   // ------------------------------------------------------------------------
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Report New Issue'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // --- Image Picker Area ---
//               GestureDetector(
//                 onTap: _takePicture,
//                 child: Container(
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade400),
//                   ),
//                   child: _imageFile != null
//                       ? ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.file(_imageFile!, fit: BoxFit.cover),
//                   )
//                       : const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.camera_alt,
//                           size: 50, color: Colors.grey),
//                       SizedBox(height: 8),
//                       Text('Tap to Take a Live Photo'),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // --- Classification Result Display ---
//               if (_classifiedLabel != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: Text(
//                     _classifiedLabel == "Classifying..." ? 'AI Classification: Classifying Image...' : 'AI Classification: $_classifiedLabel',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: _classifiedLabel == "Unclassified Issue" || _classifiedLabel == "Classification Failed" ? Colors.red : (_classifiedLabel == "Classifying..." ? Colors.orange : Colors.green),
//                         fontSize: 16),
//                   ),
//                 )
//               else if (_imageFile != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: Text(
//                     _modelLoading ? 'Loading Model...' : 'Awaiting Classification...',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
//                   ),
//                 ),
//
//               // --- Location Display ---
//               if (_currentAddress != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: Column(
//                     children: [
//                       Text(
//                         'Location: $_currentAddress',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, color: Colors.black54),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Routing to: ${_municipalityName ?? 'Unknown'}, ${_administrativeArea ?? 'Unknown'}',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, color: Colors.indigo),
//                       ),
//                     ],
//                   ),
//                 ),
//
//               const SizedBox(height: 24),
//               // --- Title Field (can be pre-filled by classification) ---
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                   labelText: _classifiedLabel != null ? 'Complaint Title (AI Suggestion)' : 'Complaint Title',
//                   border: const OutlineInputBorder(),
//                   prefixIcon: const Icon(Icons.title),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               // --- Description Field ---
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Complaint Description',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.description),
//                 ),
//                 maxLines: 4,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               // --- Submission Button ---
//               _isSubmitting || _modelLoading || _isTfliteBusy
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton.icon(
//                 onPressed: _submitComplaint,
//                 icon: const Icon(Icons.send),
//                 label: const Text('Submit Complaint'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   textStyle: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:helpcivic/data/services/api_service.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
//
// // NEW TFLITE_V2 IMPORT
// import 'package:tflite_v2/tflite_v2.dart';
//
//
// class ReportIssueScreen extends StatefulWidget {
//   const ReportIssueScreen({super.key});
//
//   @override
//   State<ReportIssueScreen> createState() => _ReportIssueScreenState();
// }
//
// class _ReportIssueScreenState extends State<ReportIssueScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final ApiService _apiService = ApiService();
//
//   File? _imageFile;
//   String? _currentAddress;
//   Position? _currentPosition;
//   bool _isSubmitting = false;
//
//   // State variables re-configured for TFLite_V2
//   List? _outputs; // Used to hold the raw output from Tflite.runModelOnImage
//   bool _modelLoading = true;
//   String? _classifiedLabel; // To store the classification result
//
//   // --- 🚩 FIX: TFLITE INTERPRETER BUSY FLAG ---
//   bool _isTfliteBusy = false;
//   // ---------------------------------------------
//
//   // --- MODEL CONSTANTS (tflite_v2 uses these for internal processing) ---
//   final double _imageMean = 0.0;
//   final double _imageStd = 255.0;
//   final int _numResults = 2; // Maximum number of results to return
//
//
//   @override
//   void initState() {
//     super.initState();
//     loadModel(); // Load the TFLite model when the screen initializes
//   }
//
//   // Model Loading Function (Updated for tflite_v2)
//   Future<void> loadModel() async {
//     try {
//       await Tflite.loadModel(
//         model: "assets/ml/urban_issues_model.tflite", // Make sure this path is correct
//         labels: "assets/ml/labels.txt", // Make sure this path is correct
//         numThreads: 1,
//       );
//       print("TFLite Model loaded successfully using tflite_v2.");
//     } catch (e) {
//       print("Error loading TFLite model with tflite_v2: $e");
//     } finally {
//       if(mounted) {
//         setState(() {
//           _modelLoading = false;
//         });
//       }
//     }
//   }
//
//   // Image Classification Function (UPDATED with Busy Check)
//   Future<void> classifyImage(File image) async {
//     if (_modelLoading) return;
//
//     // --- 🚩 FIX: BUSY CHECK ---
//     if (_isTfliteBusy) {
//       print("TFLite Interpreter is busy. Skipping inference.");
//       return;
//     }
//     _isTfliteBusy = true; // Set the flag to true
//     // -------------------------
//
//     // Optional: Update UI to show 'Classifying...' while processing
//     if(mounted) {
//       setState(() {
//         _classifiedLabel = "Classifying...";
//       });
//     }
//
//     try {
//       // Use Tflite.runModelOnImage which handles resizing and normalization internally
//       var output = await Tflite.runModelOnImage(
//         path: image.path,
//         imageMean: _imageMean, // Using values for your unquantized model
//         imageStd: _imageStd,   // Using values for your unquantized model
//         numResults: _numResults,
//         threshold: 0.2,
//         asynch: true,
//       );
//
//       if(mounted) {
//         setState(() {
//           _outputs = output;
//           String? resultLabel;
//
//           // Get the label of the top result, which is at index 0
//           if (_outputs != null && _outputs!.isNotEmpty) {
//             // The output format is List<Map<String, dynamic>> where keys are 'label', 'confidence', etc.
//             resultLabel = _outputs![0]["label"];
//           } else {
//             resultLabel = "Unclassified Issue";
//           }
//
//           _classifiedLabel = resultLabel;
//
//           // Set the title controller with the classified label if it's the first time
//           if (_titleController.text.isEmpty && resultLabel != null) {
//             _titleController.text = resultLabel;
//           }
//         });
//       }
//     } catch (e) {
//       print("Error during image classification: $e");
//       if(mounted) {
//         setState(() {
//           _classifiedLabel = "Classification Failed";
//         });
//       }
//     } finally {
//       // --- 🚩 FIX: RESET BUSY FLAG ---
//       _isTfliteBusy = false;
//       // --------------------------------
//     }
//   }
//
//   @override
//   void dispose() {
//     Tflite.close(); // Use the static close method
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   // --- Helper Functions (takePicture, Location, Submit) remain the same ---
//
//   Future<void> _takePicture() async {
//     final picker = ImagePicker();
//     try {
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//       );
//
//       if (pickedFile != null) {
//         final image = File(pickedFile.path);
//         setState(() {
//           _imageFile = image;
//           _outputs = null; // Clear previous output
//           _classifiedLabel = null; // Clear previous label
//         });
//
//         // CRITICAL: Classify the image after taking the picture
//         await classifyImage(image);
//
//         _getCurrentLocation();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to take picture: $e')),
//         );
//       }
//     }
//   }
//
//   // ... (Rest of _handleLocationPermission, _getCurrentLocation, and _submitComplaint remains the same) ...
//
//   Future<bool> _handleLocationPermission() async {
//     // ... (Your implementation) ...
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Location services are disabled. Please enable them.')));
//       return false;
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions are denied.')));
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Location permissions are permanently denied, we cannot request permissions.')));
//       return false;
//     }
//     return true;
//   }
//
//   Future<void> _getCurrentLocation() async {
//     final hasPermission = await _handleLocationPermission();
//     if (!hasPermission) return;
//
//     try {
//       _currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           _currentPosition!.latitude, _currentPosition!.longitude);
//       Placemark place = placemarks[0];
//       setState(() {
//         _currentAddress =
//         "${place.street}, ${place.locality}, ${place.postalCode}";
//       });
//     } catch (e) {
//       print("Error getting location: $e");
//       setState(() {
//         _currentAddress = "Could not fetch location.";
//       });
//     }
//   }
//
//
//   Future<void> _submitComplaint() async {
//     // Ensure all data is ready, including the classified label
//     if (_formKey.currentState!.validate() &&
//         _imageFile != null &&
//         _currentPosition != null &&
//         _classifiedLabel != null &&
//         _classifiedLabel != "Unclassified Issue") { // Adjusted condition
//
//       setState(() {
//         _isSubmitting = true;
//       });
//
//       final String localImagePath = _imageFile!.path;
//       // Include the classification in the description
//       final String descriptionWithClassification =
//           '**Classified as: $_classifiedLabel**\n\n' + _descriptionController.text;
//
//       try {
//         final bool success = await _apiService.submitComplaint(
//             title: _titleController.text,
//             // Use the combined description
//             description: descriptionWithClassification,
//             location: _currentAddress ?? 'Location not available',
//             latitude: _currentPosition!.latitude,
//             longitude: _currentPosition!.longitude,
//             imageUrl: localImagePath);
//
//         if (success && mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Complaint submitted successfully!')),
//           );
//           Navigator.pop(context, true);
//         }
//         else if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Failed to submit complaint. Please try again.')),
//           );
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error submitting complaint: ${e.toString()}')),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isSubmitting = false;
//           });
//         }
//       }
//     } else if (_imageFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please take a photo to continue.')),
//       );
//     } else if (_currentPosition == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not get location. Please ensure location services are on.')),
//       );
//     } else if (_classifiedLabel == null || _classifiedLabel == "Unclassified Issue" || _classifiedLabel == "Classifying...") {
//       // Added "Classifying..." to the check for better UX
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Image classification is still processing or returned no confident result. Please wait or check photo quality.')),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Report New Issue'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // --- Image Picker Area ---
//               GestureDetector(
//                 onTap: _takePicture,
//                 child: Container(
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade400),
//                   ),
//                   child: _imageFile != null
//                       ? ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.file(_imageFile!, fit: BoxFit.cover),
//                   )
//                       : const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.camera_alt,
//                           size: 50, color: Colors.grey),
//                       SizedBox(height: 8),
//                       Text('Tap to Take a Live Photo'),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // --- Classification Result Display (UPDATED for 'busy' state) ---
//               if (_classifiedLabel != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: Text(
//                     // Display the processing message if busy
//                     _classifiedLabel == "Classifying..." ? 'AI Classification: Classifying Image...' : 'AI Classification: $_classifiedLabel',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         // Change color based on classification status or busy state
//                         color: _classifiedLabel == "Unclassified Issue" || _classifiedLabel == "Classification Failed" ? Colors.red : (_classifiedLabel == "Classifying..." ? Colors.orange : Colors.green),
//                         fontSize: 16),
//                   ),
//                 )
//               else if (_imageFile != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: Text(
//                     _modelLoading ? 'Loading Model...' : 'Awaiting Classification...',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
//                   ),
//                 ),
//
//               // --- Location Display ---
//               if (_currentAddress != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: Text(
//                     'Location: $_currentAddress',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.black54),
//                   ),
//                 ),
//
//               const SizedBox(height: 24),
//               // --- Title Field (can be pre-filled by classification) ---
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                   labelText: _classifiedLabel != null ? 'Complaint Title (AI Suggestion)' : 'Complaint Title',
//                   border: const OutlineInputBorder(),
//                   prefixIcon: const Icon(Icons.title),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               // --- Description Field ---
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Complaint Description',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.description),
//                 ),
//                 maxLines: 4,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               // --- Submission Button ---
//               _isSubmitting || _modelLoading || _isTfliteBusy
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton.icon(
//                 onPressed: _submitComplaint,
//                 icon: const Icon(Icons.send),
//                 label: const Text('Submit Complaint'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   textStyle: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// workinggg

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:helpcivic/data/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// NEW TFLITE_V2 IMPORT
import 'package:tflite_v2/tflite_v2.dart';


class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ApiService _apiService = ApiService();

  File? _imageFile;
  String? _currentAddress;
  Position? _currentPosition;
  bool _isSubmitting = false;

  // State variables re-configured for TFLite_V2
  List? _outputs; // Used to hold the raw output from Tflite.runModelOnImage
  bool _modelLoading = true;
  String? _classifiedLabel; // To store the classification result

  // --- 🚩 FIX: TFLITE INTERPRETER BUSY FLAG ---
  bool _isTfliteBusy = false;
  // ---------------------------------------------

  // 👇 NEW: State variables for structured location data
  String _municipalityName = 'Unknown';
  String _stateName = 'Unknown';
  String _countryName = 'Unknown';
  // ----------------------------------------------------

  // --- MODEL CONSTANTS (tflite_v2 uses these for internal processing) ---
  final double _imageMean = 0.0;
  final double _imageStd = 255.0;
  final int _numResults = 2; // Maximum number of results to return


  @override
  void initState() {
    super.initState();
    loadModel(); // Load the TFLite model when the screen initializes
  }

  // Model Loading Function (Updated for tflite_v2)
  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/ml/urban_issues_model.tflite", // Make sure this path is correct
        labels: "assets/ml/labels.txt", // Make sure this path is correct
        numThreads: 1,
      );
      print("TFLite Model loaded successfully using tflite_v2.");
    } catch (e) {
      print("Error loading TFLite model with tflite_v2: $e");
    } finally {
      if(mounted) {
        setState(() {
          _modelLoading = false;
        });
      }
    }
  }

  // Image Classification Function (UPDATED with Busy Check)
  Future<void> classifyImage(File image) async {
    if (_modelLoading) return;

    // --- 🚩 FIX: BUSY CHECK ---
    if (_isTfliteBusy) {
      print("TFLite Interpreter is busy. Skipping inference.");
      return;
    }
    _isTfliteBusy = true; // Set the flag to true
    // -------------------------

    // Optional: Update UI to show 'Classifying...' while processing
    if(mounted) {
      setState(() {
        _classifiedLabel = "Classifying...";
      });
    }

    try {
      // Use Tflite.runModelOnImage which handles resizing and normalization internally
      var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: _imageMean, // Using values for your unquantized model
        imageStd: _imageStd,   // Using values for your unquantized model
        numResults: _numResults,
        threshold: 0.2,
        asynch: true,
      );

      if(mounted) {
        setState(() {
          _outputs = output;
          String? resultLabel;

          // Get the label of the top result, which is at index 0
          if (_outputs != null && _outputs!.isNotEmpty) {
            // The output format is List<Map<String, dynamic>> where keys are 'label', 'confidence', etc.
            resultLabel = _outputs![0]["label"];
          } else {
            resultLabel = "Unclassified Issue";
          }

          _classifiedLabel = resultLabel;

          // Set the title controller with the classified label if it's the first time
          if (_titleController.text.isEmpty && resultLabel != null) {
            _titleController.text = resultLabel;
          }
        });
      }
    } catch (e) {
      print("Error during image classification: $e");
      if(mounted) {
        setState(() {
          _classifiedLabel = "Classification Failed";
        });
      }
    } finally {
      // --- 🚩 FIX: RESET BUSY FLAG ---
      _isTfliteBusy = false;
      // --------------------------------
    }
  }

  @override
  void dispose() {
    Tflite.close(); // Use the static close method
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- Helper Functions (takePicture, Location, Submit) remain the same ---

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final image = File(pickedFile.path);
        setState(() {
          _imageFile = image;
          _outputs = null; // Clear previous output
          _classifiedLabel = null; // Clear previous label
        });

        // CRITICAL: Classify the image after taking the picture
        await classifyImage(image);

        _getCurrentLocation();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to take picture: $e')),
        );
      }
    }
  }

  Future<bool> _handleLocationPermission() async {
    // ... (Your implementation) ...
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable them.')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied.')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  // 👇 UPDATED: Extract and store structured location data
  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
        "${place.street}, ${place.locality}, ${place.postalCode}";

        // Extract and store structured location data
        _municipalityName = place.locality ?? place.subAdministrativeArea ?? 'Unknown';
        _stateName = place.administrativeArea ?? 'Unknown';
        _countryName = place.country ?? 'Unknown';

        print('Location Data Extracted: Municipality: $_municipalityName, State: $_stateName');
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        _currentAddress = "Could not fetch location.";
        // Reset structured data on failure
        _municipalityName = 'Unknown';
        _stateName = 'Unknown';
        _countryName = 'Unknown';
      });
    }
  }


  Future<void> _submitComplaint() async {
    // Ensure all data is ready, including the classified label
    if (_formKey.currentState!.validate() &&
        _imageFile != null &&
        _currentPosition != null &&
        _classifiedLabel != null &&
        _classifiedLabel != "Unclassified Issue" &&
        _classifiedLabel != "Classifying...") { // Adjusted condition

      setState(() {
        _isSubmitting = true;
      });

      final String localImagePath = _imageFile!.path;
      // Include the classification in the description
      final String descriptionWithClassification =
          '**Classified as: $_classifiedLabel**\n\n' + _descriptionController.text;

      try {
        // 👇 CRITICAL: Pass all required arguments to ApiService
        final bool success = await _apiService.submitComplaint(
          title: _titleController.text,
          // Use the combined description
          description: descriptionWithClassification,
          location: _currentAddress ?? 'Location not available',
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
          imageUrl: localImagePath,
          // Pass the classified label as the 'type'
          type: _classifiedLabel!,
          // Pass the extracted geographical data for routing
          municipalityName: _municipalityName,
          stateName: _stateName,
          countryName: _countryName,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Complaint submitted successfully!')),
          );
          Navigator.pop(context, true);
        }
        else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit complaint. Please try again.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting complaint: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    } else if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please take a photo to continue.')),
      );
    } else if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not get location. Please ensure location services are on.')),
      );
    } else if (_classifiedLabel == null || _classifiedLabel == "Unclassified Issue" || _classifiedLabel == "Classifying...") {
      // Added "Classifying..." to the check for better UX
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image classification is still processing or returned no confident result. Please wait or check photo quality.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report New Issue'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Image Picker Area ---
              GestureDetector(
                onTap: _takePicture,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                  )
                      : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt,
                          size: 50, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Tap to Take a Live Photo'),
                    ],
                  ),
                ),
              ),

              // --- Classification Result Display (UPDATED for 'busy' state) ---
              if (_classifiedLabel != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    // Display the processing message if busy
                    _classifiedLabel == "Classifying..." ? 'AI Classification: Classifying Image...' : 'AI Classification: $_classifiedLabel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // Change color based on classification status or busy state
                        color: _classifiedLabel == "Unclassified Issue" || _classifiedLabel == "Classification Failed" ? Colors.red : (_classifiedLabel == "Classifying..." ? Colors.orange : Colors.green),
                        fontSize: 16),
                  ),
                )
              else if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    _modelLoading ? 'Loading Model...' : 'Awaiting Classification...',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
                  ),
                ),

              // --- Location Display (Updated to show structured data) ---
              if (_currentAddress != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Location: $_currentAddress\n(${_municipalityName}, $_stateName, $_countryName)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),

              const SizedBox(height: 24),
              // --- Title Field (can be pre-filled by classification) ---
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: _classifiedLabel != null ? 'Complaint Title (AI Suggestion)' : 'Complaint Title',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // --- Description Field ---
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Complaint Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // --- Submission Button ---
              _isSubmitting || _modelLoading || _isTfliteBusy
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                onPressed: _submitComplaint,
                icon: const Icon(Icons.send),
                label: const Text('Submit Complaint'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
