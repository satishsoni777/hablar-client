import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/components/app_button.dart';
import 'package:take_it_easy/modules/home/controller/home_controller.dart';
import 'package:take_it_easy/modules/home/widget/off_line_toggle.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/style/app_colors.dart';
import 'package:take_it_easy/style/font.dart';
import 'package:take_it_easy/style/spacing.dart';

class Calling extends StatefulWidget {
  const Calling({Key? key}) : super(key: key);

  @override
  _CallingState createState() => _CallingState();
}

class _CallingState extends State<Calling> {
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
            Navigator.pushNamed(context, Routes.dialer, arguments: Provider.of<HomeController>(context, listen: false));
          },
          icon: Icon(Icons.call),
          text: "Talk now",
        ),
      ),
    );
  }

  Widget _level() {
    Widget _getTextButton(
      String text,
      int index,
    ) {
      return Consumer<HomeController>(builder: (context, provider, a) {
        return MaterialButton(
          onPressed: () {
            provider.selectLevel(index);
          },
          color: provider.selectedLevel == index ? Colors.blue : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
            text,
            style: TextStyle(fontSize: 12),
          ),
        );
      });
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: _getTextButton("beginner", 0),
          ),
          _getTextButton("Intermediate", 1),
          _getTextButton("Expert", 2),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }

  Widget _selectGender() {
    Widget _radioTextButton(String value, String text) {
      return Consumer<HomeController>(builder: (BuildContext context, HomeController provider, Widget? a) {
        return Row(
          children: <Widget>[
            Radio<String>(
              value: provider.gedner,
              groupValue: value,
              onChanged: (String? v) {
                provider.selectGender(value);
              },
            ),
            InkWell(
                onTap: () {
                  provider.selectGender(value);
                },
                child: Text(
                  text,
                  style: TextStyle(fontSize: 12),
                ))
          ],
        );
      });
    }

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _radioTextButton("a", "All"),
              _radioTextButton("f", "Femele"),
              _radioTextButton("m", "Male"),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(width: Borders.border, color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        actions: [OfflineToggle()],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.marginLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "Practice now",
                style: const TextStyle(
                  fontSize: FontSize.subtitle,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              _level(),
              const SizedBox(
                height: 12.0,
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
