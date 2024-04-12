import 'package:flutter/material.dart';
import 'GestionLivres.dart';
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

  const BookDetailsPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Details", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 25),),
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
          Text('Title: ${book.title}', style: TextStyle(color: Colors.white,fontSize: 25)),
          Text('Author: ${book.author}', style: TextStyle(color: Colors.white,fontSize: 25)),
          Text('Category: ${book.category}', style: TextStyle(color: Colors.white,fontSize: 25)),
          Text('Publication Year: ${book.publicationYear}', style: TextStyle(color: Colors.white,fontSize: 25)),
          Text('Available Copies: ${book.availableCopies}', style: TextStyle(color: Colors.white,fontSize: 25)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle reserve button pressed
                },
                child: Text('Reserve'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle emprainte a copy button pressed
                },
                child: Text('Emprainte a Copy'),
              ),
            ],
          ),
          SizedBox(height: 20),

        ],


      ),),
    );
  }
}
