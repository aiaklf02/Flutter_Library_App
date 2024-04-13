import 'package:flutter/material.dart';
import 'GestionLivres.dart';
import 'GestionEmpreintes.dart';

class HistoriqueEmpreintesPage extends StatelessWidget {
  final BookRepository bookRepository;

  HistoriqueEmpreintesPage({required this.bookRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des Empreintes'),
      ),
      body: FutureBuilder<List<Empreinte>>(
        future: bookRepository.getAllEmpreintes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune empreinte trouvée.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final empreinte = snapshot.data![index];
                return ListTile(
                  title: FutureBuilder<Book?>(
                    future: bookRepository.getBookById(empreinte.bookId),
                    builder: (context, bookSnapshot) {
                      if (bookSnapshot.connectionState == ConnectionState.waiting) {
                        return Text('Chargement...');
                      } else if (bookSnapshot.hasError) {
                        return Text('Erreur: ${bookSnapshot.error}');
                      } else {
                        final book = bookSnapshot.data;
                        if (book != null) {
                          return Text('${book.title} - ${empreinte.dateEmpreinte}');
                        } else {
                          return Text('Livre introuvable');
                        }
                      }
                    },
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Logique pour gérer l'emprunt du livre
                      // Par exemple, afficher une boîte de dialogue pour collecter les détails de l'emprunt.
                    },
                    child: Text('Emprunter'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
