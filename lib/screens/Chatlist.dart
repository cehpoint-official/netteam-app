import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final List<UserList> _userList = <UserList>[
    UserList(
        imageUrl: "assets/images/profile1.png",
        userName: "Aswin Raaj",
        recentText: "Hey, How are you ?",
        onTap: (context) {
          Navigator.pushNamed(context, "/chat");
        }),
    UserList(
        imageUrl: "assets/images/profile2.png",
        userName: "Kumar",
        recentText: "Ok, I will do it",
        onTap: (context) {
          Navigator.pushNamed(context, "/chat");
        }),
  ];

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
            child: ListTile(
              tileColor: const Color(0xFF272A35),
              leading: CircleAvatar(
                backgroundImage: AssetImage(user.imageUrl),
              ),
              title: Text(user.userName),
              onTap: () {
                user.onTap(context);
              },
              subtitle: Text(user.recentText),
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
                  Navigator.pushNamed(context, "/");
                },
              ),
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.videocam_rounded,
                        size: 30.h, color: const Color(0xFFFFFFFF))),
                onTap: () {
                  //Navigate to Video Call
                  Navigator.pushNamed(context, "/videoset");
                },
              ),
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.add_circle_rounded,
                        size: 30.h, color: const Color(0xFFFFFFFF))),
                onTap: () {
                  //Navigate to Add tiktok
                  Navigator.pushNamed(context, "/video15");
                },
              ),
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.chat_bubble,
                        size: 30.h, color: const Color(0xFF1EA7D7))),
                onTap: () {
                  //Navigate to chat
                 
                },
              ),
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.account_circle,
                        size: 30.h, color: const Color(0xFFFFFFFF))),
                onTap: () {
                  //Navigate to Account section
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
  Function onTap;
  UserList(
      {required this.imageUrl,
      required this.userName,
      required this.recentText,
      required this.onTap});
}
