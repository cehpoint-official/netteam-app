import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class ScreenArguments {
  final bool isLiked;
  ScreenArguments({required this.isLiked});
}

class _HomeState extends State<Home> {
  final List<String> _imagePath = [
    "assets/images/tiktok_image.png",
    "assets/images/tiktok_image.png",
    "assets/images/tiktok_image.png",
  ];
  final PageController _controller = PageController(viewportFraction: 1);
  bool isLiked = false;
  bool isSaved = false;
  bool isShared = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: _controller,
                  itemCount: _imagePath.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(24, 10, 10, 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            _imagePath[index],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 230.h,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Image.asset(
                                            "assets/images/profile_pic.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text(
                                          "@iamaswin",
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.sp,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 290.w,
                                      child: Text(
                                        "Spinning through the city of angels: LA's iconic roundabout takes traffic for a whirl",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isLiked = !isLiked;
                                              });
                                            },
                                            icon: Icon(
                                              isLiked
                                                  ? CupertinoIcons.heart_fill
                                                  : CupertinoIcons.heart,
                                              size: 30.h,
                                              color: Colors.white,
                                            )),
                                        Text(
                                          "31K",
                                          style: GoogleFonts.roboto(
                                              fontSize: 12.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10.h,),
                                        GestureDetector(
                                          onTap: () {
                                            
                                          },
                                          child: Image.asset("assets/icons/comment.png", height: 30.h, width: 30.h,)),
                                        Text(
                                          "2K",
                                          style: GoogleFonts.roboto(
                                              fontSize: 12.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isSaved = !isSaved;
                                              });
                                            },
                                            icon: Icon(
                                              isSaved
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_outline,
                                              size: 30.h,
                                              color: Colors.white,
                                            )),
                                        Text(
                                          "4K",
                                          style: GoogleFonts.roboto(
                                              fontSize: 12.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [

                                        SizedBox(height: 5.h,),
                                        GestureDetector(
                                          onTap: () {
                                            
                                          },
                                          child: Image.asset("assets/icons/share.png", height: 30.h, width: 30.h,)),
                                        Text(
                                          "5K",
                                          style: GoogleFonts.roboto(
                                              fontSize: 12.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(24, 10, 0, 0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 50,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Text(
                  "Net Team",
                  style: GoogleFonts.roboto(
                      fontSize: 25.sp,
                      color: const Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        backgroundColor: const Color(0xFF0E0B1F),
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
                          size: 30.h, color: const Color(0xFF1EA7D7))),
                  onTap: () {
                    //Navigate to Home
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
                  },
                ),
                GestureDetector(
                  child: SizedBox(
                      height: 40.h,
                      child: Icon(Icons.chat_bubble,
                          size: 30.h, color: const Color(0xFFFFFFFF))),
                  onTap: () {
                    //Navigate to chat
                    Navigator.pushNamed(context, "/chat");
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
        ));
  }
}
