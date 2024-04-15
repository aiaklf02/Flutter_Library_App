import 'package:flutter/material.dart';
import 'GestionLivres.dart';

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

class RetoursPage extends StatefulWidget {
  @override
  _RetoursPageState createState() => _RetoursPageState();
}
class _RetoursPageState extends State<RetoursPage> {
  late Future<List<Retour>> Retours = BookDataProvider().fetchRetour();
  final bookDataProvider = BookDataProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retours Page',style: TextStyle(color: Color.fromRGBO(255, 255,255,1),fontSize: 25),),
        backgroundColor: Color.fromARGB(255, 43, 44, 68),
      ),
      body: FutureBuilder<List<Retour>>(
        future: Retours,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Retour retour = snapshot.data![index];
                return FutureBuilder<Book>(
                  future: bookDataProvider.getBook(retour.Empruntid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListTile(
                        leading: Image.network(snapshot.data!.imagePath),  // Display the book image
                        title: Text('Emprunt ID: ${retour.Empruntid}'),
                        subtitle: Text('Retour ID: ${retour.Retoursid}'),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}