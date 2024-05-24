import 'package:flutter/material.dart';
import 'constants.dart';

class IconContent extends StatelessWidget {
  final IconData widgetIcon;
  final String label;
  final Color foregroundContainerColor;
  final double iconSize;

  const IconContent({
    super.key,
    required this.widgetIcon,
    required this.foregroundContainerColor,
    required this.label,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          widgetIcon,
          size: iconSize,
          color: foregroundContainerColor,
        ),
        SizedBox(
          height: label.isEmpty ? 0.0 : 15.0,
        ),
        Text(
          label,
          style: kLabelTextStyle,
        ),
      ],
    );
  }
}
