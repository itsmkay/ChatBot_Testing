import 'package:flutter/material.dart';

class LoadingMessage extends StatelessWidget {
  final bool right;

  const LoadingMessage({super.key, required this.right});

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
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
    ;
  }
}
