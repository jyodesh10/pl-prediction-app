import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("users").get(), 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child:  CircularProgressIndicator());
          }
          List userdata = snapshot.data!.docs;
          userdata.removeWhere((element) => element['email'] == auth.currentUser?.email);
          return ListView.builder(
            itemCount: userdata.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purple,
                  child: Text(userdata[index]['username'].toString()[0].toUpperCase(), style: const TextStyle(fontSize: 18, color: Colors.white),),
                ),
                title: Text(userdata[index]['username'].toString()),
                subtitle: Text(userdata[index]['email'].toString(), style: const TextStyle(fontSize: 12),),
                trailing: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => 
                      UserPredictionView(
                        prediction: userdata[index]['prediction'],
                        user: userdata[index]['username'],
                        ),
                        ));
                  }, 
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.purple,
                        width: 1.5
                      ),
                      borderRadius: BorderRadius.circular(15)
                    ))
                  ),
                  child: const Text("View Prediction", style: TextStyle(fontSize: 10),) 
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class UserPredictionView extends StatefulWidget {
  const UserPredictionView({super.key, required this.prediction, required this.user});
  final List prediction;
  final String user;

  @override
  State<UserPredictionView> createState() => _UserPredictionViewState();
}

class _UserPredictionViewState extends State<UserPredictionView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user),
      ),
      body: usersPrediction(),
    );
  }

  usersPrediction() {
    return ListView.builder(
      itemCount: widget.prediction.length,
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
              Image.network("https://resources.premierleague.com/premierleague/badges/t${widget.prediction[index]['code']}.png", height: 30,),
              const SizedBox(
                width: 12,
              ),
              Text(widget.prediction[index]['team'].toString()),
            ],
          ),
          trailing: index == 0 ? const Icon(Icons.star, color: Colors.amber,) : const SizedBox(),
        );
      },
    );
  }
}