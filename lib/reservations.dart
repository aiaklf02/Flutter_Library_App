import 'package:flutter/material.dart';

class reservationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservations Page",style: TextStyle(color: Color.fromRGBO(255, 255,255,1),fontSize: 25),),
        backgroundColor: Color.fromARGB(255, 43, 44, 68),
      ),
      body: Center(
        child: Text('Reservations Page Content'),
      ),
    );
  }
}

