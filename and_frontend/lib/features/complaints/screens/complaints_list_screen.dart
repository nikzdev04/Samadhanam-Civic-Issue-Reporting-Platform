import 'package:flutter/material.dart';
import 'package:helpcivic/data/models/complaint_model.dart';
import 'package:helpcivic/data/services/api_service.dart';
import 'package:helpcivic/features/complaints/widgets/complaint_card.dart';
import 'package:helpcivic/features/complaints/widgets/empty_complaints.dart';
import 'package:helpcivic/features/complaints/widgets/filter_and_search_bar.dart';
import 'package:helpcivic/app/router.dart'; // Router import karna zaroori hai

class ComplaintsListScreen extends StatefulWidget {
  const ComplaintsListScreen({super.key});

  @override
  State<ComplaintsListScreen> createState() => _ComplaintsListScreenState();
}

class _ComplaintsListScreenState extends State<ComplaintsListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Complaint>> _complaintsFuture;

  @override
  void initState() {
    super.initState();
    _fetchComplaints();
  }

  // Data fetch karne ke liye alag function banaya
  void _fetchComplaints() {
    setState(() {
      _complaintsFuture = _apiService.getMyComplaints();
    });
  }

  // Is function se hum nayi screen par jaayenge aur wapas aane par list refresh karenge
  void _navigateToReportScreen() {
    Navigator.pushNamed(context, AppRouter.reportIssue).then((_) {
      // Jab user report screen se wapas aayega, to yeh code chalega
      // aur list ko refresh karega.
      _fetchComplaints();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aapki Shikayatein'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const FilterAndSearchBar(),
          Expanded(
            child: FutureBuilder<List<Complaint>>(
              future: _complaintsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Ab 'Report New Complaint' button refresh logic ka istemal karega
                  return EmptyComplaints(onReport: _navigateToReportScreen);
                }

                final complaints = snapshot.data!;
                return RefreshIndicator(
                  onRefresh: () async {
                    _fetchComplaints();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      return ComplaintCard(complaint: complaints[index]);
                    },
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
