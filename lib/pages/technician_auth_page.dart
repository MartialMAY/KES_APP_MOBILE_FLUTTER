import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'technician_page.dart';

class TechnicianAuthPage extends StatefulWidget {
  @override
  _TechnicianAuthPageState createState() => _TechnicianAuthPageState();
}

class _TechnicianAuthPageState extends State<TechnicianAuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      User? user = userCredential.user;

      if (user != null) {
        if (user.email == 'technician@gmail.com') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => TechnicianPage()),
          );
        } else {
          throw FirebaseAuthException(
            code: 'invalid-user',
            message: 'Invalid technician credentials',
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Technician Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
