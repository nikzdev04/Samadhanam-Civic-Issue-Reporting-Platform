import 'package:flutter/material.dart';
import '../widgets/hero_section.dart';
import '../widgets/features_carousel.dart';
import '../widgets/news_ticker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We use a CustomScrollView to easily combine different scrolling elements
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              title: Text(
                'Welcome, Citizen!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
            ),
          ),
          // A SliverList allows us to place regular widgets inside a CustomScrollView
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const HeroSection(),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'Key Features'),
                const FeaturesCarousel(),
                const SizedBox(height: 24),
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

  // Helper widget to create styled section headers
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
