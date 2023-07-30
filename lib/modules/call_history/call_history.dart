import 'package:flutter/material.dart';

class CallHistory extends StatefulWidget {
  const CallHistory({Key? key}) : super(key: key);

  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int i) => _tile(),
        itemCount: 10,
      ),
    );
  }

  Widget _tile() {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey[100]!))),
      padding: const EdgeInsets.all(10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.green,
            ),
            Row(
              children: List.generate(
                  4,
                  (index) => Icon(
                        Icons.star,
                        size: 12,
                      )),
            )
          ],
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 4,
            ),
            Text("Rahul raj"),
            const SizedBox(
              height: 10,
            ),
            Text("Id: 2312454")
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 4,
            ),
            Text("Duration"),
            const SizedBox(
              height: 10,
            ),
            Text("30 mins")
          ],
        ),
        const Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Icon(Icons.voice_chat), Text("12 Jan 2022")],
        )
      ]),
    );
  }
}
