import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pl_prediction/apis.dart';
import 'package:pl_prediction/local/sharedPref.dart';
import 'package:pl_prediction/login_page.dart';
import 'package:pl_prediction/model.dart';
import 'package:pl_prediction/widget/dialogs.dart';
import 'package:pl_prediction/widget/snackbars.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late BootStrapModel _bootStrapModel;
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool enabled = true;

  late List predictiondata;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    loading = true;
    _bootStrapModel = await Apis().fetchBootstrapData();
    if(_bootStrapModel.teams!.isNotEmpty) {
      saveIfEmpty();
    }
  }

  saveIfEmpty() async {
    await FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.email).get().then((value) async {
      if(value.data()?["prediction"].isEmpty) {
        await FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.email).update({
          "prediction" : List.generate(_bootStrapModel.teams!.length, (index) => {
            "rank" : index+1,
            "code" : _bootStrapModel.teams![index].code,
            "team" : _bootStrapModel.teams![index].name,
          })
        });
        setState(() {
          predictiondata = value.data()!['prediction'];
        });
      }
    });

    await FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.email).get().then((value) {
      setState(() {
        predictiondata = value.data()!['prediction'];
        enabled = value.data()!['enabled'];
        loading = false; 
      });
    });
  }

  savePrediction() async {
    await FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.email).update({
      "updated_date": DateTime.now(),
      "enabled" : false,
      "prediction" : List.generate(predictiondata.length, (index) => {
        "rank" : index+1,
        "code" :  predictiondata[index]['code'],
        "team" : predictiondata[index]['team'],
      })
    }).whenComplete(() {
      setState(() {
        enabled = false;
      });
      showSnackbar(context, "Prediction Saved");
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Predict Now !!!"),
        actions: [
          const Text("Logout", style: TextStyle(fontSize: 12),),
          IconButton(
            onPressed: () {
              LocalPref.clear();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage(),), (route) => false,);
            },
            icon: const Icon(Icons.logout)
          ),
        ],
      ),
      body: SafeArea(
        child: loading
          ? const Center(
            child: CircularProgressIndicator(),
          ) 
          : ReorderableListView.builder(
            itemCount: predictiondata.length, 
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = predictiondata.removeAt(oldIndex);
                predictiondata.insert(newIndex, item);
              });
            },
            buildDefaultDragHandles: enabled,
            onReorderStart: (index) {
              HapticFeedback.heavyImpact();
            },
            itemBuilder: (context, index) {
              return ListTile(
                key: Key('$index'),
                leading: CircleAvatar(
                  backgroundColor: index == 0 ? Colors.amberAccent : 
                    index == 1 || index == 2 || index == 3
                      ?Colors.lightBlueAccent
                      : index == 19 || index == 18 || index == 17
                        ? Colors.redAccent.shade100
                        : Colors.grey.shade300,
                  radius: 15,
                  child: Text((index+1).toString(), style: const TextStyle(fontSize: 15),)),
                title: Row(
                  children: [
                    Image.network("https://resources.premierleague.com/premierleague/badges/t${predictiondata[index]['code']}.png", height: 30,),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(predictiondata[index]['team'].toString()),
                  ],
                ),
                trailing: const Icon(Icons.drag_handle_rounded),
              );
            }, 
          )

      ),
      floatingActionButton: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.email).snapshots(), 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          return snapshot.data!.data()!['enabled']
            ? FloatingActionButton(
              onPressed: () {
                showCustomDialog(context, () { 
                  savePrediction();
                  Navigator.pop(context);
                });
              },
              child: const Icon(Icons.save)
            )
            : const SizedBox();
        },
      ),
    );
  }
}