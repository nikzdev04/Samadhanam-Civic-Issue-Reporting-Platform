import 'package:flutter/material.dart';
import 'dart:math';

// Data model for a single reward
class Reward {
  final String title;
  final String description;
  final String value;
  final IconData icon;
  final Color color;
  final int requiredPoints;

  Reward({
    required this.title,
    required this.description,
    required this.value,
    required this.icon,
    required this.color,
    required this.requiredPoints,
  });
}

// Mock data generator for rewards
class RewardData {
  static List<Reward> generateRandomRewards(int count) {
    final random = Random();
    final List<Map<String, dynamic>> templates = [
      {'title': 'Amazon Voucher', 'icon': Icons.shopping_bag_outlined, 'color': Colors.orange},
      {'title': 'Cash Prize', 'icon': Icons.monetization_on_outlined, 'color': Colors.green},
      {'title': 'Local Cafe Coupon', 'icon': Icons.local_cafe_outlined, 'color': Colors.brown},
      {'title': 'Free Movie Ticket', 'icon': Icons.movie_outlined, 'color': Colors.blueGrey},
      {'title': 'Discount on Utility Bill', 'icon': Icons.lightbulb_outline, 'color': Colors.cyan},
    ];

    return List.generate(count, (index) {
      final template = templates[random.nextInt(templates.length)];
      final isCash = template['title'] == 'Cash Prize';

      final points = (random.nextInt(5) + 1) * 100; // 100, 200, 300... 500
      final amount = (random.nextInt(5) + 1) * 50; // 50, 100, 150... 250

      return Reward(
        title: template['title'] as String,
        description: isCash
            ? 'Redeem cash directly to your bank account.'
            : 'Applicable on any purchase above ₹500.',
        value: isCash ? '₹$amount' : '₹$amount Off',
        icon: template['icon'] as IconData,
        color: template['color'] as Color,
        requiredPoints: points,
      );
    });
  }
}

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Reward> availableRewards = RewardData.generateRandomRewards(10);
    const int userPoints = 1250; // Mock user points from ProfileScreen

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Rewards'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header showing user's current points
          Container(
            padding: const EdgeInsets.all(20.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Total Points',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rate_rounded, color: Colors.amber, size: 30),
                    const SizedBox(width: 8),
                    Text(
                      '$userPoints',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Text(
              'Redeem Vouchers & Cash Prizes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // List of Rewards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: availableRewards.length,
              itemBuilder: (context, index) {
                final reward = availableRewards[index];
                final bool canRedeem = userPoints >= reward.requiredPoints;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: CircleAvatar(
                      backgroundColor: reward.color.withOpacity(0.1),
                      child: Icon(reward.icon, color: reward.color),
                    ),
                    title: Text(
                      reward.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(reward.description),
                        const SizedBox(height: 4),
                        Text(
                          'Value: ${reward.value}',
                          style: TextStyle(color: reward.color, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: canRedeem ? () => _showRedeemDialog(context, reward) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canRedeem ? Theme.of(context).primaryColor : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('${reward.requiredPoints} pts'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showRedeemDialog(BuildContext context, Reward reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Redeem ${reward.title}?'),
        content: Text('Do you want to spend ${reward.requiredPoints} points to get ${reward.value}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Placeholder for actual redemption logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Redeemed ${reward.title} for ${reward.requiredPoints} points!')),
              );
            },
            child: Text('Redeem', style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    );
  }
}