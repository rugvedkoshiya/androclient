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
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text("SMS"),
                //     FutureBuilder<bool>(
                //       future: getContacts(),
                //       builder: ((context, snapshot) {
                //         if (snapshot.hasData) {
                //           return Container();
                //         } else {
                //           return const Padding(
                //             padding: EdgeInsets.only(left: 8.0),
                //             child: SizedBox(
                //               width: 20,
                //               height: 20,
                //               child: CircularProgressIndicator(
                //                 color: Colors.white,
                //                 strokeWidth: 3,
                //               ),
                //             ),
                //           );
                //         }
                //       }),
                //     ),
                //   ],
                // ),
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
