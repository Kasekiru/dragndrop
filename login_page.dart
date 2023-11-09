import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m07/firebase_auth.dart';
import 'package:m07/pertemuan7_page.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthFirebase auth;
  GoogleSignIn googleSign = GoogleSignIn();

  @override
  void initState() {
    auth = AuthFirebase();
    auth.getUser().then((value) {
      MaterialPageRoute route;
      if (value != null) {
        route = MaterialPageRoute(
            builder: (context) => Pertemuan7Page(
                  wid: value.uid,
                  email: value.email,
                ));
        Navigator.pushReplacement(context, route);
      }
    }).catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      theme: LoginTheme(
        pageColorDark: Colors.amber,
        primaryColor: Colors.red,
        pageColorLight: Colors.grey,
        primaryColorAsInputLabel: true,
      ),
      onLogin: _loginUser,
      onRecoverPassword: _recoverPassword,
      onSignup: _onSignup,
      passwordValidator: (value) {
        if (value != null) {
          if (value.length < 6) {
            return "Password must be 6 characters";
          }
        }
        return null;
      },
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: _onLoginGoogle,
        ),
        LoginProvider(
          icon: FontAwesomeIcons.facebook,
          label: 'Facebook',
          callback: _onLoginFacebook,
        ),
      ],
      onSubmitAnimationCompleted: () {
        auth.getUser().then((value) {
          MaterialPageRoute route;
          if (value != null) {
            route = MaterialPageRoute(
              builder: (context) =>
                  Pertemuan7Page(wid: value.uid, email: value.email),
            );
          } else {
            route = MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          }
          Navigator.pushReplacement(context, route);
        }).catchError((err) => print(err));
      },
    );
  }

  Future<String?>? _loginUser(LoginData data) {
    return auth.login(data.name, data.password).then((value) {
      if (value != null) {
        MaterialPageRoute(
            builder: (context) => Pertemuan7Page(wid: value, email: data.name));
      } else {
        final snackBar = SnackBar(
          content: const Text('Login Failed, User Not Found'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
      }
    });
  }

  Future<String?>? _recoverPassword(String data) {
    auth.getUser().then((value) {
      if (value != null) {
        if (value.email == data) {
          return 'User exists';
        } else {
          return 'User not exists';
        }
      } else {
        print('something wrong');
      }
    }).catchError((err) => print(err));
  }

  Future<String?>? _onSignup(SignupData data) {
    return auth.signUp(data.name!, data.password!).then((value) {
      if (value != null) {
        final snackBar = SnackBar(
          content: const Text('Sign Up Succesfull'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  Future<String?>? _onLoginGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSign.signIn();
      // final GoogleSignInAuthentication googleAuth =
      //     await googleUser!.authentication;
      // final AuthCredential credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );

      // final UserCredential authResult =
      //     await FirebaseAuth.instance.signInWithCredential(credential);
      // final User? user = authResult.user;
      // if (user != null) {
      // Successfully authenticated with Google
      // You can navigate to the next screen or perform any desired actions here
      // ignore: use_build_context_synchronously
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => Pertemuan7Page(
      //             wid: authResult.credential.toString(),
      //             email: authResult.user?.displayName)));
      // }
      // if (googleUser != null) {
      //   // Successfully authenticated with Google
      //   // You can navigate to the next screen or perform any desired actions here
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Pertemuan7Page(
                  wid: googleUser!.id, email: googleUser!.email)));
      // }
    } catch (e) {
      print('Error during Google authentication: $e');
    }
  }

  Future<String?>? _onLoginFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      final accessToken = result.accessToken;
      final AuthCredential credential =
          FacebookAuthProvider.credential(accessToken!.token);

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;
      if (user != null) {
        // Successfully authenticated with Facebook
        // You can navigate to the next screen or perform any desired actions here
      }
    } catch (e) {
      print('Error during Facebook authentication: $e');
    }
  }
}
