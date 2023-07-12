import 'package:flutter/material.dart';
import 'package:take_it_easy/components/loader_widget.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/signin/model/gmail_user_data.dart';
import 'package:take_it_easy/modules/landing_page/service/landing_repo.dart';
import 'package:take_it_easy/modules/profile/widgets/follow_followers.dart';
import 'package:take_it_easy/modules/profile/widgets/profile_tile.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/style/font.dart';
import 'package:take_it_easy/utils/string_utils.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          // ignore: always_specify_types
          PopupMenuButton(itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<int>(
                value: 2,
                child: Text("Logout"),
              ),
            ];
          }, onSelected: (int value) {
            if (value == 0) {
              print("My account menu is selected.");
            } else if (value == 1) {
              print("Settings menu is selected.");
            } else if (value == 2) {
              DI.inject<LandingRepo>().logOut();
            }
          }),
        ],
      ),
      body: FutureBuilder<UserData>(
          future: DI.inject<SharedStorage>().getUserData(),
          builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
            if (!snapshot.hasData) {
              return Column(
                children: [
                  ProgressLoader(),
                  const Spacer(),
                  ProfileTile(
                    title: Text("Log Out"),
                    onPressed: () {
                      DI.inject<LandingRepo>().logOut();
                    },
                    leading: Icon(Icons.feedback),
                  ),
                ],
              );
            } else {
              final UserData? data = snapshot.data;
              return _body(context, gmailUserData: data!);
            }
          }),
    );
  }

  Widget _body(BuildContext context, {UserData? gmailUserData}) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _profileFace(gmailUserData?.photoURL ?? ''),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        gmailUserData?.displayName ?? "",
                        style: const TextStyle(fontSize: FontSize.title),
                      ),
                      // Text(gmailUserData.email ?? ''),
                      Text(gmailUserData?.phoneNumber ?? ''),
                      FollowFollowers()
                    ],
                  ),
                )
              ],
            ),
          ),
          _summary(),

          ProfileTile(
            title: Text("Call History"),
            onPressed: () {},
            leading: Icon(Icons.history),
          ),
          ProfileTile(
            title: Text("Conversational Feedback"),
            onPressed: () {},
            leading: Icon(Icons.feedback),
          ),
          ProfileTile(
            title: Text("Become Plus Memeber"),
            onPressed: () {},
            leading: Icon(Icons.card_membership),
          ),
          ProfileTile(
            title: Text("Contact Us"),
            onPressed: () {},
            leading: Icon(Icons.contact_phone),
          ),
          ProfileTile(
            title: Text("About Us"),
            onPressed: () {},
            leading: Icon(Icons.more),
          ),

          // const Spacer(),
          // _logOutCta()
        ],
      ),
    );
  }

  Widget _profileFace(String url) {
    if (isNullOrEmpty(url)) return Container();
    return Container(
      child: CircleAvatar(
        maxRadius: 50.0,
        backgroundImage: NetworkImage(url),
      ),
    );
  }

  Widget _summary() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: DetailsTile(
              text2: "Rating",
              title: "3.4/5",
            ),
          ),
          Expanded(
              child: DetailsTile(
            title: "30 Mins",
            text2: "Total Talk",
          )),
          Expanded(
              child: DetailsTile(
            title: "2 hours",
            text2: "Duration left",
            icon: Icon(Icons.watch),
          )),
        ],
      ),
    );
  }
}

class DetailsTile extends StatelessWidget {
  const DetailsTile({Key? key, this.icon, this.text2, this.title, this.widget2}) : super(key: key);
  final String? title;
  final String? text2;
  final Widget? icon;
  final Widget? widget2;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8, bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title ?? "Level"),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget2 ??
                  Text(
                    text2 ?? "Advance",
                    style: TextStyle(fontSize: 10),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
