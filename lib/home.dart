// ignore_for_file: argument_type_not_assignable_to_error_handler

import 'package:androclient/model/enum.dart';
import 'package:androclient/service/call_log.dart';
import 'package:androclient/service/contact.dart';
import 'package:androclient/service/sms.dart';
import 'package:androclient/service/storage.dart';
import 'package:androclient/widget/loading.widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CurrentStatus smsClick = CurrentStatus.notClicked;
  CurrentStatus contactClick = CurrentStatus.notClicked;
  CurrentStatus callLogClick = CurrentStatus.notClicked;
  CurrentStatus storageClick = CurrentStatus.notClicked;
  int storageTotal = -1;
  int storageCurrent = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    // onPressed: (() {}),
                    onPressed: () async {
                      setState(() {
                        smsClick = CurrentStatus.loading;
                      });
                      bool isDone = await getSms();
                      setState(() {
                        if (isDone == true) {
                          smsClick = CurrentStatus.success;
                        } else {
                          smsClick = CurrentStatus.error;
                        }
                      });
                    },
                    child: const Text("SMS"),
                  ),
                ),
                getLoadingWidget(status: smsClick)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    // onPressed: (() {}),
                    // onPressed: () => getContacts(),
                    onPressed: () async {
                      setState(() {
                        contactClick = CurrentStatus.loading;
                      });
                      bool isDone = await getContacts();
                      setState(() {
                        if (isDone == true) {
                          contactClick = CurrentStatus.success;
                        } else {
                          contactClick = CurrentStatus.error;
                        }
                      });
                    },
                    child: const Text("Contacts"),
                  ),
                ),
                getLoadingWidget(status: contactClick)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    // onPressed: (() {}),
                    // onPressed: () => getCallLogs(),
                    onPressed: () async {
                      setState(() {
                        callLogClick = CurrentStatus.loading;
                      });
                      bool isDone = await getCallLogs();
                      setState(() {
                        if (isDone == true) {
                          callLogClick = CurrentStatus.success;
                        } else {
                          callLogClick = CurrentStatus.error;
                        }
                      });
                    },
                    child: const Text("Call Logs"),
                  ),
                ),
                getLoadingWidget(status: callLogClick)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    // onPressed: (() {}),
                    // onPressed: () => uploadAlbum(),
                    onPressed: () async {
                      setState(() {
                        storageClick = CurrentStatus.loading;
                      });
                      uploadAlbum().listen((element) {
                        setState(() {
                          storageCurrent = element["current"]!;
                          storageTotal = element["total"]!;
                        });
                      }, onDone: () {
                        if (storageCurrent == storageTotal) {
                          setState(() {
                            storageClick = CurrentStatus.success;
                          });
                        } else {
                          setState(() {
                            storageClick = CurrentStatus.error;
                          });
                        }
                      });
                    },
                    child: const Text("Storage"),
                  ),
                ),
                getLoadingWidget(status: storageClick)
              ],
            ),
            if(storageTotal != -1)
            getCountingLoadingWidget(
              total: storageTotal,
              current: storageCurrent,
            ),
          ],
        ),
      ),
    );
  }
}
