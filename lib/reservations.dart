import 'package:flutter/material.dart';

class reservationsPage extends StatelessWidget {
  final List<String> books = [
    'Livre 1',
    'Livre 2',
    'Livre 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Page de réservations",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: Color.fromARGB(255, 43, 44, 68),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(books[index]),
            trailing: TextButton(
              onPressed: () {
                _reserveBook(context, books[index]);
              },
              child: Text('Réserver'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.purple,
              ),
            ),
          );
        },
      ),
    );
  }

  void _reserveBook(BuildContext context, String book) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation de réservation'),
          content: Text('Voulez-vous vraiment réserver le livre "$book" ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Réserver'),
              onPressed: () {
              _confirmReservation(context, book);
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmReservation(BuildContext context, String book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Réservation réussie'),
          content: Text('Le livre "$book" a été réservé avec succès.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
