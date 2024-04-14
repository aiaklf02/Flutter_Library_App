import 'package:flutter/material.dart';
import 'GestionLivres.dart';
import 'GestionEmprunts.dart';
import 'dart:io';
import 'package:provider/provider.dart';

// class BookDetailsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Book Details",style: TextStyle(color: Color.fromRGBO(255, 255,255,1),fontSize: 25),),
//         backgroundColor: Color.fromARGB(255, 43, 44, 68),
//       ),
//       body: Center(
//         child: Text('Book Details Page Content'),
//       ),
//     );
//   }
// }
//

class BookDetailsPage extends StatelessWidget {
  final Book book;

  const BookDetailsPage({Key? key, required this.book}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details du Livre", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 25),),
        backgroundColor: Color.fromARGB(255, 43, 44, 68),
      ),
      body:Container(
        color: Color.fromARGB(255, 43, 44, 68),
      child:ListView(
        children: [
          Container(
            width: double.infinity, // Take 100% width
            height: MediaQuery.of(context).size.height * 0.6, // Take 60% height of the screen
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(book.imagePath)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20), // Add some space between the image and text
          Text('Titre: ${book.title}', style: TextStyle(color: Colors.white,fontSize: 25)),
          Text('Autheur: ${book.author}', style: TextStyle(color: Colors.white,fontSize: 25)),
          Text('Categorie: ${book.category}', style: TextStyle(color: Colors.white,fontSize: 25)),
          Text('Date de publication: ${book.publicationYear}', style: TextStyle(color: Colors.white,fontSize: 25)),
          Text(' Copies disponibles: ${book.availableCopies}', style: TextStyle(color: Colors.white,fontSize: 25)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showReservationConfirmation(context, book.title);

                  // Handle reserve button pressed
                },
                child: Text('Reserver'),
              ),
              ElevatedButton(
                  onPressed: () async {
                  final bookRepository = Provider.of<BookRepository>(context, listen: false);

                  await bookRepository.addEmprunt(Emprunt(
                  bookId: book.bookId ?? 0,
                  dateEmprunt: DateTime.now(),
                  dateRetour: DateTime.now().add(Duration(days: 14)),
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Livre emprunté avec succès!'),
                  ));
                  },
                child: Text('Emprunter'),
              ),
            ],
          ),
          SizedBox(height: 20),

        ],


      ),),
    );
  }


  void _showReservationConfirmation(BuildContext context, String bookTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation de réservation'),
          content: Text('Voulez-vous vraiment réserver le livre "$bookTitle" ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Réserver'),
              onPressed: () {
                _confirmReservation(context, bookTitle);
              },
            ),
          ],
        );
      },
    );
  }
  void _confirmReservation(BuildContext context, String bookTitle) {
    // Implémentez la logique pour réserver le livre ici
    // Par exemple, enregistrer la réservation dans une base de données ou un backend
    // Une fois la réservation effectuée, affichez un message de confirmation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Réservation effectuée'),
          content: Text('Vous avez réservé le livre "$bookTitle" avec succès.'),
          actions: <Widget>[
            ElevatedButton(
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
