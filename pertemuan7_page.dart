import 'package:flutter/material.dart';
import 'package:m07/firebase_auth.dart';
import 'package:m07/login_page.dart';

class Pertemuan7Page extends StatefulWidget {
  final String wid;
  final String? email;
  const Pertemuan7Page({super.key, required this.wid, required this.email});

  @override
  State<Pertemuan7Page> createState() => _Pertemuan7PageState();
}

class _Pertemuan7PageState extends State<Pertemuan7Page> {
  late AuthFirebase auth;
  String? email;

  void initState() {
    auth = AuthFirebase();
    auth.getUser().then((value) {
      setState(() {
        email = value?.email;
      });
    }).catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              String? result = await auth.logout();
              if (result != null) {
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
              }
            },
            icon: const Icon(Icons.logout_sharp),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Welcome $email'),
            Text('ID ${widget.wid}'),
          ],
        ),
      ),
    );
  }
}
