import 'package:androclient/model/enum.dart';
import 'package:flutter/material.dart';

Widget getWidget(CurrentStatus status) {
  if (status == CurrentStatus.notClicked) {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: SizedBox(
        width: 25,
        height: 25,
      ),
    );
  } else if (status == CurrentStatus.loading) {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      ),
    );
  } else if (status == CurrentStatus.success) {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: SizedBox(
          width: 25,
          height: 25,
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xFF247F4F),
          )),
    );
  } else {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: SizedBox(
        width: 25,
        height: 25,
        child: Icon(
          Icons.error_outline_rounded,
          color: Color(0xFFD93025),
        ),
      ),
    );
  }
}
