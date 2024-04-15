import 'package:flutter/material.dart';

class Retour {
  final int? Retoursid;
  final int Empruntid;
  final DateTime dateRetour;

  Retour({this.Retoursid,required this.Empruntid, required this.dateRetour});
  Map<String, dynamic> toMap() {
      return {
        'Retoursid': Retoursid,
        'Empruntid': Empruntid,
        'dateRetour': dateRetour.toIso8601String(),
      };
    }
}

class RetoursPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retours Page',style: TextStyle(color: Color.fromRGBO(255, 255,255,1),fontSize: 25),),
        backgroundColor: Color.fromARGB(255, 43, 44, 68),
      ),
      body: Center(
        child: Text('Retours Page Content'),
      ),
    );
  }
}
