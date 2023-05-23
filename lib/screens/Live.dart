import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Live extends StatefulWidget {
  const Live({super.key});

  @override
  State<Live> createState() => _LiveState();
}

class _LiveState extends State<Live> {
  bool isBeautyOn = false;
  int timer = 0;
  final List<String> _iconPath = <String>[
    "assets/icons/timer3.png",
    "assets/icons/Timer5.png"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Image.asset(
            "assets/images/selfie.jpg",
            width: 375.w,
            height: 812.h,
            fit: BoxFit.cover,
          ), //Should make this into camera video
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 375.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              blurRadius: 50.r,
                              offset: Offset(0, 0.33))
                        ]),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              size: 25.h,
                              color: Colors.white,
                            )),
                      ),
                      Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              blurRadius: 70.r,
                              offset: Offset(0, 0.33))
                        ]),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                        Icons.flip_camera_android_outlined,
                                        size: 25.h,
                                        color: Colors.white)),
                                Text(
                                  "Flip",
                                  style: GoogleFonts.roboto(
                                      fontSize: 15.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 18.h,
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isBeautyOn = !isBeautyOn;
                                    });
                                  },
                                  child: Image.asset(
                                    (isBeautyOn)
                                        ? "assets/icons/BeautyOn.png"
                                        : "assets/icons/BeautyOff.png",
                                    height: 20.h,
                                    width: 20.h,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "Beauty",
                                  style: GoogleFonts.roboto(
                                      fontSize: 15.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 18.h,
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Image.asset(
                                    "assets/icons/Filters.png",
                                    height: 20.h,
                                    width: 20.h,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "Filters",
                                  style: GoogleFonts.roboto(
                                      fontSize: 15.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 18.h,
                            ),
                            Column(
                              children: [
                                (timer == 0)
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            timer++;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.timer_off_outlined,
                                          size: 25.h,
                                          color: Colors.white,
                                        ))
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (timer != 2) {
                                              timer++;
                                            } else {
                                              timer = 0;
                                            }
                                          });
                                        },
                                        child: Image.asset(
                                          _iconPath[timer - 1],
                                          height: 20.h,
                                          width: 20.h,
                                        ),
                                      ),
                                SizedBox(
                                  height: (timer == 0) ? 0 : 5.h,
                                ),
                                Text(
                                  "Timer",
                                  style: GoogleFonts.roboto(
                                      fontSize: 15.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.flash_off_sharp,
                                      color: Colors.white,
                                      size: 25.h,
                                    )),
                                Text(
                                  "Flash",
                                  style: GoogleFonts.roboto(
                                      fontSize: 15.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  child: SizedBox(
                    height: 50.h,
                    width: 200.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(const Color(0xFF00E9F7))),
                      child: Text(
                        "Go Live",
                        style: GoogleFonts.roboto(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      )),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: Colors.black,
        child: Container(
          height: 50.h,
          padding: EdgeInsets.only(top: 15.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  child: Text(
                "15s",
                style: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              )),
              SizedBox(width: 30.w),
              GestureDetector(
                  child: Text(
                "30s",
                style: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              )),
              SizedBox(width: 30.w),
              Column(
                children: [
                  Text(
                    "Live",
                    style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Icon(
                    Icons.circle,
                    size: 5.h,
                    color: Colors.white,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
