import 'package:flutter/material.dart';
import 'manager_dialog.dart';

class FloatingButton extends StatefulWidget {
  final VoidCallback refreshClientList;
  const FloatingButton({
    super.key,
    required this.refreshClientList,
  });

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ClientManagerDialogs(
                onClientChanged: widget.refreshClientList);
          },
        );
      },
      backgroundColor: Colors.black,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
