import 'package:flutter/material.dart';

import '../../main.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  final Color? colors;
  final Color? bgColor;

  const RoundButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.loading = false,
      this.colors,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: mq.height * .06,
        width: mq.width * .8,
        decoration: BoxDecoration(
            color: bgColor == null ? Colors.deepPurple : bgColor, borderRadius: BorderRadius.circular(23)),
        child: Center(
          child: loading
              ? CircularProgressIndicator(
                  color: colors,
                )
              : Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
        ),
      ),
    );
  }
}
