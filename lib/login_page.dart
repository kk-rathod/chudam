import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_page.dart';
import 'package:events/navigation_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _login() async {
    try {
      if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
        throw FirebaseAuthException(
          code: 'empty-fields',
          message: 'Email and password cannot be empty.',
        );
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sign_or_login', true);
      await prefs.setString('email', _emailController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationPage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'empty-fields':
          errorMessage = e.message!;
          break;
        default:
          errorMessage = 'An unexpected error occurred. Please try again later.';
      }

      setState(() {
        _errorMessage = errorMessage;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _errorMessage,
            style: const TextStyle(color: Colors.blueGrey),
          ),
          backgroundColor: Colors.white,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Oops! Something went wrong: $_errorMessage',
            style: const TextStyle(color: Colors.blueGrey),
          ),
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign-in was canceled.');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sign_or_login', true);
      await prefs.setString('email', googleUser.email);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationPage()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Oops! Something went wrong: $_errorMessage',
            style: const TextStyle(color: Colors.blueGrey),
          ),
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Image.asset('asserts/images/newsly.webp'),
              ),
            ),
            const SizedBox(height: 50),
            const Divider(),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.black, width: 3),
                ),
                suffixIcon: const Icon(
                  Icons.alternate_email_outlined,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.black, width: 3),
                ),
                suffixIcon: const Icon(
                  Icons.password_outlined,
                  color: Colors.black,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: const Text(
                "Don't have an account? Sign up",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 50),
            const Divider(),
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: const Icon(Icons.g_mobiledata),
            ),
            const Text("sign in via Google"),
          ],
        ),
      ),
    );
  }
}
