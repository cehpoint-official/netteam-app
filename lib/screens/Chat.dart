import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Chat extends StatelessWidget {
  static const String name = "Aswin Raaj";
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A172E),
        centerTitle: true,
        title: Text(
          name,
          style: GoogleFonts.nunito(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white),
        ),
        bottom: PreferredSize(
            preferredSize: Size(double.infinity, 50.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.phone_iphone_rounded,
                          size: 20.h,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          //Activate the request
                        },
                      ),
                      Text(
                        "Exchange Numbers",
                        style: GoogleFonts.roboto(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //Navigate to profile
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF3A1398))),
                    child: Text(
                      "View Profile",
                      style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.share_outlined,
                size: 20.h,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                size: 20.h,
              )),
        ],
      ),
      body: Body(),
    );
  }
}

class ChatMessage {
  int userID;
  String text;
  ChatMessage({required this.userID, required this.text});
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final int userID = 2; // Should take from the cookies
  final String user1Number = "+91 9239239230";
  final String user2Number = "+91 678678678";

  bool isRequestVisible = false;

  final List<ChatMessage> _chatList = <ChatMessage>[
    ChatMessage(
        userID: 1,
        text:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt "),
    ChatMessage(
        userID: 2,
        text:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt "),
    ChatMessage(
        userID: 1,
        text:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt "),
    ChatMessage(
        userID: 2,
        text:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt "),
  ];

  TextEditingController _textEditingController = TextEditingController();

  void addText() {
    if (_textEditingController.text != '') {
      setState(() {
        _chatList
            .add(ChatMessage(userID: 2, text: _textEditingController.text));
      });
      _textEditingController.text = '';
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 10.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isRequestVisible
                ? Center(
                    child: Container(
                      height: 90.h,
                      width: 245.w,
                      margin: EdgeInsets.only(top: 15.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: const Color(0xFF262228),
                      ),
                      padding: EdgeInsets.all(9.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Aswin Raaj has requested for phone number exchange ?",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _chatList.add(ChatMessage(
                                        userID: 2,
                                        text:
                                            "Sorry, I can't share my number"));
                                  });
                                  isRequestVisible = !isRequestVisible;
                                },
                                child: Container(
                                    height: 25.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFE91C43),
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                    child: Center(
                                      child: Text(
                                        "Deny",
                                        style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    List<ChatMessage> _contactAdd =
                                        <ChatMessage>[
                                      ChatMessage(
                                          userID: 1,
                                          text:
                                              "Person X number : ${user2Number}"),
                                      ChatMessage(
                                          userID: 2,
                                          text:
                                              "Aswin Raaj number : ${user1Number}")
                                    ];
                                    _chatList.addAll(_contactAdd);
                                  });
                                  isRequestVisible = !isRequestVisible;
                                },
                                child: Container(
                                    height: 25.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF2B8C52),
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                    child: Center(
                                      child: Text(
                                        "Accept",
                                        style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0.h,
                  ),
            SizedBox(
              height: isRequestVisible ? 505.h : 610.h,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _chatList.length,
                  itemBuilder: (BuildContext context, int index) {
                    ChatMessage chatMessage = _chatList[index];
                    return Row(
                      mainAxisAlignment: (userID == chatMessage.userID)
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          //For Demonstration purpose of mocking that other person requested for Exchange number. Will be removed in the production
                          onTap: () {
                            setState(() {
                              isRequestVisible = !isRequestVisible;
                            });
                          },
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 270.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: (userID == chatMessage.userID)
                                  ? const Color(0xFF272A35)
                                  : const Color(0xFF1A172E),
                            ),
                            padding: EdgeInsets.all(10.h),
                            margin: EdgeInsets.fromLTRB(
                                0, (index == 0 ? 15.h : 7.5.h), 0, 7.5.h),
                            child: Text(
                              chatMessage.text,
                              style: GoogleFonts.roboto(
                                  fontSize: 13.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            Container(
              height: 50.h,
              width: 350.w,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: const Color(0xFF1A172E),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      maxLengthEnforcement: MaxLengthEnforcement.none,
                      controller: _textEditingController,
                      onSubmitted: (val) {
                        addText();
                      },
                      decoration: InputDecoration(
                          hintText: 'Type a Message',
                          hintStyle: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              color: const Color(0xFFB6B7B8),
                              fontWeight: FontWeight.bold),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color.fromRGBO(0, 0, 0, 0)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent))),
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  VerticalDivider(
                    color: const Color(0xFFB6B7B8),
                    width: 1.h,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  IconButton(
                      onPressed: () {
                        addText();
                      },
                      icon: Icon(
                        Icons.send_outlined,
                        size: 20.h,
                        color: const Color(0xFF491BBA),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
