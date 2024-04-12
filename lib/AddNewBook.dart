import 'package:flutter/material.dart';
import 'GestionLivres.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddBookPage extends StatefulWidget {
  final Future<BookRepository> bookRepository;
  final Book? book;
  final VoidCallback onBookAdded;

  AddBookPage({required this.bookRepository, this.book, required this.onBookAdded});

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  late Book _book;
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _book.imagePath = pickedFile.path;
      }
    });
  }
  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _book = Book(
        bookId: widget.book!.bookId,
        title: widget.book!.title,
        author: widget.book!.author,
        category: widget.book!.category,
        publicationYear: widget.book!.publicationYear,
        availableCopies: widget.book!.availableCopies,
        imagePath: widget.book!.imagePath,
      );
    } else {
      _book = Book(
        bookId: 0,
        title: '',
        author: '',
        category: '',
        publicationYear: 0,
        availableCopies: 0,
        imagePath: '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book Page'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                initialValue: _book.title,
                onSaved: (value) => _book.title = value ?? '',
              ),
              // Add more fields for the other book properties
              TextFormField(
                decoration: InputDecoration(labelText: 'Author'),
                initialValue: _book.author,
                onSaved: (value) => _book.author = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Category'),
                initialValue: _book.category,
                onSaved: (value) => _book.category = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Publication Year'),
                initialValue: _book.publicationYear.toString(),
                onSaved: (value) => _book.publicationYear = int.parse(value ?? '0'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Available Copies'),
                initialValue: _book.availableCopies.toString(),
                onSaved: (value) => _book.availableCopies = int.parse(value ?? '0'),
              ),
              ElevatedButton(
                child: Text('Select Image'),
                onPressed: _pickImage,
              ),
              if (_imageFile != null) ...[
                Container(
                  width: 100,
                  height: 100,
                  child: Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ] else if (_book.imagePath.isNotEmpty) ...[
                Container(
                  width: 100,
                  height: 100,
                  child: Image.network(_book.imagePath, fit: BoxFit.cover),
                ),
              ] else ...[
                Text('No image selected'),
              ],      
              ElevatedButton(
                child: Text('Save'),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    if (widget.book != null) {
                      widget.bookRepository.then((value) => value.updateBook(_book));
                      Navigator.pop(context,'You have updated the book!');
                    } else {
                      widget.bookRepository.then((value) => value.addBook(_book));
                      widget.onBookAdded(); // Call the callback function
                      Navigator.pop(context,'You have added a new book!');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
