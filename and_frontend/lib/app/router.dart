import 'package:flutter/material.dart';
import 'package:helpcivic/data/models/complaint_model.dart';
import 'package:helpcivic/features/auth/screens/login_screen.dart';
import 'package:helpcivic/features/auth/screens/role_selection_screen.dart';
import 'package:helpcivic/features/auth/screens/signup_screen.dart';
// By adding 'hide Complaint', we resolve the name conflict.
import 'package:helpcivic/features/complaints/screens/complaint_details_screen.dart' hide Complaint;
import 'package:helpcivic/features/complaints/screens/report_issue_screen.dart';
import 'package:helpcivic/features/shell/main_shell.dart';

// IMPORTANT: Add the import for the ComplaintsListScreen
import 'package:helpcivic/features/complaints/screens/complaints_list_screen.dart';

class AppRouter {
  static const String login = '/';
  static const String signup = '/signup';
  // static const String roleSelection = '/roleSelection';
  static const String mainShell = '/mainShell';
  static const String complaintsList = '/complaints-list'; // Defined here
  static const String complaintDetails = '/complaintDetails';
  static const String reportIssue = '/reportIssue';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
    // case roleSelection:
    //   return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());
      case mainShell:
        return MaterialPageRoute(builder: (_) => const MainShell());

    // --- NEW: Add case for complaintsList ---
      case complaintsList:
        return MaterialPageRoute(builder: (_) => const ComplaintsListScreen());
    // ----------------------------------------

      case complaintDetails:
      // This cast now correctly refers to the Complaint model
        final complaint = settings.arguments as Complaint;
        return MaterialPageRoute(builder: (_) => ComplaintDetailsScreen(complaint: complaint));

      case reportIssue:
        return MaterialPageRoute(builder: (_) => const ReportIssueScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}