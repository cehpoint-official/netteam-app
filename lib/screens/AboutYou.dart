import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../main.dart';
import 'Followers-FollowinfDetails.dart';

class AboutYou extends StatelessWidget {
  const AboutYou({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = Provider.of<MyDataContainer>(context,listen: false).name;
    final dataContainer = Provider.of<MyDataContainer>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xFF0E0B1F),
        leading: IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
            size: 20.h,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
        automaticallyImplyLeading: false,
        title: Text(
          name,
          style: GoogleFonts.roboto(
              fontSize: 17.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                dataContainer.updateData("", "", "","", "", "", []);
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 20.h,
              ))
        ],
      ),
      body: Body(),
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
                  Navigator.pushNamed(context, "/create");
                },
              ),
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.chat_bubble,
                        size: 30.h, color: const Color(0xFFFFFFFF))),
                onTap: () {
                  //Navigate to chat
                  Navigator.pushNamed(context, "/chatlist");
                },
              ),
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.account_circle,
                        size: 30.h, color: const Color(0xFF1EA7D7))),
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

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  PageController pageController = PageController(initialPage: 0);
  int pageIndex = 0;
  List<dynamic> posts = [];
  List<dynamic> saved = [];
  List<dynamic> followers = [];
  List<dynamic> following = [];
  late String id,userId,profilePic;
  String? baseUrl = dotenv.env['BACKEND_URL'];

  Future<void> getPostsAndSaved() async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/getPostsAndSaved";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String,dynamic>{
            "userId": id,
            "reqId": id,
          })
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          posts.addAll(data["postsInfo"]);
          saved.addAll(data["savedInfo"]);
          followers.addAll(data["followersInfo"]);
          following.addAll(data["followingInfo"]);
        });
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = Provider.of<MyDataContainer>(context,listen: false).id;
    userId = Provider.of<MyDataContainer>(context,listen: false).userId;
    profilePic = Provider.of<MyDataContainer>(context,listen: false).profilePic;
    getPostsAndSaved();
  }

  _getImageProvider() {
    return profilePic != ""
        ? NetworkImage('${dotenv.env['BACKEND_URL']}/$profilePic')
        : const AssetImage("assets/images/avatar.jpg");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                    radius: 48.r,
                    backgroundImage: _getImageProvider(),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  '@$userId',
                  style: GoogleFonts.roboto(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context) => FollowersFollowing(fancyId: userId,followers: followers,following: following)
                            )
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            following.length.toString(),
                            style: GoogleFonts.roboto(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "Following",
                            style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context) => FollowersFollowing(fancyId: userId,followers: followers,following: following)
                            )
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            followers.length.toString(),
                            style: GoogleFonts.roboto(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "Followers",
                            style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Column(
                      children: [
                        Text(
                          posts.length.toString(),
                          style: GoogleFonts.roboto(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          "Posts",
                          style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.r)),
                          border: Border.all(color: Colors.white, width: 1)),
                      height: 36.h,
                      width: 150.w,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0.0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Text("Edit Profile"),
                        onPressed: () {
                          Navigator.pushNamed(context, "/profile");
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Container(
            height: 40.h,
            decoration: const BoxDecoration(
                border: Border.symmetric(
                    horizontal:
                        BorderSide(color: Color(0xFFD0D1D3), width: 1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  (pageIndex == 0)
                      ? "assets/icons/posts_white.png"
                      : "assets/icons/posts_grey.png",
                  height: 15.h,
                  width: 15.h,
                ),
                Image.asset(
                  (pageIndex == 1)
                      ? "assets/icons/private_white.png"
                      : "assets/icons/private_grey.png",
                  height: 20.h,
                  width: 20.h,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.h),
            width: double.maxFinite,
            height: double.maxFinite,
            child: PageView(
                onPageChanged: (i) {
                  setState(() {
                    pageIndex = i;
                  });
                },
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      scrollDirection: Axis.vertical,
                      children: List.generate(posts.length, (index) {
                        return AspectRatio(
                          aspectRatio: 5 / 3,
                          child: Container(
                            color: Colors.grey,
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl: '$baseUrl/${posts[index]["thumbnailUrl"]}', // Replace with the actual image URL
                                placeholder: (context, url) => CircularProgressIndicator(), // Optional loading placeholder
                                errorWidget: (context, url, error) => Icon(Icons.error), // Optional error widget
                                fit: BoxFit.cover, // Adjust the image fit
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      shrinkWrap: true,
                      children: List.generate(saved.length, (index) {
                        return Container(
                          color: Colors.grey,
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl: '$baseUrl/${saved[index]["thumbnailUrl"]}', // Replace with the actual image URL
                              placeholder: (context, url) => CircularProgressIndicator(), // Optional loading placeholder
                              errorWidget: (context, url, error) => Icon(Icons.error), // Optional error widget
                              fit: BoxFit.cover, // Adjust the image fit
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ]),
          ),
        ],
      ),
    ));
  }
}
