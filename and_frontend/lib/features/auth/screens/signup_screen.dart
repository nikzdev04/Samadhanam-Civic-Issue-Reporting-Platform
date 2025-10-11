// import 'package:flutter/material.dart';
// import 'package:helpcivic/app/router.dart';
// import 'package:helpcivic/mongodb.dart';
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
//     _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//     _controller.forward();
//   }
//
//   // --- UPDATED: Signup logic now connects to MongoDB ---
//   Future<void> _handleSignUp() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//
//       try {
//         // Create a map of the user data
//         final userData = {
//           'name': _nameController.text.trim(),
//           'email': _emailController.text.trim(),
//           'password': _passwordController.text.trim(), // In a real app, hash this!
//           // Add any other default fields you want
//           'role': 'citizen',
//           'rewardPoints': 0,
//           'complaints': [],
//         };
//
//         // Call the insertUser function from our MongoDatabase service
//         await MongoDatabase.insertUser(userData);
//
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Welcome, ${_nameController.text.trim()}! Account created.')),
//           );
//           // Navigate to the next screen on successful signup
//           Navigator.pushReplacementNamed(context, AppRouter.roleSelection);
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('An error occurred: $e')),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: BackButton(color: Colors.white),
//       ),
//       extendBodyBehindAppBar: true,
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [theme.primaryColor.withOpacity(0.8), theme.colorScheme.secondary.withOpacity(0.8)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: ScaleTransition(
//               scale: _scaleAnimation,
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text('Create Account', textAlign: TextAlign.center, style: theme.textTheme.displayLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     Text('Join our community to make a difference', textAlign: TextAlign.center, style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70)),
//                     const SizedBox(height: 48),
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: const InputDecoration(labelText: 'Full Name', filled: true, fillColor: Colors.white, prefixIcon: Icon(Icons.person_outline)),
//                       validator: (value) => (value == null || value.isEmpty) ? 'Please enter your name' : null,
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: const InputDecoration(labelText: 'Email Address', filled: true, fillColor: Colors.white, prefixIcon: Icon(Icons.email_outlined)),
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) => (value == null || !value.contains('@')) ? 'Please enter a valid email' : null,
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _passwordController,
//                       obscureText: true,
//                       decoration: const InputDecoration(labelText: 'Password', filled: true, fillColor: Colors.white, prefixIcon: Icon(Icons.lock_outline)),
//                       validator: (value) => (value == null || value.length < 6) ? 'Password must be at least 6 characters' : null,
//                     ),
//                     const SizedBox(height: 32),
//                     _isLoading
//                         ? const Center(child: CircularProgressIndicator(color: Colors.white))
//                         : ElevatedButton(
//                       onPressed: _handleSignUp,
//                       child: const Text('SIGN UP'),
//                     ),
//                     const SizedBox(height: 24),
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: Text('Already have an account? Log In', style: TextStyle(color: Colors.white.withOpacity(0.9))),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//


import 'package:flutter/material.dart';
import 'package:helpcivic/app/router.dart';
import 'package:helpcivic/mongodb.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  // --- UPDATED: Signup logic now handles the success/failure response ---
  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final userData = {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(), // In a real app, this should be hashed
          'role': 'citizen',
          'rewardPoints': 0,
          'complaints': [],
        };

        // The insertUser function now returns true for success and false for failure
        final bool success = await MongoDatabase.insertUser(userData);

        if (mounted) {
          if (success) {
            // If signup was successful
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Welcome, ${_nameController.text.trim()}! Account created.')),
            );
            // Navigator.pushReplacementNamed(context, AppRouter.roleSelection);
          } else {
            // If user already exists
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('An account with this email already exists.')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.primaryColor.withOpacity(0.8), theme.colorScheme.secondary.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Create Account', textAlign: TextAlign.center, style: theme.textTheme.displayLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Join our community to make a difference', textAlign: TextAlign.center, style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70)),
                    const SizedBox(height: 48),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name', filled: true, fillColor: Colors.white, prefixIcon: Icon(Icons.person_outline)),
                      validator: (value) => (value == null || value.isEmpty) ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email Address', filled: true, fillColor: Colors.white, prefixIcon: Icon(Icons.email_outlined)),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => (value == null || !value.contains('@')) ? 'Please enter a valid email' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password', filled: true, fillColor: Colors.white, prefixIcon: Icon(Icons.lock_outline)),
                      validator: (value) => (value == null || value.length < 6) ? 'Password must be at least 6 characters' : null,
                    ),
                    const SizedBox(height: 32),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.white))
                        : ElevatedButton(
                      onPressed: _handleSignUp,
                      child: const Text('SIGN UP'),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Already have an account? Log In', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
