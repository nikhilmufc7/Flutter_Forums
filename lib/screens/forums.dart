import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/forum_card.dart';

class ForumsScreen extends StatefulWidget {
  @override
  _ForumsScreenState createState() => _ForumsScreenState();
}

class _ForumsScreenState extends State<ForumsScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController titleController = TextEditingController();

  var _newTitle = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Forums'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(context),
        child: Icon(Icons.add),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: ForumCard()),
          ],
        ),
      ),
    );
  }

  void _showDialog(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (_) => Column(
              children: [
                Center(
                  child: Text('Start a discussion'),
                ),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      _newTitle = text;
                    });
                  },
                ),
                TextField(),
                RaisedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    titleController.clear();
                    final user = await FirebaseAuth.instance.currentUser();
                    final userData = await Firestore.instance
                        .collection('users')
                        .document(user.uid)
                        .get();
                    Firestore.instance.collection('forums').add({
                      'title': _newTitle,
                      'sentAt': Timestamp.now(),
                      'userId': user.uid,
                      'firstName': userData['firstName'],
                      'userImage': userData['userImage'],
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Submit'),
                )
              ],
            ));
  }
}
