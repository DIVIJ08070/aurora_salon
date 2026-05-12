import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/viewmodel/loginvc.dart';

class ProfileTab extends StatelessWidget {
  final LoginVC loginController;

  static const _card = Color(0xFF2D2D2D);
  static const _gold = Color(0xFFC5A059);
  static const _text = Colors.white;
  static const _bg = Color(0xFF1A1A1A);

  const ProfileTab({super.key, required this.loginController});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: _card,
              child: Icon(Icons.person, size: 50, color: _gold),
            ),
            const SizedBox(height: 24),
            Text(
              loginController.userEmail.value,
              style: const TextStyle(color: _text, fontSize: 18),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: loginController.normalLogout,
              icon: const Icon(Icons.logout, color: _bg),
              label: const Text('Log Out', style: TextStyle(color: _bg)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _gold,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: loginController.hardLogout,
              icon: const Icon(Icons.delete_forever, color: Colors.white),
              label: const Text(
                'Hard Log Out (Clear All)',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
