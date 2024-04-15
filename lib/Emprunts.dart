import 'package:flutter/material.dart';
import 'GestionLivres.dart';
import 'GestionEmprunts.dart';
import 'Retours.dart';

class HistoriqueEmpruntsPage extends StatelessWidget {
  final BookRepository bookRepository;

  const HistoriqueEmpruntsPage({Key? key, required this.bookRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des Emprunts'),
      ),
      body: FutureBuilder<List<Emprunt>>(
        future: bookRepository.getEmprunts(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            final emprunts = snapshot.data;
            if (emprunts != null && emprunts.isNotEmpty) {
              return ListView.builder(
                itemCount: emprunts.length,
                itemBuilder: (context, index) {
                  final emprunt = emprunts[index];
                  return FutureBuilder<Book?>(
                    future: bookRepository.getBookDetails(emprunt.bookId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(
                          title: Text('Livre emprunté : Chargement...'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date d\'emprunt : ${emprunt.dateEmprunt}'),
                              Text('Date de retour : ${emprunt.dateRetour}'),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return ListTile(
                          title: Text('Erreur: ${snapshot.error}'),
                        );
                      } else {
                        final book = snapshot.data;
                        print ("L'emprunt a été remis : ${emprunt.Remis}");
                        return Column(
                          children: [
                            ListTile(
                              title: Text('Livre emprunté : ${book?.title ?? 'Titre non disponible'}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date d\'emprunt : ${emprunt.dateEmprunt}'),
                                  Text('Date de retour : ${emprunt.dateRetour}'),
                                ],
                              ),
                            ),
                            if(emprunt.Remis == false)
                              IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await bookRepository.UpdateEmprunt(
                                  Emprunt(
                                    empruntId: emprunt.empruntId,
                                    Remis: true,
                                    bookId: emprunt.bookId,
                                    dateEmprunt: emprunt.dateEmprunt,
                                    dateRetour: emprunt.dateRetour,
                                  ),
                                );
                                await bookRepository.addRetour(
                                  Retour(
                                    Empruntid: emprunt.bookId,
                                    dateRetour: DateTime.now(),
                                  ),
                                );
                              },
                            )
                            else 
                            ListTile(
                              title: Text('Livre rendu'),
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
              );
            } else {
              return Center(child: Text('Aucun emprunt trouvé.'));
            }
          }
        },
      ),
    );
  }
}
