import 'package:androclient/service/call_log.dart';
import 'package:androclient/service/contact.dart';
import 'package:androclient/service/sms.dart';
import 'package:androclient/service/storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                // onPressed: (() {}),
                onPressed: () => getSms(),
                child: const Text("SMS"),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                // onPressed: (() {}),
                onPressed: () => getContacts(),
                child: const Text("Contacts"),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                // onPressed: (() {}),
                onPressed: () => getCallLogs(),
                child: const Text("Call Logs"),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                // onPressed: (() {}),
                onPressed: () => uploadAlbum(),
                child: const Text("Storage"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
