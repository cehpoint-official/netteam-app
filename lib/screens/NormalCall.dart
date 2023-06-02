import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NormalCall extends StatefulWidget {
  const NormalCall({super.key});

  @override
  State<NormalCall> createState() => _NormalCallState();
}

class _NormalCallState extends State<NormalCall> {
  late CameraController controller;
  int cameraIndex = 1;

  //For Camera
  Future<void> accessCam() async {
    final _cameras = await availableCameras();
    controller = CameraController(_cameras[cameraIndex], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  Duration remainingDuration = Duration(seconds: 60);
  bool isConnected = false;
  int _imageIndex = 0;
  final List<String> _imagePaths = <String>[
    'assets/images/profile1.png',
    'assets/images/profile2.png',
    'assets/images/profile3.png',
    'assets/images/profile4.png',
    'assets/images/profile5.png',
    'assets/images/profile6.png',
    'assets/images/profile7.png',
    'assets/images/profile8.png',
    'assets/images/profile9.png',
    'assets/images/profile10.png',
  ];
  late Timer _timer;
  late Timer _timer1;

  @override
  void initState() {
    super.initState();
    accessCam();
    startTimer();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (Timer timer) {
      if (_imageIndex < _imagePaths.length - 1) {
        setState(() {
          _imageIndex++;
        });
      } else {
        _timer.cancel();
        setState(() {
          isConnected = true;
        });
      }
    });
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer1 = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (remainingDuration.inSeconds < 1) {
            _timer1.cancel();
          } else {
            remainingDuration = remainingDuration - oneSec;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getRemainingSeconds(Duration d) {
    if (d.inSeconds == 60) {
      return "00";
    } else if (d.inSeconds < 10) {
      return "0${d.inSeconds}";
    } else {
      return "${d.inSeconds}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onDoubleTap: () async {
          await controller.dispose();
          setState(() {
            cameraIndex = (cameraIndex == 0) ? 1 : 0;
            accessCam();
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    alignment: isConnected ? null : Alignment.center,
                    height: 375.h,
                    width: 390.w,
                    color: const Color(0xFF616161),
                    child: isConnected
                        ? Image.asset(
                            "assets/images/connected.png",
                            fit: BoxFit.cover,
                          )
                        : SizedBox(
                            height: 100.h,
                            child: CircleAvatar(
                              radius: 50.r,
                              backgroundImage: AssetImage(
                                _imagePaths[_imageIndex],
                              ),
                            ),
                          ),
                  ),
                  Container(
                      height: 375.h,
                      width: 390.w,
                      color: const Color(0xFF616161),
                      child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: CameraPreview(controller))),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 35.h, left: 13.w),
                height: 30.h,
                width: 60.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: const Color(0xFF212E36).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20.r)),
                child: SizedBox(
                  width: 40.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.videocam,
                        color: const Color(0xFFE91C43),
                        size: 15.h,
                      ),
                      Text(
                          "${remainingDuration.inMinutes}:${getRemainingSeconds(remainingDuration)}")
                    ],
                  ),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(25.w, 5.h, 25.w, 10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r)),
                      color: const Color(0xFF212E36),
                    ),
                    height: 100.h,
                    width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.keyboard_arrow_up_outlined,
                            color: Colors.white),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle extend 5 mins
                              },
                              child: SvgPicture.asset(
                                "assets/images/extends.svg",
                                height: 55.h,
                                width: 55.h,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                //Handle Chat Request
                              },
                              child: SvgPicture.asset(
                                "assets/images/chatRequest.svg",
                                height: 55.h,
                                width: 55.h,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                //Handle End Call
                              },
                              child: SvgPicture.asset(
                                "assets/images/endCall.svg",
                                height: 55.h,
                                width: 55.h,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
