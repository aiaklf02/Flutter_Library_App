import 'package:flutter/material.dart';
import 'AddNewBook.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'GestionEmpreintes.dart';
import 'package:path_provider/path_provider.dart';


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
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      bookId: map['bookId'],
      title: map['title'],
      author: map['author'],
      category: map['category'],
      publicationYear: map['publicationYear'],
      availableCopies: map['availableCopies'],
      imagePath: map['imagePath'],
    );
  }
}

class BookDataProvider {
  static const tableName = 'books';
  late final Database db;

  Future<BookDataProvider> init() async {
    await initDatabase();
    return this;
  }

  Future<void> initDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'books.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE $tableName(bookId INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, author TEXT, category TEXT, publicationYear INTEGER, availableCopies INTEGER, imagePath TEXT)",
        );
        Empreinte.createTable(db); 
      },
      version: 1,
    );


  }
  Future<List<Empreinte>> getAllEmpreintes() async {
    try {
      return await this.fetchAllEmpreintes();
    } catch (e) {
      print('Error fetching empreintes: $e');
      return []; // Return an empty list in case of error
    }
  }

  Future<List<Empreinte>> fetchAllEmpreintes() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query('empreintes');

      return List.generate(maps.length, (i) {
        return Empreinte(
          empreinteId: maps[i]['empreinteId'],
          bookId: maps[i]['bookId'],
          dateEmpreinte: maps[i]['dateEmpreinte'],
        );
      });
    } catch (e) {
      print('Error fetching empreintes: $e');
      return []; // Return an empty list in case of error
    }
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
  Future<void> addEmpreinte(Empreinte empreinte) async {
    await Empreinte.insertEmpreinte(this.db, empreinte);
  }

  Future<List<Empreinte>> getEmpreintesForBook(int bookId) async {
    return await Empreinte.getEmpreintesForBook(this.db, bookId);
  }
  Future<Book?> getBookById(int bookId) async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'Books',
        where: 'id = ?',
        whereArgs: [bookId],
      );

      if (maps.isEmpty) {
        return null;
      }

      return Book.fromMap(maps.first);
    } catch (e) {
      print('Erreur lors de la récupération du livre: $e');
      return null;
    }
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
  Future<Book?> getBookById(int bookId) async {
    try {
      final book = await dataProvider.getBookById(bookId);
      return book;
    } catch (e) {
      print('Erreur lors de la récupération du livre: $e');
      return null;
    }
  }

  Future<List<Empreinte>> getAllEmpreintes() async {
  try {
  final List<Empreinte> empreintes = await dataProvider.fetchAllEmpreintes();
  return empreintes;
  } catch (e) {
  // Gérer les erreurs de récupération des empreintes
  throw Exception('Erreur lors de la récupération des empreintes: $e');
  }
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