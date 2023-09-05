import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String msg;
  final bool right;

  const Message(this.msg, this.right, {super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    const double radius = 20.0;
    return Row(
      mainAxisAlignment:
          right ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: screenWidth * 0.65),
          padding: const EdgeInsets.all(4.0),
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: right ? Colors.teal : Colors.black12,
            borderRadius: BorderRadius.only(
              topLeft: right
                  ? const Radius.circular(radius)
                  : const Radius.circular(5.0),
              topRight: const Radius.circular(radius),
              bottomLeft: const Radius.circular(radius),
              bottomRight: right
                  ? const Radius.circular(5.0)
                  : const Radius.circular(radius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              msg,
              style: TextStyle(
                color: right ? Colors.white : Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
