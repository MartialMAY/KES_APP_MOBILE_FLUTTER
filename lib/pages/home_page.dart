import 'package:flutter/material.dart';
import 'assistant_auth_page.dart';
import 'assistant_page.dart';
import 'technician_page.dart';
import 'profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('KES Maintenance'),
        actions: user != null
            ? [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Company Information
            Text(
              'KES\nTerminaux Points de vente\n40 Rue du Centre\n17000 La Rochelle\nTél : 0517458798',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (user != null) {
                      // Si un assistant est déjà connecté, aller directement sur AssistantPage
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AssistantPage()),
                      );
                    } else {
                      // Sinon, aller sur AssistantAuthPage pour l'authentification
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AssistantAuthPage()),
                      );
                    }
                  },
                  child: Text('Assistant Interface'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TechnicianPage()),
                    );
                  },
                  child: Text('Technicien Interface'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
