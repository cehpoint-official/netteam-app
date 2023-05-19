import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final TextEditingController firstDigit = TextEditingController();
  final TextEditingController secondDigit = TextEditingController();
  final TextEditingController thirdDigit = TextEditingController();
  final TextEditingController fourthDigit = TextEditingController();
  @override
  Widget build(BuildContext context) {
    TextEditingController newTextEditingController = TextEditingController();
    FocusNode focusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0B1F),
        elevation: 0.0,
      ),
      backgroundColor: Color(0xFF0E0B1F),
      body: SafeArea(
        child: SafeArea(
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
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      "Verify email",
                      style: GoogleFonts.roboto(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: 250.w,
                    child: Text(
                      "Enter the OTP which is sent to your registered email",
                      style: GoogleFonts.roboto(
                          color: const Color(0xFF8D92A3),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 250.w,
                        child: PinCodeFields(
                          length: 4,
                          controller: newTextEditingController,
                          focusNode: focusNode,
                          onComplete: (result) {
                            // Your logic with code
                            print(result);
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
                            Navigator.pushNamed(context, "/resetpassword");
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFFCBFB5E))),
                          child: Text(
                            "CONTINUE",
                            style: GoogleFonts.roboto(
                                color: const Color(0xFF20242F),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 46.h,
                        width: 295.w,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF0E0B1F))),
                          child: Text(
                            "Resend OTP",
                            style: GoogleFonts.roboto(
                                color: const Color(0xFFCBFB5E),
                                fontSize: 14.sp,
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
      ),
    );
  }
}
