import 'package:flutter/material.dart';


class SecondaryActionButton extends StatelessWidget {
  final String text;
  final Function() onClick;

  const SecondaryActionButton({Key? key, required this.text, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(18)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.black)))),
          onPressed: () async {
            onClick();
          },
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
    );
  }
}
