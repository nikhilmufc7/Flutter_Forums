import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/forum_card.dart';

class ForumsScreen extends StatefulWidget {
  @override
  _ForumsScreenState createState() => _ForumsScreenState();
}

class _ForumsScreenState extends State<ForumsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forums'),
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
}
