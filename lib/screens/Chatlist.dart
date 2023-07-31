import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netteam/screens/Chat.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

import '../main.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  IO.Socket socket = IO.io(dotenv.env['BACKEND_URL'],<String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  late String id;
  bool chatOpened = false;
  final List<UserList> _userList = <UserList>[];

  void handleChatClosed(bool isOpened) {
    // Handle the chat state here
    if (!isOpened) {
      chatOpened = false;
    }
  }

  Future<List<dynamic>> getChattedUsers() async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/usersAndUnseenChatsAndLastMessage";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String,dynamic>{
            "userId": id,
          })
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 404) {
        // Handle the error accordingly
      } else {
        // Other error occurred
        // Handle the error accordingly
      }
    } catch (error) {
      // Error occurred during the API call
      // Handle the error accordingly
    }
    return [];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socket.connect();
    id = Provider.of<MyDataContainer>(context,listen: false).id;
    getChattedUsers().then((users) => {
      setState(() {
        users.forEach((user) => _userList.add(UserList(
            imageUrl: user["profilePic"] != "" ? '${dotenv.env["BACKEND_URL"]}/${user["profilePic"]}' : "assets/images/avatar.jpg",
            userName: user["name"],
            recentText: user["lastMessage"],
            unseen: user["unseenCount"],
            onTap: (context) {
              chatOpened = true;
              Navigator.push(context,
                  MaterialPageRoute(builder:
                      (context) => Chat(socket: socket,handleChatClosed: handleChatClosed,name: user["name"],userID: user["_id"],)
                  )
              );
            }
        ))
        );
      })
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    socket.dispose();
    super.dispose();
  }

  _getImageProvider(UserList user) {
    return Uri.parse(user.imageUrl).isAbsolute
        ? NetworkImage(user.imageUrl)
        : AssetImage(user.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0B1F),
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text(
          'Messages',
          style: GoogleFonts.roboto(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF0E0B1F),
      body: ListView.builder(
        itemCount: _userList.length,
        itemBuilder: (context, index) {
          UserList user = _userList[index];
          return Card(
            margin: EdgeInsets.all(5.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ListTile(
                  tileColor: const Color(0xFF272A35),
                  leading: CircleAvatar(
                    backgroundImage: _getImageProvider(user),
                  ),
                  title: Text(user.userName),
                  onTap: () {
                    user.onTap(context);
                  },
                  subtitle: Text(user.recentText),
                ),
                (user.unseen > 0) // Conditionally show the red circle when there are unseen messages
                    ? Positioned(
                      top: 10.0,
                      right: 10.0,
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                    : SizedBox(), // If there are no unseen messages, use a SizedBox to occupy the space
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: Color(0xFF0E0B1F),
        child: SizedBox(
          height: 60.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.home,
                        size: 30.h, color: const Color(0xFFFFFFFF))),
                onTap: () {
                  //Navigate to Home
                  Navigator.pushReplacementNamed(context, "/");
                },
              ),
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.videocam_rounded,
                        size: 30.h, color: const Color(0xFFFFFFFF))),
                onTap: () {
                  //Navigate to Video Call
                  Navigator.pushReplacementNamed(context, "/videoset");
                },
              ),
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.add_circle_rounded,
                        size: 30.h, color: const Color(0xFFFFFFFF))),
                onTap: () {
                  //Navigate to Add tiktok
                  Navigator.pushReplacementNamed(context, "/create");
                },
              ),
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.chat_bubble,
                        size: 30.h, color: const Color(0xFF1EA7D7))),
                onTap: () {
                  //Navigate to chat
                  Navigator.pushReplacementNamed(context, "/chatlist");
                },
              ),
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.account_circle,
                        size: 30.h, color: const Color(0xFFFFFFFF))),
                onTap: () {
                  //Navigate to Account section
                  Navigator.pushReplacementNamed(context, "/aboutyou");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserList {
  String imageUrl;
  String userName;
  String recentText;
  int unseen;
  Function onTap;
  UserList(
      {required this.imageUrl,
      required this.userName,
      required this.recentText,
        required this.unseen,
      required this.onTap});
}
