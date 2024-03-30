import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  //This variable will be transfer to firebase
  //and used for login simulation
  final String username = "admin";
  final String password = "password";

  final TextEditingController usernameTextfieldController =
      TextEditingController();
  final TextEditingController passwordTextfieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              "ClayGo",
              maxLines: 1,
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 80),
            TextField(
              controller: usernameTextfieldController,
              maxLines: 1,
              decoration: const InputDecoration(
                hintText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordTextfieldController,
              maxLines: 1,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).pushNamed(ScreenNames.home);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 0),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
