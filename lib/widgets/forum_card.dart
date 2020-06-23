import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/chat_screen.dart';
import 'package:intl/intl.dart';

class ForumCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('forums')
          .orderBy('sentAt', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final chatDocuments = snapshot.data.documents;

        return ListView.builder(
            itemCount: chatDocuments.length,
            itemBuilder: (ctx, index) => InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                                documentId:
                                    snapshot.data.documents[index].documentID,
                              ))),
                  child: Card(
                    elevation: 8,
                    child: ListTile(
                      title: Text(chatDocuments[index]['title']),
                      subtitle: Text(DateFormat('dd-MM-yyyy HH:mm')
                          .format(chatDocuments[index]['sentAt'].toDate())),
                    ),
                  ),
                ));
      },
    );
  }
}
