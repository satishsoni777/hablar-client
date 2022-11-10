import 'package:flutter/material.dart';
import 'package:take_it_easy/components/app_button.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/resources/strings/app_strings.dart';
import 'package:take_it_easy/style/app_colors.dart';
import 'package:take_it_easy/style/font.dart';
import 'package:take_it_easy/style/spacing.dart';

class InitiateCall extends StatefulWidget {
  const InitiateCall({Key key}) : super(key: key);

  @override
  _InitiateCallState createState() => _InitiateCallState();
}

class _InitiateCallState extends State<InitiateCall> {
  // AgoraVoiceManager agoraVoiceManager;

  final TextEditingController _userName = new TextEditingController();

  final TextEditingController _channelName = new TextEditingController();
  int _radio = 0;

  @override
  initState() {
    // agoraVoiceManager = AgoraVoiceManager();
    // agoraVoiceManager.initPlatformState();
    super.initState();
  }

  @override
  dispose() {
    // agoraVoiceManager?.dispose();
    super.dispose();
  }

  void _callNow() async {
    // await agoraVoiceManager.initPlatformState();
  }

  Widget _button() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .7,
        child: AppButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.dialer);
            // _callNow();
          },
          icon: Icon(Icons.call),
          text: "Talk now",
        ),
      ),
    );
  }

  void _onChangeradio(v) {
    this._radio = v;
    setState(() {});
  }

  Widget _selectGender() {
    return Container(
      // height: 120.0,
      padding: const EdgeInsets.only(
        top: Spacing.defaultMargin,
        bottom: Spacing.defaultMargin,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Spacing.defaultMargin),
            child: Text(
              "Select gender to talk",
              style: const TextStyle(fontSize: FontSize.subtitle),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Radio(
                    value: 0,
                    groupValue: _radio,
                    onChanged: _onChangeradio,
                  ),
                  Text("All")
                ],
              ),
              Row(
                children: [
                  Radio(
                      value: 1, groupValue: _radio, onChanged: _onChangeradio),
                  Text("Male")
                ],
              ),
              Row(
                children: [
                  Radio(
                      value: 2, groupValue: _radio, onChanged: _onChangeradio),
                  Text("Femele")
                ],
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.white),
          borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation:1.0
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.marginLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Text(
                AppStrings.of(context).startTalkingBuddy,
                style: const TextStyle(fontSize: FontSize.title),
              ),
              const SizedBox(
                height: 20.0,
              ),
              _selectGender(),
              const Spacer(),
              _button(),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
