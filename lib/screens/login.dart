import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../main.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  late MyDataContainer dataContainer;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    const String apiUrl = "https://netteam-backend-production.up.railway.app/login";

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String,dynamic>{
            "userId": _emailController.text,
            "password": _passwordController.text,
          })
      );

      if (response.statusCode == 200) {
        // Login successful, process the response data
        // print(myData.id);
        dataContainer.updateData(json.decode(response.body)["_id"]);
        Navigator.pop(context);
        Navigator.pushNamed(context, "/");
        // Handle the response data according to your needs
        // e.g., store user data in shared preferences, navigate to home screen, etc.
      } else if (response.statusCode == 404) {
        // User not found
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
    dataContainer = Provider.of<MyDataContainer>(context);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xFF0E0B1F),
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80.h,
              ),
              Text(
                "SIGN IN",
                style: GoogleFonts.roboto(
                    fontSize: 36.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 70.h,
              ),
              SizedBox(
                width: 295.w,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      //contentPadding: EdgeInsets.only(bottom: 15),
                      prefixIcon: Icon(
                        Icons.alternate_email_sharp,
                        color: Color(0xFF9F9F9F),
                        size: 20,
                      ),
                      hintText: 'E-Mail',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF9F9F9F),
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9F9F9F)))),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(
                height: 36.h,
              ),
              SizedBox(
                width: 295.w,
                child: TextField(
                  obscureText: !_showPassword,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      //contentPadding: EdgeInsets.only(bottom: 10),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFF9F9F9F),
                        size: 20,
                      ),
                      hintText: 'Password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xFF9F9F9F),
                            size: 20,
                          )),
                      hintStyle: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF9F9F9F),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9F9F9F)))),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(
                height: 36.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, "/forgotpassword"),
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.roboto(
                          color: const Color(0xFFEEEEEE),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 60.h,
              ),
              SizedBox(
                height: 46.h,
                width: 295.w,
                child: ElevatedButton(
                  onPressed: () async {
                    //Backend Work
                    await _login();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFCBFB5E))),
                  child: Text(
                    "SIGN IN",
                    style: GoogleFonts.roboto(
                        color: const Color(0xFF20242F),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 134.h,
              ),
              Row(
                children: [
                  const Expanded(
                      child: Divider(
                    color: Color(0xFF8D92A3),
                  )),
                  Text(
                    "    Or connect with    ",
                    style: GoogleFonts.roboto(
                      color: const Color(0xFF8D92A3),
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                  const Expanded(
                      child: Divider(
                    color: Color(0xFF8D92A3),
                  )),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.facebook,
                      color: Colors.white,
                      size: 40.h,
                    ),
                    onPressed: () {
                      //Handle respective event
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.g_mobiledata,
                      color: Colors.white,
                      size: 50.h,
                    ),
                    onPressed: () {
                      //Handle respective event
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.apple,
                      color: Colors.white,
                      size: 40.h,
                    ),
                    onPressed: () {
                      //Handle respective event
                    },
                  )
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: Text(
                      "Don't have an account?",
                      style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: Text(
                      " Sign Up",
                      style: GoogleFonts.roboto(
                          color: const Color(0xFFCBFB5E),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold),
                    ),
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
