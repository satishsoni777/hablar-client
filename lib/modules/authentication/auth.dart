import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:take_it_easy/auth_handler/gmail_auth.dart';
import 'package:take_it_easy/components/app_alert.dart';
import 'package:take_it_easy/components/app_padding.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/resources/images/images.dart';
import 'package:take_it_easy/style/spacing.dart';

class Authentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                onPressed: () async {
                  // Navigator.pushNamed(context, Routes.home);
                  // await GmailAuth().handleSignIn();
                },
                mini: false,
              ),
              Spacing.sizeBoxHt20,
              SignInButton(
                Buttons.GoogleDark,
                onPressed: () async {
                  AppAlert.of(context).dialog();
                  await GmailAuth().handleSignIn();
                   AppAlert.popDialog();
                  Navigator.pushReplacementNamed(context, Routes.home);
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
