// ignore_for_file: use_build_context_synchronously

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:pl_prediction/register_page.dart";
import "package:pl_prediction/widget/dialogs.dart";

import "local/sharedPref.dart";
import "nav_page.dart";
import "widget/snackbars.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  checkLogin() async {
    if(LocalPref.getString("email") != null && LocalPref.getString("password") != null ) {
      email.text = LocalPref.getString("email").toString();
      password.text = LocalPref.getString("password").toString();
      Future.delayed(const Duration(seconds: 1), () => 
        firebaseLogin());
    }
  }

  firebaseLogin() async {
    showFullDialog(context);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text
      );

      if(userCredential.user!.email!.isNotEmpty) {
        Navigator.pop(context);
        LocalPref.setString("email", email.text);
        LocalPref.setString("password", password.text);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  const NavPage(),), (route) => false,);
      }

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        showSnackbar(context, 'No user found for that email.');

      } else if (e.code == 'wrong-password') {
        showSnackbar(context, 'Wrong password provided for that user.');
      } else {
        showSnackbar(context, e.message.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                  ),
                  Image.asset("assets/pl.png", height: 100,),
                  const Text("Premier League\nPredictions", style: TextStyle(fontSize: 20, color: Colors.purple, fontWeight: FontWeight.bold),),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: email,
                    validator: (value) {
                      if(value!.isEmpty) {
                        return "*required";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: password,
                    validator: (value) {
                      if(value!.isEmpty) {
                        return "*required";
                      } else {
                        return null;
                      }
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password"
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  MaterialButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate()) {
                        firebaseLogin();
                      }
                    },
                    color: Colors.purple,
                    child: const Text("Login", style: TextStyle(color: Colors.white),),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage(),));
                
                    }, child: const Text("Register"))
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}