import 'package:flutter/material.dart';
import 'dart:io';

import 'Empreintes.dart';
import 'GestionLivres.dart';
import 'catalogue.dart';
import 'Retours.dart';
import 'bookdetails.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


String imagePath = 'assets/bookcases-1869616_640.jpg';

// void main() => runApp(App2());

// class App2 extends StatelessWidget {
//   final appTitle = 'Library';
//   final BookDataProvider dataprovider = BookDataProvider();
//   late final BookRepository bookRepository;
//
//   App2({Key? key}) : super(key: key) {
//     bookRepository = BookRepository(dataProvider: dataprovider);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: appTitle,
//       home: MyHomePage(title: appTitle, bookRepository: bookRepository),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that the binding is initialized

  // Initialize the book repository
  final dataprovider = await BookDataProvider().init();
  final bookRepository = BookRepository(dataProvider: dataprovider);

  runApp(App2(bookRepository: bookRepository)); // Pass the initialized repository to the app
}

class App2 extends StatelessWidget {
  final appTitle = 'Library';
  final BookRepository bookRepository;

  App2({Key? key, required this.bookRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle, bookRepository: bookRepository),
      debugShowCheckedModeBanner: false,
    );
  }
}
// class MyHomePage extends StatelessWidget {
//   final String title;
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title,style: TextStyle(color: Color.fromRGBO(255, 255,255,1),fontSize: 25),),
//         backgroundColor: Color.fromARGB(255, 43, 44, 68),
//       ),
//       body: SafeArea(
//         child: Container(
//           color: Color.fromRGBO(34,34,48,1),
//           // height: MediaQuery.of(context).size.height * 0.9, // 90% of parent's height
//           // width: MediaQuery.of(context).size.width, // full width of parent
//           child: ListWheelScrollView(
//             // scrollDirection: Axis.horizontal, // Set horizontal direction
//             diameterRatio: 7.0, // Adjust this value to set the perspective
//
//             itemExtent: MediaQuery.of(context).size.height*0.8, // 90% of parent's width
//             children: List.generate(3, (index) {
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => BookDetailsPage()),
//                   );
//                 },
//                 child: Container(
//                   margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     image: DecorationImage(
//                       image: AssetImage(imagePath),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   child: Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//
//                         children: [
//                           Text('Book Title $index',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 26,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           //
//                           Text('Book Auteur $index',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 19,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           )
//                           //
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//
//

class MyHomePage extends StatelessWidget {
  final String title;
  final BookRepository bookRepository; // Add this field

  const MyHomePage({Key? key, required this.title, required this.bookRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 25),
        ),
        backgroundColor: Color.fromARGB(255, 43, 44, 68),
      ),
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(34, 34, 48, 1),
          child: FutureBuilder<List<Book>>(
            future: bookRepository.getBooks(), // Fetch books from the repository
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return ListWheelScrollView(
                  diameterRatio: 7.0,
                  itemExtent: MediaQuery.of(context).size.height * 0.8,
                  children: snapshot.data!.map((book) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BookDetailsPage()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(File(book.imagePath)),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  book.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  book.author,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),

      //
      //
      drawer: Drawer(
        backgroundColor: Color.fromRGBO(34, 34, 48, 1),
        child: ListView(

          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(34, 34, 48, 1),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: null,
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' Reservations ',style: TextStyle(color: Color.fromRGBO(255,255,255, 1)),),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => reservationsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text(' Mes Empreintes ',style: TextStyle(color: Color.fromRGBO(255,255,255, 1)),),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MesEmpreintesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_label),
              title: const Text(' Retours ',style: TextStyle(color: Color.fromRGBO(255,255,255, 1)),),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RetoursPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(' Gestion Livres ',style: TextStyle(color: Color.fromRGBO(255,255,255, 1)),),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  // u need to create the bookrepository instance before calling it in the main or it wont work
                  MaterialPageRoute(builder: (context) => GestionLivres(bookRepository: BookDataProvider().init().then((dataProvider) => BookRepository(dataProvider: dataProvider)),),),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
