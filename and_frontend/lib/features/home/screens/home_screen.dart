// // import 'package:flutter/material.dart';
// // import '../widgets/hero_section.dart';
// // import '../widgets/features_carousel.dart';
// // import '../widgets/news_ticker.dart';
// //
// // class HomeScreen extends StatelessWidget {
// //   const HomeScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       // We use a CustomScrollView to easily combine different scrolling elements
// //       body: CustomScrollView(
// //         slivers: [
// //           SliverAppBar(
// //             expandedHeight: 100.0,
// //             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
// //             elevation: 0,
// //             flexibleSpace: FlexibleSpaceBar(
// //               titlePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
// //               title: Text(
// //                 'Welcome, Citizen!',
// //                 style: Theme.of(context).textTheme.headlineMedium?.copyWith(
// //                   color: Colors.black87,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               centerTitle: false,
// //             ),
// //           ),
// //           // A SliverList allows us to place regular widgets inside a CustomScrollView
// //           SliverList(
// //             delegate: SliverChildListDelegate(
// //               [
// //                 const HeroSection(),
// //                 const SizedBox(height: 24),
// //                 _buildSectionHeader(context, 'Key Features'),
// //                 const FeaturesCarousel(),
// //                 const SizedBox(height: 24),
// //                 _buildSectionHeader(context, 'Latest Updates'),
// //                 const NewsTicker(),
// //                 const SizedBox(height: 24),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // Helper widget to create styled section headers
// //   Widget _buildSectionHeader(BuildContext context, String title) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //       child: Text(
// //         title,
// //         style: Theme.of(context).textTheme.titleMedium?.copyWith(
// //           fontWeight: FontWeight.w600,
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:helpcivic/data/models/complaint_model.dart';
// import 'package:helpcivic/data/services/api_service.dart'; // Import ApiService
// import '../widgets/hero_section.dart';
// import '../widgets/features_carousel.dart';
// import '../widgets/news_ticker.dart';
//
// // 1. Convert to StatefulWidget to manage future data
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final ApiService _apiService = ApiService();
//   late Future<int> _pendingComplaintCountFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     // 2. Fetch data when the screen initializes
//     _fetchData();
//   }
//
//   void _fetchData() {
//     setState(() {
//       // Assuming ApiService has a method to get the count of pending issues
//       // If this method doesn't exist yet, we'll assume it returns the list and we count the 'pending' status.
//       _pendingComplaintCountFuture = _getPendingCount();
//     });
//   }
//
//   // 3. Helper to count pending complaints using the existing API service
//   Future<int> _getPendingCount() async {
//     try {
//       final complaints = await _apiService.getMyComplaints();
//       // Filter the list for 'pending' status and return the count
//       return complaints.where((c) => c.status == ComplaintStatus.pending).length;
//     } catch (e) {
//       print("Error fetching complaint count: $e");
//       // Return 0 or handle error gracefully
//       return 0;
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 100.0,
//             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//             elevation: 0,
//             flexibleSpace: FlexibleSpaceBar(
//               titlePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//               title: Text(
//                 'Welcome, Citizen!',
//                 style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                   color: Colors.black87,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               centerTitle: false,
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate(
//               [
//                 // --- NEW: Dynamic User Status Section ---
//                 _buildUserStatusCard(context),
//                 const SizedBox(height: 24),
//                 // ----------------------------------------
//
//                 const HeroSection(),
//                 const SizedBox(height: 24),
//                 _buildSectionHeader(context, 'Key Features'),
//                 const FeaturesCarousel(),
//                 const SizedBox(height: 24),
//                 _buildSectionHeader(context, 'Latest Updates'),
//                 const NewsTicker(),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Helper widget to create dynamic user status card
//   Widget _buildUserStatusCard(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       // Use FutureBuilder to display dynamic data
//       child: FutureBuilder<int>(
//         future: _pendingComplaintCountFuture,
//         builder: (context, snapshot) {
//           int count = 0;
//           bool isLoading = snapshot.connectionState == ConnectionState.waiting;
//
//           if (snapshot.hasData) {
//             count = snapshot.data!;
//           }
//
//           // Dynamic Text/Content based on the count
//           final String statusText = isLoading
//               ? 'Loading your status...'
//               : count > 0
//               ? 'You have $count pending issues.'
//               : 'All your issues are resolved or in progress. Great work!';
//
//           final IconData statusIcon = count > 0 ? Icons.warning_amber_rounded : Icons.thumb_up_alt_rounded;
//           final Color statusColor = count > 0 ? Colors.orange.shade600 : Colors.green.shade600;
//
//           return Card(
//             elevation: 2,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   Icon(statusIcon, color: statusColor, size: 32),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       statusText,
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                   ),
//                   if (count > 0 && !isLoading)
//                     TextButton(
//                       onPressed: () {
//                         // Navigate to the complaints list screen
//                         // You need to ensure you have a router path defined for your list screen
//                         Navigator.pushNamed(context, '/complaints-list');
//                       },
//                       child: const Text('View'),
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   // Helper widget to create styled section headers (remains the same)
//   Widget _buildSectionHeader(BuildContext context, String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Text(
//         title,
//         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:helpcivic/data/models/complaint_model.dart';
import 'package:helpcivic/data/services/api_service.dart';
import 'package:helpcivic/app/router.dart';
import 'package:helpcivic/features/home/widgets/hero_section.dart';
import 'package:helpcivic/features/home/widgets/news_ticker.dart';
import 'package:helpcivic/mongodb.dart'; // Import to get user data and loggedInUserId

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<int> _pendingComplaintCountFuture;

  // Dynamic Greeting State
  String _userName = 'Citizen';

  @override
  void initState() {
    super.initState();
    _fetchData();
    _loadUserName();
  }

  // --- DYNAMIC USER NAME FETCHING ---
  void _loadUserName() async {
    // Check if the static loggedInUserId is set upon login
    if (MongoDatabase.loggedInUserId != null) {
      try {
        // Fetch the user document using the new helper function
        // This relies on having MongoDatabase.getUserById implemented in mongodb.dart
        final user = await MongoDatabase.getUserById(MongoDatabase.loggedInUserId!);

        // Check if the user document and the 'name' field exist
        if (user != null && user.containsKey('name')) {
          setState(() {
            // Update the state with the actual user's name
            _userName = user['name'] as String;
          });
        }
      } catch (e) {
        print("Error fetching user name in HomeScreen: $e");
      }
    }
  }

  void _fetchData() {
    setState(() {
      _pendingComplaintCountFuture = _getPendingCount();
    });
  }

  Future<int> _getPendingCount() async {
    try {
      final complaints = await _apiService.getMyComplaints();
      return complaints.where((c) => c.status == ComplaintStatus.pending).length;
    } catch (e) {
      print("Error fetching complaint count: $e");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              title: Text(
                // --- DYNAMIC GREETING ---
                'Welcome, $_userName!',
                // ------------------------
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Dynamic Status Card & Quick Action Grid
                _buildDynamicStatusAndActions(context),
                const SizedBox(height: 24),

                // Static elements adjusted to the new dynamic flow
                const HeroSection(),
                const SizedBox(height: 24),

                // Removed FeaturesCarousel section based on your previous source code

                _buildSectionHeader(context, 'Latest Updates'),
                const NewsTicker(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function combining status and actions
  Widget _buildDynamicStatusAndActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPendingStatusCard(context),
          const SizedBox(height: 16),

          _buildSectionHeader(context, 'Quick Actions'),
          const SizedBox(height: 8),
          _buildActionGrid(context),
        ],
      ),
    );
  }

  // Builds the card showing the pending issue count (Updated to be clickable)
  Widget _buildPendingStatusCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: FutureBuilder<int>(
        future: _pendingComplaintCountFuture,
        builder: (context, snapshot) {
          int count = snapshot.data ?? 0;
          bool isLoading = snapshot.connectionState == ConnectionState.waiting;

          final String statusText = isLoading
              ? 'Checking your open issues...'
              : count > 0
              ? 'You have $count issues currently pending!'
              : 'All caught up! No pending issues.';

          final IconData statusIcon = count > 0 ? Icons.error_outline : Icons.check_circle_outline;
          final Color statusColor = count > 0 ? Colors.red.shade600 : Colors.green.shade600;

          return InkWell(
            // --- CRUCIAL: Redirect to Complaints List ---
            onTap: () {
              Navigator.pushNamed(context,'AppRouter.complaintsList');
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      statusText,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  // --- Re-introduced navigation arrow ---
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Builds the grid of quick action buttons
  Widget _buildActionGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 0.85,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildActionButton(
          context,
          title: 'Report New Issue',
          icon: Icons.add_a_photo_outlined,
          color: Theme.of(context).primaryColor,
          onTap: () => Navigator.pushNamed(context, AppRouter.reportIssue),
        ),
        _buildActionButton(
          context,
          title: 'Quick Reporting',
          icon: Icons.flash_on_outlined,
          color: Colors.orange,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Quick Reporting feature coming soon!')),
            );
          },
        ),
        _buildActionButton(
          context,
          title: 'Earn Rewards',
          icon: Icons.card_giftcard_outlined,
          color: Colors.green,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('View your Civic Rewards!')),
            );
          },
        ),
      ],
    );
  }

  // Template for individual action button in the grid
  Widget _buildActionButton(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to create styled section headers
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}