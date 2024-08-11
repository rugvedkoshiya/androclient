import 'package:androclient/model/enum.dart';
import 'package:flutter/material.dart';

Widget getLoadingWidget({required CurrentStatus status}) {
  if (status == CurrentStatus.notClicked) {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: SizedBox(
        width: 24,
        height: 24,
      ),
    );
  } else if (status == CurrentStatus.loading) {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      ),
    );
  } else if (status == CurrentStatus.success) {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: SizedBox(
          width: 24,
          height: 24,
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xFF247F4F),
          )),
    );
  } else {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: SizedBox(
        width: 24,
        height: 24,
        child: Icon(
          Icons.error_outline_rounded,
          color: Color(0xFFD93025),
        ),
      ),
    );
  }
}

Widget getCountingLoadingWidget({int total = -1, int current = -1}) {
  return Padding(
    padding: const EdgeInsets.only(top:10, right: 35,),
    child: Text("$current/$total"),
  );
}
