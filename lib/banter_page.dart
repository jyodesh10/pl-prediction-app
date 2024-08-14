import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BanterPage extends StatefulWidget {
  const BanterPage({super.key});

  @override
  State<BanterPage> createState() => _BanterPageState();
}

class _BanterPageState extends State<BanterPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController chatcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Give Banter Take Banter"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("chat").orderBy("created_date", descending: true).snapshots(), 
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    return  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      margin: EdgeInsets.only(
                        bottom: 12, 
                        right: snapshot.data?.docs[index]['username'] == auth.currentUser?.email
                          ? 0
                          : MediaQuery.of(context).size.width * 0.4,
                        left: snapshot.data?.docs[index]['username'] == auth.currentUser?.email
                          ? MediaQuery.of(context).size.width * 0.4
                          : 0,
                      ),
                      decoration: BoxDecoration(
                        color: snapshot.data?.docs[index]['username'] == auth.currentUser?.email ? Colors.green.shade400 : Colors.purple,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data?.docs[index]['msg'],style: const TextStyle(fontSize: 14, color: Colors.white)),
                          const SizedBox(
                            height: 2.5,
                          ),
                          Text(snapshot.data?.docs[index]['username'], style: TextStyle(fontSize: 10, color: Colors.grey.shade300),),
                        ],
                      )
                    );
                  }, 
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: TextField(
                    controller: chatcon,
                    decoration: InputDecoration(
                      labelText: "Give Some Banter...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.purple,
                          width: 1.2
                        )
                      )
                    ),
                  ),
                ) 
              ),
              Expanded(
                flex: 1,
                child: IconButton(onPressed: () async {
                  if(chatcon.text.isNotEmpty) {
                    await FirebaseFirestore.instance.collection("chat").add({
                      "username" : auth.currentUser?.email,
                      "msg" : chatcon.text,
                      "created_date" : DateTime.now()
                    });
                  }
                }, icon: const Icon(Icons.send)),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          )
        ],
      ),
    );
  }
}