import 'package:flutter/material.dart';
import 'AddNewBook.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'GestionEmprunts.dart';
import 'Retours.dart';
import 'reservations.dart';

// Step 1: Create the Book model
class Book {
  final int? bookId;
  String title;
  String author;
  String category;
  int publicationYear;
  int availableCopies;
  String imagePath;

  Book({required this.bookId,required this.title,required this.author,required this.category,required this.publicationYear,required this.availableCopies,required this.imagePath});
  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'title': title,
      'author': author,
      'category': category,
      'publicationYear': publicationYear,
      'availableCopies': availableCopies,
      'imagePath': imagePath,
    };

  }
}

// The BookDataProvider is the DatabaseHelper, its role is to manage the database by creating the tables and Dropping them here
class BookDataProvider {
  static const tableName = 'books';
  late final Database db;

  Future<BookDataProvider> init() async {
    print("Initializing database...");
    await initDatabase();
    return this;
  }

  Future<void> initDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'books.db'),
      onCreate: (db, version) async {
        await _createDb(db, version);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        //You can create a duplicate database and migrate the data to the new database
        //here to avoid any useless problem, we avoid doing that and just drop the table and recreate it
        //but for realtime application, you should consider migrating the data

        //await db.execute('CREATE TABLE IF EXISTS EmpruntMigration (empruntId INTEGER PRIMARY KEY AUTOINCREMENT, bookId INTEGER NOT NULL, dateEmprunt TEXT NOT NULL, dateRetour TEXT NOT NULL)');
        //await db.execute('INSERT INTO EmpruntMigration SELECT * FROM Emprunt');
        //await db.execute('DROP TABLE Emprunt');

        await db.execute('DROP TABLE IF EXISTS $tableName');
        await db.execute('DROP TABLE Emprunt');
        await db.execute('DROP TABLE Retours');
        // await db.execute('DROP TABLE Reservations');

        // Recreate the tables
        await _createDb(db, newVersion);
      },
      version: 8,  // Increase this number whenever you want to update the schema
    );      
    print("Database initialized.");
  }
  
  Future<void> _createDb(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $tableName(bookId INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, author TEXT, category TEXT, publicationYear INTEGER, availableCopies INTEGER, imagePath TEXT)",
    );
    print("Creating books in the database...");
    await db.execute('''
      CREATE TABLE Emprunt (
        empruntId INTEGER PRIMARY KEY AUTOINCREMENT,
        bookId INTEGER NOT NULL,
        dateEmprunt TEXT NOT NULL,
        dateRetour TEXT NOT NULL,
        Remis INTEGER,
        FOREIGN KEY (bookId) REFERENCES Book(bookId)
      )
    ''');
    print("Creating Emprunt in the database...");
    await db.execute('''CREATE TABLE Retours (Retoursid INTEGER PRIMARY KEY AUTOINCREMENT, 
        Empruntid INT,
        dateRetour TEXT NOT NULL,
        FOREIGN KEY(Empruntid) REFERENCES Emprunt(empruntId)
        )
      ''');
    print("Creating Reservations in the database...");

    await db.execute('''
    CREATE TABLE Reservations(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      bookId INTEGER NOT NULL,
      date TEXT NOT NULL,
      FOREIGN KEY (bookId) REFERENCES Book(bookId)
    )
    ''');
  }
 

  Future<List<Book>> fetchBooks() async {
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return Book(
        bookId: maps[i]['bookId'],
        title: maps[i]['title'],
        author: maps[i]['author'],
        category: maps[i]['category'],
        publicationYear: maps[i]['publicationYear'],
        availableCopies: maps[i]['availableCopies'],
        imagePath: maps[i]['imagePath'],
      );
    });
  }

  Future<void> addBook(Book book) async {
    await db.insert(
      tableName,
      book.toMap()..['bookId'] = null,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Book> getBook(int id) async {
    List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'bookId = ?',
      whereArgs: [id],
    );
  
    if (maps.length > 0) {
      return Book(
        bookId: maps[0]['bookId'],
        title: maps[0]['title'],
        imagePath: maps[0]['imagePath'], 
        author: '', 
        availableCopies: 0, 
        publicationYear: maps[0]['publicationYear'], 
        category: '',
        
      );
    }
  
    throw Exception('Book ID $id not found');
  }

  Future<void> updateBook(Book book) async {
    await db.update(
      tableName,
      book.toMap(),
      where: "bookId = ?",
      whereArgs: [book.bookId],
    );
  }

  Future<void> deleteBook(int bookId) async {
    await db.delete(
      tableName,
      where: "bookId = ?",
      whereArgs: [bookId],
    );
  }
  Future<void> updatebookNumber(int bookId) async {
    await db.rawUpdate('UPDATE books SET availableCopies = availableCopies - 1 WHERE bookId = ?', [bookId]);
  }
  Future<void> addbookNumber(int bookId) async {
    await db.rawUpdate('UPDATE books SET availableCopies = availableCopies + 1 WHERE bookId = ?', [bookId]);
  }
  Future<void> addEmprunt(Emprunt emprunt) async {
  await db.insert('Emprunt', emprunt.toMap());
  }
  Future<void> addRetour(Retour retour) async {
    await db.insert('Retours',retour.toMap());
  }
  Future<List<Retour>> fetchRetour() async {
    final List<Map<String, dynamic>> maps = await db.query('Retours');
    return List.generate(maps.length, (i) {
      return Retour(
        Retoursid: maps[i]['Retoursid'],
        Empruntid: maps[i]['Empruntid'],
        dateRetour: DateTime.parse(maps[i]['dateRetour']),
      );
    });
  }
  Future<void> updateEmprunt(Emprunt emprunt) async {
    await db.update(
      'Emprunt',
      {'Remis': 1}, 
      where: "empruntId = ?",
      whereArgs: [emprunt.empruntId], 
    );
  }

  Future<void> addReservation(Reservation reservation) async {
    print('Adding reservation: ${reservation.toMap()}'); // Debug line
    await db.insert('Reservations', reservation.toMap());
  }

  Future<List<Reservation>> fetchReservations() async {
    final List<Map<String, dynamic>> maps = await db.query('Reservations');
    return List.generate(maps.length, (i) {
      return Reservation(
        id: maps[i]['id'],
        bookId: maps[i]['bookId'],
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }

  Future<void> deleteReservation(int id) async {
    await db.delete('Reservations', where: 'id = ?', whereArgs: [id]);
  }
}


class BookRepository {
  final BookDataProvider dataProvider;

  BookRepository({required this.dataProvider});

  Future<List<Book>> getBooks() async {
    return await dataProvider.fetchBooks();
  }

  Future<void> addBook(Book book) async {
    await dataProvider.addBook(book);
  }

  Future<void> updateBook(Book book) async {
    await dataProvider.updateBook(book);
  }

  Future<void> deleteBook(int bookId) async {
    await dataProvider.deleteBook(bookId);
  }

 Future<Book?> getBookDetails(int bookId) async {
    final List<Map<String, dynamic>> maps = await dataProvider.db.query(
      BookDataProvider.tableName,
      where: 'bookId = ?',
      whereArgs: [bookId],
    );

    if (maps.isNotEmpty) {
      return Book(
        bookId: maps[0]['bookId'],
        title: maps[0]['title'],
        author: maps[0]['author'],
        category: maps[0]['category'],
        publicationYear: maps[0]['publicationYear'],
        availableCopies: maps[0]['availableCopies'],
        imagePath: maps[0]['imagePath'],
      );
    } else {
      return null;
    }
  }

  Future<List<Emprunt>> getEmprunts() async {
  
    final List<Map<String, dynamic>> empruntsMap = await dataProvider.db.query('Emprunt');

    return empruntsMap.map((empruntMap) {
      return Emprunt(
        Remis: empruntMap['Remis'] == 1,
        empruntId: empruntMap['empruntId'],
        bookId: empruntMap['bookId'],
        dateEmprunt: DateTime.parse(empruntMap['dateEmprunt']),
        dateRetour: DateTime.parse(empruntMap['dateRetour']),
      );
    }).toList();
  }
  Future<void> addEmprunt(Emprunt emprunt) async {
    await dataProvider.addEmprunt(emprunt);
  }
  Future<void> updatebookNumber(int bookId) async {
    await dataProvider.updatebookNumber(bookId);
  }
  Future<void> addbookNumber(int bookId) async {
    await dataProvider.addbookNumber(bookId);
  }

  Future<void> addRetour(Retour retour) async {
    await dataProvider.addRetour(retour);
  }
  Future<void> updateEmprunt(Emprunt emprunt) async {
    await dataProvider.updateEmprunt(emprunt);
  }
  Future<void> addReservation(Reservation reservation) async {
    await dataProvider.addReservation(reservation);
  }

  Future<List<Reservation>> getReservations() async {
    return await dataProvider.fetchReservations();
  }

  Future<void> deleteReservation(int id) async {
    await dataProvider.deleteReservation(id);
  }
  Future<List<Reservation>> fetchReservations() async {
    return await dataProvider.fetchReservations();
  }
  Future<Book>? getBookById(int bookId) async {
    return await dataProvider.getBook(bookId);
  }

}


class GestionLivres extends StatefulWidget {
  final Future<BookRepository> bookRepository;

  GestionLivres({required this.bookRepository});

  @override
  _GestionLivresState createState() => _GestionLivresState();
}

class _GestionLivresState extends State<GestionLivres> {
  final _formKey = GlobalKey<FormState>();
  final _book = Book(bookId: null, title: '', author: '', category: '', publicationYear: 0, availableCopies: 0, imagePath: '');
  bool _isAdding = false;

  Future<List<Book>> _refreshBooks() async {
    final bookRepository = await widget.bookRepository;
    return await bookRepository.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion Livres Page',style: TextStyle(color: Color.fromRGBO(255, 255,255,1),fontSize: 25),),
        backgroundColor: Color.fromARGB(255, 43, 44, 68),
        actions: [
          IconButton(
            icon: Icon(Icons.add,size: 32, color: Colors.white),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FutureBuilder<BookRepository>(
                    future: widget.bookRepository,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AddBookPage(
                          bookRepository: Future.value(snapshot.data),
                          onBookAdded: () {
                            setState(() {});
                          },
                        );                    } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              );
            }, // Call _refreshData when button is pressed
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isAdding)
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Title'),
                    onSaved: (value) => _book.title = value ?? '',
                  ),
                  // Add more fields for the other book properties
                  ElevatedButton(
                    child: Text('Save'),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        final bookRepository = await widget.bookRepository;
                        bookRepository.addBook(_book);
                        setState(() {
                          _isAdding = false;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      setState(() {
                        _isAdding = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          SizedBox(height: 25),

          Expanded(
            child: FutureBuilder<List<Book>>(
              future: widget.bookRepository.then((value) => value.getBooks()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final book = snapshot.data?[index];
                      if (book != null) {
                        return ListTile(
                          title: Text(book.title),
                          subtitle: Text(book.author),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddBookPage(
                                        bookRepository: widget.bookRepository,
                                        book: book,
                                        onBookAdded: _refreshBooks, // Pass the refresh method
                                      ),
                                    ),
                                  );
                                  setState(() {}); // Refresh the list
                                  },
                                ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  // Delete book
                                  final bookRepository = await widget.bookRepository;
                                  bookRepository.deleteBook(book.bookId!);
                                  setState(() {}); // Refresh the list
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}