import 'package:chat_app/components/text_field.dart';
import 'package:chat_app/components/wall_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
/* User */
  final currentUser = FirebaseAuth.instance.currentUser!;

  final chatController = TextEditingController();

  // sign out user
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void postMessage() {
    /* only post if there is something in the text field */

    if (chatController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'userEmail': currentUser.email,
        'message': chatController.text,
        'timeStamp': Timestamp.now(),
      });

      setState(() {
        chatController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        title: const Text("The Wall"),
        actions: [
          // sign out button
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Container(
          width:
              MediaQuery.of(context).size.width > 640 ? 640 : double.maxFinite,
          color: Colors.grey[300],
          child: Column(
            children: [
              /* the wall */
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("User Posts")
                      .orderBy("timeStamp", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          /* get the message */
                          final post = snapshot.data!.docs[index];
                          return WallPost(
                            message: post['message'],
                            user: post['userEmail'],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),

              /* post message */
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    /* Textfield */
                    Expanded(
                      child: MyTextField(
                        controller: chatController,
                        hintText: 'Write something on the wall..',
                      ),
                    ),
                    IconButton(
                        onPressed: postMessage, icon: const Icon(Icons.send))
                  ],
                ),
              ),

              /* Logged in as */
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Logged in as : ${currentUser.email!}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
