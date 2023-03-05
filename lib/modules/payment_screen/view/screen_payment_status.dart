import 'package:flutter/material.dart';

class ScreenPaymentStatus extends StatefulWidget {
  final String status;

  const ScreenPaymentStatus({Key? key, required this.status}) : super(key: key);

  @override
  State<ScreenPaymentStatus> createState() => _ScreenPaymentStatusState();
}

class _ScreenPaymentStatusState extends State<ScreenPaymentStatus> {
  @override
  void initState() {
    print("object");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Payment status"),
      ),
      body: Center(
          child: Text(
        widget.status,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      )),
    );
  }
}
