import 'package:flutter/material.dart';
import 'dart:io';
import 'Emprunts.dart';
import 'GestionLivres.dart';
import 'reservations.dart';
import 'Retours.dart';
import 'bookdetails.dart';


String imagePath = 'assets/bookcases-1869616_640.jpg';


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


class MyHomePage extends StatefulWidget {
  final String title;
  final BookRepository bookRepository;

  const MyHomePage({Key? key, required this.title, required this.bookRepository})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _booksFuture = widget.bookRepository.getBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 25),
        ),
        backgroundColor: Color.fromARGB(255, 43, 44, 68),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshData, // Call _refreshData when button is pressed
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(34, 34, 48, 1),
          child: FutureBuilder<List<Book>>(
            future: _booksFuture, // Use the updated _booksFuture
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return ListWheelScrollView(
                  diameterRatio: 5.0,
                  itemExtent: MediaQuery.of(context).size.height * 0.7,
                  children: snapshot.data!.map((book) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          // MaterialPageRoute(builder: (context) => BookDetailsPage()),
                          MaterialPageRoute(builder: (context) => BookDetailsPage(book: book, bookRepository: widget.bookRepository),),

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
              title: const Text(' Reservations ', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReservationsPage(bookRepository: widget.bookRepository)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text(' Mes Emprunts ', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoriqueEmpruntsPage(bookRepository: widget.bookRepository),
                )
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_label),
              title: const Text(' Retours ', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
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
              title: const Text(' Gestion Livres ', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
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
