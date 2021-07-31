import 'package:flutter/material.dart';
import 'package:take_it_easy/style/app_colors.dart';

enum ButtonType { Border, Fill }

class AppButton extends StatelessWidget {
  const AppButton(
      {Key key,
      @required this.onPressed,
      this.child,
      this.elevation = 4.0,
      this.isDisabled = false,
      this.loader,
      this.icon,
      this.text,
      this.height = 40.0,
      this.shapeBorder,
      this.textStyle,
      this.borderRadius = 8,
      this.buttonType = ButtonType.Fill,
      this.width,
      this.color,
      this.isLoading = false})
      : super(key: key);
  final VoidCallback onPressed;
  final Widget child;
  final bool isLoading;
  final Widget loader;
  final bool isDisabled;
  final double elevation;
  final String text;
  final TextStyle textStyle;
  final ShapeBorder shapeBorder;
  final double height;
  final Widget icon;
  final ButtonType buttonType;
  final double borderRadius;
  final double width;
  final Color color;
  ShapeBorder get getBorder {
    if (buttonType == ButtonType.Border) {
      return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: AppColors.white));
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: MaterialButton(
        disabledElevation: 0.0,
        
        elevation: 4.0,
        color: buttonType == ButtonType.Fill
            ? color??Theme.of(context).buttonColor
            : null,
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              )
            : Center(
                child: child ??
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        icon ?? Container(),
                        Text(
                          text??'',
                          style: buttonType == ButtonType.Fill
                              ? const TextStyle(fontSize: 16)
                              : const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
              ),
        disabledColor: Theme.of(context).disabledColor,
        onPressed: !isDisabled ? () => !isLoading ? onPressed() : () {} : null,
        shape: getBorder ??
            RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(
              borderRadius,
            )),
      ),
    );
  }
}
