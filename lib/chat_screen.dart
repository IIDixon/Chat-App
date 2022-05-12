import 'dart:io';
import 'package:chat/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void sendMessage({String? text, File? imgFile}) async{
    Map<String, dynamic> data = {};

    if(imgFile != null){
      firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("Pasta do chat")
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);

      firebase_storage.TaskSnapshot taskSnapshot = await task;
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = url;
    }

    if(text != null) data['Texto'] = text;

    FirebaseFirestore.instance.collection("chat_online").add(data);
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Olá'),
        elevation: 0,
      ),
      body: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('messages').snapshots(),
                  builder: (context, snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        List<DocumentSnapshot> documents = snapshot.data!.docs.reversed.toList();
                        return ListView.builder(
                          itemCount: documents.length,
                          reverse: true,
                          itemBuilder: (context, index){
                            return ListTile(
                              title: Text(documents[index].get('text')),
                            );
                          },
                        );
                    }
                  },
                ),
            ),
            TextComposer(sendMessage),
          ]
      ),
    );
  }


}




