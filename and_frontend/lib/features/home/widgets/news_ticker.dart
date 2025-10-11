import 'package:flutter/material.dart';
import 'dart:async';

class NewsTicker extends StatefulWidget {
  const NewsTicker({super.key});

  @override
  State<NewsTicker> createState() => _NewsTickerState();
}

class _NewsTickerState extends State<NewsTicker> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  final List<String> _newsItems = [
    'Government launches new sanitation drive in urban areas.',
    'New data shows a 15% improvement in pothole repair times.',
    'Citizens in Ward 12 rewarded for active community participation.',
    'Authorities announce upcoming city-wide cleanliness competition.',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < _newsItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Icon(Icons.campaign_rounded, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _newsItems.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    _newsItems[index],
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}