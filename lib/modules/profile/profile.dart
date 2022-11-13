import 'package:flutter/material.dart';
import 'package:take_it_easy/components/app_button.dart';
import 'package:take_it_easy/components/loader_widget.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/flutter_auth.dart';
import 'package:take_it_easy/modules/authentication/model/gmail_user_data.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/style/font.dart';
import 'package:take_it_easy/style/spacing.dart';

class UserProfile extends StatelessWidget with FlutterAtuh {
  const UserProfile({Key ?key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<GmailUserData>(
          future: DI.inject<SharedStorage>().getUserData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ProgressLoader();
            } else {
              final data = snapshot.data;
              return _body(context, gmailUserData: data!);
            }
          }),
    );
  }

  Widget _body(BuildContext context, {GmailUserData ?gmailUserData}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          _profileFace(gmailUserData!.photoURL!),
          SizedBox(
            height: 20.0,
          ),
          Text(
            gmailUserData.displayName!,
            style: const TextStyle(fontSize: FontSize.title),
          ),
          Text(gmailUserData.email ?? ''),
          Text(gmailUserData.phoneNumber ?? ''),
          const Spacer(),
          _logOutCta()
        ],
      ),
    );
  }

  Widget _profileFace(String url) {
    return Container(
      child: CircleAvatar(
        maxRadius: 50.0,
        backgroundImage: NetworkImage(url),
      ),
    );
  }

  Widget _logOutCta() {
    return Padding(
      padding: const EdgeInsets.all(Spacing.marginLarge),
      child: AppButton(
        onPressed: () {
          logOut();
        },
        buttonType: ButtonType.Border,
        text: "Log out",
      ),
    );
  }
  Widget _summary(){
    return Column(
      children: [
        Row(
          children: [
            Text("Level"),

          ],
        )
      ],
    );
  }
}
