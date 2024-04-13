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
                  // Handle reserve button pressed
                },
                child: Text('Reserver',style: TextStyle(fontSize: 25),),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle emprainte a copy button pressed
                },
                child: Text('Emprainter',style: TextStyle(fontSize: 25),),
              ),
            ],
          ),
          SizedBox(height: 20),

        ],


      ),),
    );
  }
}
