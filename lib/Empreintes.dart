import 'package:flutter/material.dart';


class MesEmpreintesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes Empreintes Page",style: TextStyle(color: Color.fromRGBO(255, 255,255,1),fontSize: 25),),
        backgroundColor: Color.fromARGB(255, 43, 44, 68),
      ),
      body: Center(
        child: Text('Mes Empreintes Page Content'),
      ),
    );
  }
}
