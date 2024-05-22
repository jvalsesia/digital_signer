import 'package:flutter/material.dart';

import 'constants.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  const RoundIconButton({Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 6.0,
      constraints: const BoxConstraints.tightFor(
        width: 56.0,
        height: 56.0,
      ),
      onPressed: () => onPressed(),
      shape: const CircleBorder(),
      fillColor: kBottomContainerColor,
      child: Icon(icon),
    );
  }
}