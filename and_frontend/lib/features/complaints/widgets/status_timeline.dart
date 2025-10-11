import 'package:flutter/material.dart';
import 'package:helpcivic/data/models/complaint_model.dart';
import 'package:helpcivic/features/complaints/screens/complaint_details_screen.dart';
import 'package:intl/intl.dart';

class StatusTimeline extends StatelessWidget {
  final List<TimelineEvent> timeline;
  const StatusTimeline({super.key, required this.timeline});

  @override
  Widget build(BuildContext context) {
    if (timeline.isEmpty) {
      return const Center(child: Text("No updates available yet."));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: timeline.length,
      itemBuilder: (context, index) {
        final event = timeline[index];
        final isFirst = index == 0;
        final isLast = index == timeline.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTimelineConnector(context, isFirst: isFirst, isLast: isLast),
              Expanded(
                child: _buildTimelineEventCard(context, event: event),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineConnector(BuildContext context, {required bool isFirst, required bool isLast}) {
    return Container(
      width: 40,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: VerticalDivider(
              width: 2,
              thickness: 2,
              color: isFirst ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
          Icon(
            isFirst ? Icons.check_circle : Icons.circle,
            color: isFirst ? Theme.of(context).primaryColor : Colors.grey.shade400,
            size: 24,
          ),
          Expanded(
            child: VerticalDivider(
              width: 2,
              thickness: 2,
              color: isLast ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineEventCard(BuildContext context, {required TimelineEvent event}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.status,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(event.description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                DateFormat('dd MMM, yyyy - hh:mm a').format(event.date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
