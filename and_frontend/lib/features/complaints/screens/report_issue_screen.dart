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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:helpcivic/data/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
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
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        _currentAddress = "Could not fetch location.";
      });
    }
  }


  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate() && _imageFile != null && _currentPosition != null) {
      setState(() {
        _isSubmitting = true;
      });

      // CRITICAL: Get the local file path to save to MongoDB
      final String localImagePath = _imageFile!.path;

      try {
        final bool success = await _apiService.submitComplaint(
            title: _titleController.text,
            description: _descriptionController.text,
            location: _currentAddress ?? 'Location not available',
            latitude: _currentPosition!.latitude,
            longitude: _currentPosition!.longitude,
            // CHANGED: Pass the local file path instead of the static URL
            imageUrl: localImagePath); // 👈 NOW SAVING THE LOCAL PATH!

        if (success && mounted) {  // 👈 Check for success
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
              if (_currentAddress != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Location: $_currentAddress',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Complaint Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
              _isSubmitting
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

