import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApplicationBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF006D77),
      backwardsCompatibility: false,
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      title: Text(
        'Eduka Messenger',
        style: TextStyle(fontFamily: 'Roboto'),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
