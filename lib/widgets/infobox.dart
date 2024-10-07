import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({
    super.key,
    required this.txt,
    required this.txttop,
  });
  final String txt;
  final String txttop;
  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.white,
      label: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            txttop,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.grey),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            txt,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.cyan),
          )
        ],
      ),
    );
  }
}
