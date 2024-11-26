import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyGoogleAuth extends StatefulWidget {
  const MyGoogleAuth({super.key});

  @override
  State<MyGoogleAuth> createState() => _MyGoogleAuthState();
}

class _MyGoogleAuthState extends State<MyGoogleAuth> {
  User? user;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    setState(() {
      user = null;
    });
    print("User signed out!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Auth"),
      ),
      body: Center(
        child: user == null
            ? ElevatedButton(
                onPressed: () async {
                  User? signedInUser = await signInWithGoogle();
                  setState(() {
                    user = signedInUser;
                  });

                  if (user != null) {
                    print("Signed in as: ${user!.displayName}");
                  }
                },
                child: const Text(
                  "Sign in with Google",
                  style: TextStyle(color: Colors.orange),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        user!.photoURL ?? 'https://via.placeholder.com/150'),
                    radius: 40,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome, ${user!.displayName!}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user!.email!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: signOut,
                    child: const Text("Sign out"),
                  ),
                ],
              ),
      ),
    );
  }
}
