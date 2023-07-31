import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../main.dart';

class ApiService {
  static String? baseUrl = dotenv.env['BACKEND_URL'];

  Future<List<dynamic>> fetchReels(String userId) async {
    final response = await http.post(Uri.parse('$baseUrl/reels'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(<String,dynamic>{
          "userId": userId,
        })
    );
    if (response.statusCode == 200) {
      // print(response.body);
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch reels');
    }
  }
}


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class ScreenArguments {
  final bool isLiked;
  ScreenArguments({required this.isLiked});
}

class _HomeState extends State<Home> {
  final PageController _controller = PageController(viewportFraction: 1);
  bool isShared = false;
  late String reelId;
  late String id;

  final apiService = ApiService();
  List<dynamic> reels = [];
  Future<void> fetchReels() async {
    final fetchedReels = await apiService.fetchReels(id);
    setState(() {
      reels = fetchedReels;
    });
  }

  late ChewieController _chewierController;
  int _currentPlayingIndex = 0;

  @override
  void initState() {
    super.initState();
    id = Provider.of<MyDataContainer>(context,listen: false).id;
    fetchReels();
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'System Response',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _chewierController.dispose();
    // _videoController.dispose();
    super.dispose();
  }

  Future<void> likeButtonPressed(bool isLiked) async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/like";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String,dynamic>{
            "videoId": reelId,
            "userId": id,
            "likedStatus": isLiked,
          })
      );

      if (response.statusCode == 200) {
        return;
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

  Future<void> savedButtonPressed(bool isSaved) async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/save";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String,dynamic>{
            "videoId": reelId,
            "userId": id,
            "savedStatus": isSaved,
          })
      );

      if (response.statusCode == 200) {
        return;
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              GestureDetector(
                // onDoubleTap: () {
                //   setState(() {
                //     isLiked = !isLiked;
                //   });
                // },
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: _controller,
                  itemCount: reels.length,
                  itemBuilder: (context, index) {
                    final reel = reels[index];
                    final videoUrl = '${ApiService.baseUrl}/${reel['videoUrl']}';
                    final thumbnailUrl = '${ApiService.baseUrl}/${reel['thumbnailUrl']}';

                    VideoPlayerController _videoController = VideoPlayerController.network(videoUrl);
                    _chewierController = ChewieController(
                      videoPlayerController: _videoController,
                      aspectRatio: _videoController.value.aspectRatio,
                      autoPlay: false,
                      // showControls: false,
                      looping: false,
                      // placeholder: isVideoLoaded ? null : const Center(
                      //     child: CircularProgressIndicator()
                      // ),
                    );

                    return FutureBuilder<void>(
                      future: VideoPlayerController.network(videoUrl).initialize(),
                      builder: (context, snapshot) {
                        final isVideoLoaded = snapshot.connectionState == ConnectionState.done;
                        reelId = reel["_id"];
                        // isLiked = reel["likedStatus"];
                        // isSaved = reel["savedStatus"];

                        if (index != _currentPlayingIndex) {
                          _videoController.pause();
                          _chewierController.pause();
                          _currentPlayingIndex = index;
                        }

                        return Container(
                          // padding: EdgeInsets.fromLTRB(24, 10, 10, 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(isVideoLoaded ? videoUrl : thumbnailUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                          children: [
                            Chewie(
                              controller: _chewierController,
                            ),
                            Column(
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
                                                )
                                                // reel["profilePic"] != ""
                                                //     ? Image.network(
                                                //       '${dotenv.env['BACKEND_URL']}/${reel["profilePic"]}',
                                                //       fit: BoxFit.cover,
                                                //     )
                                                //     : Image.asset(
                                                //       "assets/images/avatar.jpg",
                                                //   fit: BoxFit.cover,
                                                // ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Text(
                                              '@${reel["authorName"]}',
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.sp,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 280.w,
                                            child: Text(
                                              reel["description"],
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
                                                      likeButtonPressed(reel["likedStatus"]).then((_) => {
                                                        setState(() {
                                                          if(reel["likedStatus"]){
                                                            reel["likedStatus"] = false;
                                                            reel["likesCount"] -= 1;
                                                          }else {
                                                            reel["likedStatus"] = true;
                                                            reel["likesCount"] += 1;
                                                          }
                                                        })
                                                      });
                                                  },
                                                  icon: Icon(
                                                    reel["likedStatus"]
                                                        ? CupertinoIcons.heart_fill
                                                        : CupertinoIcons.heart,
                                                    size: 30.h,
                                                    color: Colors.white,
                                                  )
                                              ),
                                              Text(
                                                reel["likesCount"].toString(),
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
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        backgroundColor:
                                                        Colors.transparent,
                                                        builder: (BuildContext context) {
                                                          return CommentSection(reelId: reelId);
                                                        });
                                                  },
                                                  child: Image.asset(
                                                    "assets/icons/comment.png",
                                                    height: 30.h,
                                                    width: 30.h,
                                                  )
                                              ),
                                              Text(
                                                reel["commentsCount"].toString(),
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
                                                      savedButtonPressed(reel["savedStatus"]).then((_) => {
                                                        setState(() {
                                                          if(reel["savedStatus"]){
                                                            reel["savedStatus"] = false;
                                                            reel["savedByCount"] -= 1;
                                                          }else {
                                                            reel["savedStatus"] = true;
                                                            reel["savedByCount"] += 1;
                                                          }
                                                        })
                                                      });
                                                    });
                                                  },
                                                  icon: Icon(
                                                    reel["savedStatus"]
                                                        ? Icons.bookmark
                                                        : Icons.bookmark_outline,
                                                    size: 30.h,
                                                    color: Colors.white,
                                                  )
                                              ),
                                              Text(
                                                reel["savedByCount"].toString(),
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
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ])
                        );
                      },
                    );
                  }
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
                    // Navigator.pop(context);
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
                    // Navigator.pop(context);
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
                    // Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/create");
                    showAlertDialog(context, "This Feature is Under Development");
                  },
                ),
                GestureDetector(
                  child: SizedBox(
                      height: 40.h,
                      child: Icon(Icons.chat_bubble,
                          size: 30.h, color: const Color(0xFFFFFFFF))),
                  onTap: () {
                    //Navigate to chat
                    // Navigator.pop(context);
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
                    // Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/aboutyou");
                  },
                ),
              ],
            ),
          ),
        )
    );
  }
}



//Class for Comment
class Comment {
  String commentId;
  String imageUrl;
  String userName;
  String comment;
  int noOfLikes;
  bool isLiked;
  Comment(
      {required this.commentId,
        required this.imageUrl,
      required this.userName,
      required this.comment,
      this.noOfLikes = 0,
      this.isLiked = false});
}

class CommentSection extends StatefulWidget {
  const CommentSection({Key? key,required this.reelId}) : super(key: key);
  final String reelId;

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final List<Comment> _commentList = <Comment>[];
  late String id,name,profilePic,userId;

  TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> postComment() async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/postComment";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String,dynamic>{
            "videoId": widget.reelId,
            "author": id,
            "comment": _textEditingController.text
          })
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _commentList.add(Comment(
            commentId: data,
            imageUrl: profilePic != "" ? '${dotenv.env['BACKEND_URL']}/$profilePic' : "assets/images/avatar.jpg",
            userName: userId,
            comment: _textEditingController.text,
            noOfLikes: 0,
            isLiked: false,
          ));
        });
        _textEditingController.text = '';
        FocusScope.of(context).unfocus();
        _scrollToBottom();
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

  void addComment() {
    if (_textEditingController.text != '') {
      postComment();
    }
  }

  Future<void> getComments() async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/getComments";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String,dynamic>{
            "videoId": widget.reelId,
            "userId": id,
          })
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          data.forEach((comment) {
            _commentList.add(Comment(
              commentId: comment["_id"],
              imageUrl: comment["profilePic"] != "" ? '${dotenv.env['BACKEND_URL']}/${comment["profilePic"]}' : "assets/images/avatar.jpg",
              userName: comment["authorName"],
              comment: comment["comment"],
              noOfLikes: comment["likesCount"],
              isLiked: comment["likedStatus"],
            ));
          });
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
    name = Provider.of<MyDataContainer>(context,listen: false).name;
    userId = Provider.of<MyDataContainer>(context,listen: false).userId;
    profilePic = Provider.of<MyDataContainer>(context,listen: false).profilePic;
    getComments();
  }

  Future<void> likeComment(String commentId, bool isLiked) async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/likeComment";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String,dynamic>{
            "videoId": widget.reelId,
            "commentId": commentId,
            "userId": id,
            "likedStatus": isLiked,
          })
      );

      if (response.statusCode == 200) {
        return;
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

  _getImageProvider(Comment comment) {
    return Uri.parse(comment.imageUrl).isAbsolute
        ? NetworkImage(comment.imageUrl)
        : AssetImage(comment.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
          color: const Color(0xFF101010)),
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Comments',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _commentList.length,
              itemBuilder: ((BuildContext context, int index) {
                Comment _comment = _commentList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: _getImageProvider(_comment),
                    radius: 20.r,
                  ),
                  title: Text("@${_comment.userName}"),
                  subtitle: Text(_comment.comment),
                  trailing: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          likeComment(_commentList[index].commentId,_commentList[index].isLiked).then((_) {
                            setState(() {
                              if (_commentList[index].isLiked) {
                                _commentList[index].noOfLikes--;
                              } else {
                                _commentList[index].noOfLikes++;
                              }
                              _commentList[index].isLiked = !_commentList[index].isLiked;
                            });
                          });
                        },
                        child: Icon(
                          _comment.isLiked
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: Colors.white,
                          size: 20.h,
                        ),
                      ),
                      Text("${_comment.noOfLikes}")
                    ],
                  ),
                );
              }),
            ),
          ),
          Container(
            height: 50.h,
            width: 350.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.h),
              borderRadius: BorderRadius.circular(25.r),
              color: const Color(0xFF101010),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                    controller: _textEditingController,
                    onSubmitted: (val) {
                      addComment();
                    },
                    decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            color: const Color(0xFFB6B7B8),
                            fontWeight: FontWeight.bold),
                        border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent))),
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
                      addComment();
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
    );
  }
}
