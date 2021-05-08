import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool isLoading;
  final Widget loader;
  final bool isDisabled;
  final double elevation;
  final String text;
  final TextStyle textStyle;
  const AppButton(
      {Key key,
      @required this.onPressed,
      this.child,
      this.elevation = 4.0,
      this.isDisabled = false,
      this.loader,
      this.text,
      this.textStyle,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: MaterialButton(
        disabledElevation: 0.0,
        elevation: 4.0,
        color: Theme.of(context).buttonColor,
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              )
            : Center(
              child: (child ??
                  Text(
                    text,
                    style: const TextStyle(fontSize: 16),
                  )),
            ),
        disabledColor: Theme.of(context).disabledColor,
        onPressed: !isDisabled ? () => !isLoading ? onPressed() : () {} : null,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(12.0)),
      ),
    );
  }
}
