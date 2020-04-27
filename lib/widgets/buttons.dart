import 'package:CardFLows/util/colors.dart';
import 'package:CardFLows/widgets/box.dart';
import 'package:flutter/material.dart';

Color _pale = AppColors.indigo1;
Color _bright = AppColors.indigo2;
Color _medium = AppColors.indigo3;
Color _bleak = AppColors.indigo4;
Color _dark = AppColors.indigo5;

class RoundButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  RoundButton({
    Key key,
    @required this.text,
    @required this.onPressed,
  })  : assert(text != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text),
      onPressed: onPressed,
      color: _pale,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: _bleak),
      ),
    );
  }
}

class FlatRoundButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double radius;
  final TextStyle style;

  FlatRoundButton({
    Key key,
    @required this.text,
    @required this.onTap,
    this.radius = 8.0,
    this.style,
  })  : assert(text != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: _pale.withOpacity(0.4),
      splashColor: _medium.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(
          text,
          style: style ??
              TextStyle().copyWith(
                color: _medium,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
    );
  }
}

class BottomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const BottomButton({
    Key key,
    @required this.text,
    @required this.onPressed,
  })  : assert(text != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomBox(
      child: Center(
        child: RoundButton(text: text, onPressed: onPressed),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
    );
  }
}
