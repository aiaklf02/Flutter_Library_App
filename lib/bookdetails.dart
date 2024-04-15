import 'package:flutter/material.dart';
import 'GestionLivres.dart';
import 'GestionEmprunts.dart';
import 'dart:io';

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
  final BookRepository bookRepository;

  const BookDetailsPage({Key? key, required this.book,required this.bookRepository}) : super(key: key);


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
            height: MediaQuery.of(context).size.height * 0.7, // Take 60% height of the screen
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(book.imagePath)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20), // Add some space between the image and text
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Add vertical padding around the entire column
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Title:',
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                    SizedBox(width: 20), // Add spacing of 20 units
                    Expanded(
                      child: Text(
                        '${book.title}',
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip, // Clip text if it overflows
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Author: ',
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                    SizedBox(width: 20), // Add spacing of 20 units
                    Expanded(
                      child: Text(
                        '${book.author}',
                        style: TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip, // Clip text if it overflows
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Category: ',
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                    SizedBox(width: 20), // Add spacing of 20 units
                    Expanded(
                      child: Text(
                        '${book.category}',
                        style: TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip, // Clip text if it overflows
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Publication Year: ',
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                    SizedBox(width: 20), // Add spacing of 20 units
                    Expanded(
                      child: Text(
                        '${book.publicationYear}',
                        style: TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip, // Clip text if it overflows
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Available Copies: ',
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                    SizedBox(width: 20), // Add spacing of 20 units
                    Expanded(
                      child: Text(
                        '${book.availableCopies}',
                        style: TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip, // Clip text if it overflows
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),

          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showReservationConfirmation(context, book.title);

                  // Handle reserve button pressed
                },
                child: Text('Réserver'),
              ),
              ElevatedButton(
                  onPressed: () async {
                  print ("Clicked");
                  int ?bookIds = book.bookId;
                  print ("This is the book instance {$bookIds}");
                  await bookRepository.addEmprunt(Emprunt(
                  bookId: bookIds!,
                  dateEmprunt: DateTime.now(),
                  dateRetour: DateTime.now().add(Duration(days: 14)),
                  ));
                  await bookRepository.updatebookNumber(bookIds);
                  print(" This is all the books instances {$bookRepository}");
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
