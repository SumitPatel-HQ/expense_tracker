import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/models/user_profile.dart';
import 'package:expense_tracker/providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildInfoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white54, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    await Provider.of<UserProvider>(context, listen: false).logout();
  }

  @override
  Widget build(BuildContext context) {
    final UserProfile? user = context.watch<UserProvider>().currentUser;


      void showConfirmDialog(BuildContext context){

        showDialog(
        context: context,
        barrierDismissible: false,
        builder:(context){
          return AlertDialog(
            title: Text("Logout Alert"),
            content: Text("Are you sure you want to logout?"),
            actions: [
              TextButton(onPressed: ()
              {Navigator.of(context).pop();
              _handleLogout(context);
              }, 
              child: Text("Yes")),

              TextButton(onPressed: ()
              {Navigator.of(context).pop();}, 
              child: Text("No"))
            ],
          );
        }
        );
      }

    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 40),

              if (user != null) ...[
                _buildInfoTile('Name', user.name),
                _buildInfoTile('Email', user.email),
              ] else
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'No user data found.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 20),

              OutlinedButton(
                onPressed: () => showConfirmDialog(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  side: const BorderSide(color: Colors.white54, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}