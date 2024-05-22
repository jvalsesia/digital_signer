import 'package:flutter/material.dart';
import 'constants.dart';

class IconContent extends StatelessWidget {
  final IconData widgetIcon;
  final String label;
  final Color foregroundContainerColor;

  const IconContent({
    Key? key,
    required this.widgetIcon,
    required this.foregroundContainerColor,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          widgetIcon,
          size: 80.0,
          color: foregroundContainerColor,
        ),
        const SizedBox(
          height: 15.0,
        ),
        Text(
          label,
          style: kLabelTextStyle,
        ),
      ],
    );
  }
}
