import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0B1F),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFF0E0B1F),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60.h,
                ),
                Text(
                  "Forgot Password?",
                  style: GoogleFonts.roboto(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  width: 250.w,
                  child: Text(
                    "If you need help resetting your password, we can help by sending you an OTP to reset it.",
                    style: GoogleFonts.roboto(
                        color: const Color(0xFF8D92A3),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  height: 100.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 295.w,
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            //contentPadding: EdgeInsets.only(bottom: 15),
                            prefixIcon: Icon(
                              Icons.alternate_email_rounded,
                              color: Color(0xFF9F9F9F),
                              size: 20,
                            ),
                            hintText: 'E-Mail',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF9F9F9F),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF9F9F9F)))),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          final email = _emailController.text;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 46.h,
                      width: 295.w,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/verify");
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFCBFB5E))),
                        child: Text(
                          "SEND OTP",
                          style: GoogleFonts.roboto(
                              color: const Color(0xFF20242F),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
