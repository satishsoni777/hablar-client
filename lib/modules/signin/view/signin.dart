import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:take_it_easy/auth/google_auth.dart';
import 'package:take_it_easy/components/app_button.dart';
import 'package:take_it_easy/components/app_padding.dart';
import 'package:take_it_easy/components/app_text_f.dart';
import 'package:take_it_easy/modules/signin/controller/auth_controller.dart';
import 'package:take_it_easy/style/spacing.dart';

class Login extends StatelessWidget {
  final AuthController _authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppPadding(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(ImageAsset.logo),
              MpbileOtpAith(),
              Spacing.sizeBoxHt100,
              SignInButton(
                Buttons.FacebookNew,
                onPressed: () async {
                  // Navigator.pushNamed(context, Routes.home);
                  // await GoogleAuthService().handleSignIn();
                },
                mini: false,
              ),
              Spacing.sizeBoxHt20,
              SignInButton(
                Buttons.GoogleDark,
                onPressed: () async {
                  _authController.gLogin();
                },
                mini: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MpbileOtpAith extends StatefulWidget {
  MpbileOtpAith({super.key});

  @override
  State<MpbileOtpAith> createState() => _MpbileOtpAithState();
}

class _MpbileOtpAithState extends State<MpbileOtpAith> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerOTP = TextEditingController();
  bool isLoading = false;
  bool otpSent = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          !otpSent
              ? AppTextF(
                  controller: controller,
                  textInputType: TextInputType.number,
                  hintText: "Enter mobile number",
                )
              : AppTextF(
                  controller: controllerOTP,
                  hintText: "Enter OTP",
                  textInputType: TextInputType.number,
                ),
          SizedBox(
            height: 20,
          ),
          AppButton(
            onPressed: () async {
              if (otpSent) {
                final res = GoogleAuthService().varifyOTP(controllerOTP.text);
              }
              setState(() {
                isLoading = true;
              });
              await GoogleAuthService().sendOtp(controller.text,
                  callback: (re) => {
                        if (re == OTP_STATUS.SENT) {otpSent = true},
                        setState(() {
                          isLoading = false;
                        }),
                        print(re)
                      });
            },
            textStyle: TextStyle(color: Colors.white),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : Text("Submit"),
          )
        ],
      ),
    );
  }
}
