import 'package:flutter/material.dart';
import 'package:helpcivic/data/services/api_service.dart'; // To fetch complaints
import 'package:helpcivic/data/models/complaint_model.dart'; // For ComplaintStatus
import 'package:helpcivic/mongodb.dart'; // To fetch user details
import 'package:helpcivic/app/router.dart'; // For navigation (Logout, etc.)

// Data structure to hold all necessary profile data
class ProfileData {
  final String name;
  final String email;
  final int reportedCount;
  final int resolvedCount;
  final int rewardsCount;

  ProfileData({
    required this.name,
    required this.email,
    required this.reportedCount,
    required this.resolvedCount,
    required this.rewardsCount,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  late Future<ProfileData> _profileDataFuture;

  // Initial state for user info before fetching
  String _userName = 'Citizen';
  String _userEmail = 'loading...';

  @override
  void initState() {
    super.initState();
    _profileDataFuture = _fetchProfileData();
  }

  // --- Core Data Fetching Function ---
  Future<ProfileData> _fetchProfileData() async {
    // 1. Fetch User Details (Name and Email)
    if (MongoDatabase.loggedInUserId != null) {
      try {
        final user = await MongoDatabase.getUserById(MongoDatabase.loggedInUserId!);
        if (user != null) {
          setState(() {
            _userName = user['name'] as String;
            _userEmail = user['email'] as String;
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }

    // 2. Fetch Complaint Statistics
    int reportedCount = 0;
    int resolvedCount = 0;

    try {
      final complaints = await _apiService.getMyComplaints();
      reportedCount = complaints.length;
      resolvedCount = complaints.where((c) => c.status == ComplaintStatus.resolved).length;
    } catch (e) {
      print("Error fetching complaint stats: $e");
    }

    // NOTE: Rewards count is currently hardcoded for lack of a rewards system
    const int rewardsCount = 12;

    return ProfileData(
      name: _userName,
      email: _userEmail,
      reportedCount: reportedCount,
      resolvedCount: resolvedCount,
      rewardsCount: rewardsCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: theme.textTheme.headlineMedium?.copyWith(color: Colors.black87),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dynamic Header: Uses state variables updated in _fetchProfileData
            _buildProfileHeader(context),
            const SizedBox(height: 24),

            // Dynamic Stats: Uses FutureBuilder to display statistics
            _buildStatsSection(context),
            const SizedBox(height: 24),

            // Action List
            _buildActionList(context),
          ],
        ),
      ),
    );
  }

  // --- DYNAMIC WIDGETS ---

  // Fetches name and email from state variables
  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person_outline_rounded, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          _userName, // DYNAMIC NAME
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          _userEmail, // DYNAMIC EMAIL
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // Uses FutureBuilder to display dynamic stats
  Widget _buildStatsSection(BuildContext context) {
    return FutureBuilder<ProfileData>(
      future: _profileDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Use a default/error data if snapshot has no data or an error
        final data = snapshot.data ?? ProfileData(
          name: '', email: '', reportedCount: 0, resolvedCount: 0, rewardsCount: 0,
        );

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(context, count: data.reportedCount.toString(), label: 'Reported'),
            _buildStatItem(context, count: data.resolvedCount.toString(), label: 'Resolved'),
            _buildStatItem(context, count: data.rewardsCount.toString(), label: 'Rewards'),
          ],
        );
      },
    );
  }

  // --- STATIC WIDGETS (Modified only slightly for logic) ---

  Widget _buildStatItem(BuildContext context, {required String count, required String label}) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildActionList(BuildContext context) {
    return Column(
      children: [
        // Navigate to Complaint List using the router (if needed)
        _buildActionListItem(
          context,
          icon: Icons.list_alt_rounded,
          title: 'My Complaints',
          // The correct way to call the named route is using the class:
          onTap: () => Navigator.pushNamed(context, AppRouter.complaintsList),
        ),
        const Divider(height: 24),

        _buildActionListItem(
          context,
          icon: Icons.edit_outlined,
          title: 'Edit Profile',
          onTap: () {},
        ),
        _buildActionListItem(
          context,
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          onTap: () {},
        ),
        _buildActionListItem(
          context,
          icon: Icons.security_outlined,
          title: 'Security',
          onTap: () {},
        ),
        _buildActionListItem(
          context,
          icon: Icons.help_outline_outlined,
          title: 'Help & Support',
          onTap: () {},
        ),
        const Divider(height: 24),
        _buildActionListItem(
          context,
          icon: Icons.logout_rounded,
          title: 'Logout',
          color: Colors.red.shade400,
          onTap: () {
            // Clear the loggedInUserId before navigating
            MongoDatabase.loggedInUserId = null;
            // Navigate back to login screen and remove all previous routes
            Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false);
          },
        ),
      ],
    );
  }

  Widget _buildActionListItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, Color? color}) {
    final theme = Theme.of(context);
    final itemColor = color ?? theme.textTheme.bodyLarge?.color;

    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Text(title, style: theme.textTheme.bodyLarge?.copyWith(color: itemColor, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}