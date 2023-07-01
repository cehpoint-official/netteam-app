import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netteam/screens/AboutYou.dart';
import 'package:netteam/screens/Chat.dart';
import 'package:netteam/screens/Chatlist.dart';
import 'package:netteam/screens/ForgotPassword.dart';
import 'package:netteam/screens/Home.dart';
import 'package:netteam/screens/Interests.dart';
import 'package:netteam/screens/Live.dart';
import 'package:netteam/screens/PricingPlans.dart';
import 'package:netteam/screens/Profile.dart';
import 'package:netteam/screens/ResetPassword.dart';
import 'package:netteam/screens/Verify.dart';
import 'package:netteam/screens/Video15.dart';
import 'package:netteam/screens/Video3m.dart';
import 'package:netteam/screens/Video60.dart';
import 'package:netteam/screens/VideoSet.dart';
import 'package:netteam/screens/CreateVideo.dart';
import 'package:netteam/screens/login.dart';
import 'package:netteam/screens/signup.dart';
import 'package:netteam/screens/splashscreen.dart';
import 'package:netteam/screens/videoCall.dart';
import 'package:netteam/screens/CreateVideo.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MyDataContainer extends ChangeNotifier {
  String id = "";

  void updateData(String newValue) {
    id = newValue;
    notifyListeners();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyDataContainer(),
      child: MyApp(cameras: cameras,),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key,required this.cameras,}) : super(key: key);
  final List<CameraDescription> cameras;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NetTeam',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          initialRoute: "/splash",
          routes: {
            "/splash": (context) => const SplashScreen(),
            "/": (context) => const Home(),
            "/login": (context) => Login(),
            "/signup": (context) => const SignUp(),
            "/forgotpassword": (context) => const ForgotPassword(),
            "/verify": (context) => const Verify(),
            "/resetpassword": (context) => const ResetPassword(),
            "/interests": (context) => const Interests(),
            // "/videocall": (context) => const VideoCall(),
            "/videoset": (context) => VideoSet(cameras: cameras,),
            // "/chat": (context) => Chat(),
            //"/live": (context) => const Live(),
            //"/video15": (context) => const Video15(),
            //"/video60": (context) => const Video60(),
            //"/video3m" : (context) => const Video3m(),
            "/chatlist": (context) => const ChatList(),
            "/profile" : (context) => const Profile(),
            "/pricingplans": (context) =>  PricingPlans(),
            "/aboutyou" : (context) => const AboutYou(),
            "/create" : (context) => CreateVideo(cameras: cameras,)
          },
        );
      },
    );
  }
}
