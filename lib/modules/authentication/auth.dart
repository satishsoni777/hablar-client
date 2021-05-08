import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:take_it_easy/components/app_padding.dart';
import 'package:take_it_easy/resources/images/images.dart';
import 'package:take_it_easy/style/spacing.dart';
import 'package:take_it_easy/web_rtc/voice/voice_call_manager.dart';

class Authentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VoiceCallManager voiceCallManager = VoiceCallManager();
    return Scaffold(
      body: Center(
        child: AppPadding(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImageAsset.logo),
              Spacing.sizeBoxHt100,
              SignInButton(
                Buttons.FacebookNew,
                onPressed: () {
                  voiceCallManager.makeCall();
                },
                mini: false,
              ),
              Spacing.sizeBoxHt20,
              SignInButton(
                Buttons.GoogleDark,
                onPressed: () {
                  voiceCallManager.makeCall();
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
