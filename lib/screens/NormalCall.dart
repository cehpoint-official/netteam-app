import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';

class NormalCall extends StatefulWidget {
  const NormalCall({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<NormalCall> createState() => _NormalCallState();
}

class _NormalCallState extends State<NormalCall> {
  MediaStream? _localStream;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peer;
  // 'https://netteam-backend-production.up.railway.app/'
  IO.Socket socket = IO.io('http://localhost:3000',<String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  // final Completer<void> completer = Completer<void>();
  final configuration = <String, dynamic>{
    'iceServers': [
      {'url': 'stun:stun3.l.google.com:19302'},
    ],
  };

  //For Camera
  // Future<void> accessCam() async {
  //   // final _cameras = await availableCameras();
  //   controller = CameraController(widget.cameras[cameraIndex], ResolutionPreset.max);
  //   controller.initialize().then((_) {
  //     if (!mounted) { return; }
  //     setState(() {});
  //   }).catchError((Object e) {
  //     if (e is CameraException) {
  //       switch (e.code) {
  //         case 'CameraAccessDenied':
  //           // Handle access errors here.
  //           break;
  //         default:
  //           // Handle other errors here.
  //           break;
  //       }
  //     }
  //   });
  // }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    await getUserMedia();
    socket.connect();
    rtcConnection().then((pc) {
      _peer = pc;
    });
  }

  Future<void> getUserMedia() async {
    final videoConstraints = <String, dynamic>{
      'facingMode': 'user', // Select the front camera
    };
    final audioConstraints = <String, dynamic>{
      'echoCancellation': true,
    };
    final constraints = <String, dynamic>{
      'audio': audioConstraints,
      'video': videoConstraints,
    };
    try {
      final stream = await navigator.mediaDevices.getUserMedia(constraints);
      if (_localStream != null) {
        // Dispose previous stream and tracks
        _localStream!.getTracks().forEach((track) {
          track.stop();
        });
        _localStream!.dispose();
      }

      _localRenderer.srcObject = stream;
      if (!mounted) { return; }
      setState(() {
        _localStream = stream;
      });
      print(_localStream);
    } catch (e) {
      print(e.toString());
    }
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
  late String otherSid;
  bool isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    initRenderers();
    socket.on('create',(userID) async {
      print('Connected as $userID');
      socket.emit('startChat');
    });
    socket.on('chatMatched',(data) {
      otherSid = data['to'];
      sendOffer(data['to']);
    });
    socket.on('chatError',(data) {
      print(data);
    });
    socket.on("ice-candidate", (data) async {
      // print(data);
      final Map<String, dynamic> msg = jsonDecode(data['candidate']);
      // print(msg);
      final sid = data['sourceSocketID'];
      // data.remove('sourceSocketID');
      print('heard an ice');
      await _peer!.addCandidate(RTCIceCandidate(msg['candidate'],msg['sdpMid'],msg['sdpMLineIndex']));
    });
    socket.on("call-made", (data) async {
      final Map<String, dynamic> msg = jsonDecode(data['offer']);
      final sid = data['sourceSocketID'];
      otherSid = sid;
      print("source socket $sid");
      // data.remove('sourceSocketID');
      // _peer = await rtcConnection();
      await _peer!.setRemoteDescription(RTCSessionDescription(msg['sdp'], msg['type']));
      sendAnswer(sid);
      isConnected = true;
    });
    socket.on("answer-made", (data) async {
      final Map<String, dynamic> msg = jsonDecode(data['answer']);
      final sid = data['sourceSocketID'];
      // data.remove('sourceSocketID');
      try {
        await _peer!.setRemoteDescription(RTCSessionDescription(msg['sdp'], msg['type']));
      }catch(e){
        print(e.toString());
      }
      isConnected = true;
    });
    socket.on('ask-increment',(_) async {
      bool? data = await showConfirmationDialog(context,'Connection is offering a 5 min extension. \nDo you confirm?');
      if(data!){
        remainingDuration = Duration(seconds: 300 + remainingDuration.inSeconds);
      }
      showAlertDialog(context,'Response Sent Successfully!');
      socket.emit('reply-increment',data);
    });
    socket.on('reply-increment',(data) {
      if(data){
        remainingDuration = Duration(seconds: 300 + remainingDuration.inSeconds);
      }
      String message = data ? 'Offer accepted!' : 'Offer rejected!';
      showAlertDialog(context, message);
      isButtonDisabled = false;
    });
    socket.on("hangup",(_) {
      print('disconnected');
      Navigator.pop(context, "/videoset");
    });

    // CameraPreview(controller);
    _timer = Timer.periodic(const Duration(milliseconds: 300), (Timer timer) {
      if (!isConnected) {
        if (!mounted) { return; }
        setState(() {
          if(_imageIndex == _imagePaths.length-1) {
            _imageIndex = 0;
          }
          _imageIndex++;
        });
      }
      else {
        if (!mounted) { return; }
        setState(() {
          _timer.cancel();
          startTimer();
        });
      }
    });
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer1 = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (remainingDuration.inSeconds < 1) {
            _timer1.cancel();
            Navigator.pop(context, "/videoset");
          } else {
            remainingDuration = remainingDuration - oneSec;
          }
        },
      ),
    );
  }

  String getRemainingSeconds(Duration d) {
    if (d.inSeconds%60 == 60) {
      return "00";
    } else if (d.inSeconds%60 < 10) {
      return "0${d.inSeconds%60}";
    } else {
      return "${d.inSeconds%60}";
    }
  }
  String getRemainingMinutes(Duration d) {
    if (d.inMinutes < 10) {
      return "0${d.inMinutes}";
    } else {
      return "${d.inMinutes}";
    }
  }

  void _toggleCamera() async {

    if (widget.cameras.length < 2) {
      return; // No other camera available
    }

    final currentCamera = _localStream?.getVideoTracks()[0].getSettings()['facingMode'];
    final newCamera = (currentCamera == 'user') ? 'environment' : 'user';

    final videoConstraints = <String, dynamic>{
      'facingMode': newCamera,
    };
    final audioConstraints = <String, dynamic>{
      'echoCancellation': false,
    };

    try {
      final stream = await navigator.mediaDevices.getUserMedia({
        'audio': audioConstraints,
        'video': videoConstraints,
      });
      if (_localStream != null) {
        // Dispose previous stream and tracks
        _localStream!.getTracks().forEach((track) {
          track.stop();
        });
        _localStream!.dispose();
      }
      _localRenderer.srcObject = stream;
      if (!mounted) { return; }
      setState(() {
        _localStream = stream;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void sendOffer(String sid) async {
    print('Send offer');
    try {
      final offerConstraints = <String, dynamic>{
        'offerToReceiveAudio': true,
        'offerToReceiveVideo': true
      };
      final offer = await _peer?.createOffer(offerConstraints);
      await _peer?.setLocalDescription(offer!);
      print('offer Local description set');

      socket.emit("call-user", jsonEncode(<String, dynamic>{
        "offer": jsonEncode(<String, dynamic>{
          'type': offer?.type,
          'sdp': offer?.sdp,
        }),
        "targetSocketID": sid,
      }));
    } catch (e) {
      print('Send offer failed: $e');
    }
  }

  void sendAnswer(String sid) async {
    print('Send answer');
    try {
      final answerConstraints = <String, dynamic>{
        'offerToReceiveAudio': true,
        'offerToReceiveVideo': true,
      };
      final answer = await _peer?.createAnswer(answerConstraints);
      await _peer?.setLocalDescription(answer!);
      print('answer Local description set');

      socket.emit("make-answer", jsonEncode(<String, dynamic>{
        "answer": jsonEncode(<String, dynamic>{
          'type': answer?.type,
          'sdp': answer?.sdp,
        }),
        "targetSocketID": sid,
      }));
    } catch (e) {
      print('Send answer failed: $e');
    }
  }

  Future<bool?> showConfirmationDialog(BuildContext context, String message) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return "No"
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return "Yes"
              },
            ),
          ],
        );
      },
    );
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('System Response'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<RTCPeerConnection> rtcConnection() async {
    final constraints = <String, dynamic>{
      'mandatory': {
        'offerToReceiveAudio': true,
        'offerToReceiveVideo': true,
      },
      'optional': [{'DtlsSrtpKeyAgreement': true}],
    };
    RTCPeerConnection pc = await createPeerConnection(configuration,constraints);

    pc.onIceCandidate = (candidate) {
      print('hello');
      socket.emit("ice-candidate", jsonEncode(<String, dynamic>{
        "targetSocketID": otherSid,
        "candidate": jsonEncode(<String, dynamic>{
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        }),
      }));
    };

    pc.onAddStream = (stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
      print("remote stream added");
    };

    _localStream?.getTracks().forEach((track) {
      pc.addTrack(track,_localStream!);
    });

    print('PeerConnection created');
    return pc;
  }

  @override
  void dispose() async {
    if(isConnected){
      _timer1.cancel();
    }
    isConnected = false;
    // socket.disconnect();
    socket.dispose();
    _remoteRenderer.dispose();
    _localRenderer.dispose();
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        track.stop();
      });
    }
    _localStream!.dispose();
    _peer?.dispose();
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onDoubleTap: () async {
          _toggleCamera();
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
                        ? RTCVideoView(
                            _remoteRenderer,
                            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
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
                      child: RTCVideoView(
                            _localRenderer,
                            mirror: true,
                            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
                  ),
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
                  width: 50.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.videocam,
                        color: const Color(0xFFE91C43),
                        size: 15.h,
                      ),
                      Text(
                          "${getRemainingMinutes(remainingDuration)}:${getRemainingSeconds(remainingDuration)}")
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
                              onTap: isButtonDisabled ? null : () {
                                // Handle extend 5 mins
                                socket.emit('ask-increment');
                                isButtonDisabled = true;
                                showAlertDialog(context, 'Offer Sent Successfully!');
                              },
                              child: Opacity(
                                opacity: isButtonDisabled ? 0.5 : 1.0,
                                child: SvgPicture.asset(
                                  "assets/images/extends.svg",
                                  height: 55.h,
                                  width: 55.h,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                //Handle Chat Request
                                Navigator.pushNamed(context, "/chat");
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
                                // socket.disconnect();
                                Navigator.pop(context, "/videoset");
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
