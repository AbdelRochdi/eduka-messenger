import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation.dart';
import 'package:chat_app/widgets/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController search = new TextEditingController();

  QuerySnapshot? snapshot;

  initiateSearch() {
    print('initiate search clicked');
    databaseMethods.getUserByUsername(search.text).then((val) {
      setState(() {
        snapshot = val;
      });
    });
  }

  createChatRoomAndStartConversation(String username) {
    if (username != Constants.myName) {
      String chatRoomId = getChatRoomId(username, Constants.myName);
      List<String> roomUsers = [username, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": roomUsers,
        "chatroomId": chatRoomId,
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ConversationScreen(chatRoomId: chatRoomId)));
    } else {
      print("you cannot send message to yourself");
    }
  }

  Widget SearchTile({required String username, required String email}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(username);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFE29578),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Message',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchList() {
    return snapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot!.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                username: snapshot!.docs[index].get("name"),
                email: snapshot!.docs[index].get("email"),
              );
            })
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationBar(),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(color: Color(0xFF83C5BE)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontSize: 19),
                      controller: search,
                      decoration: InputDecoration(
                        hintText: "search username...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE29578),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      iconSize: 28,
                      color: Colors.white,
                      onPressed: () {
                        initiateSearch();
                      },
                    ),
                  )
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
