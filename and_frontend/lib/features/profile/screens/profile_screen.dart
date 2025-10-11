import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
            _buildProfileHeader(context),
            const SizedBox(height: 24),
            _buildStatsSection(context),
            const SizedBox(height: 24),
            _buildActionList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person_outline_rounded, size: 50, color: Colors.white),
          // In a real app, you would use a NetworkImage or FileImage here
          // backgroundImage: NetworkImage('user_image_url'),
        ),
        const SizedBox(height: 12),
        Text(
          'Vayu', // Replace with dynamic user name
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          'cs23Vayu@rbmi.in', // Replace with dynamic user email
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(context, count: '8', label: 'Reported'),
        _buildStatItem(context, count: '5', label: 'Resolved'),
        _buildStatItem(context, count: '12', label: 'Rewards'),
      ],
    );
  }

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
            // Navigate back to login screen and remove all previous routes
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
