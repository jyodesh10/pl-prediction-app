// ignore_for_file: use_build_context_synchronously

import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:pl_prediction/login_page.dart";
import "package:pl_prediction/widget/snackbars.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  firebaseRegister() async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email.text, password: password.text);
      if(userCredential.user!.email!.isNotEmpty) {
        saveUser();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage(),), (route) => false,);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        showSnackbar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        showSnackbar(context, 'The account already exists for that email.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  saveUser() {
    FirebaseFirestore.instance.collection("users").doc(email.text).set({
      "username": username.text,
      "email" : email.text,
      "password" : password.text,
      "enabled" : true,
      "updated_date" : DateTime.now(),
      "prediction" :[]
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: username,
                  validator: (value) {
                    if(value!.isEmpty) {
                      return "*required";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Username"
                  ),
                ),
                const SizedBox(
                  height: 12,
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
                    labelText: "Email"
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
                      firebaseRegister();
                    }
                  },
                  color: Colors.purple,
                  child: const Text("Register", style: TextStyle(color: Colors.white),),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}