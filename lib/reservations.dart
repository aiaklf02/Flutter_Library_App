import 'package:flutter/material.dart';
import 'GestionLivres.dart';

class Reservation {
  final int? id;
  final int bookId;
  final DateTime date;

  Reservation({this.id, required this.bookId, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'date': date.toIso8601String(),
    };
  }
}

class ReservationsPage extends StatefulWidget {
  final BookRepository bookRepository;

  const ReservationsPage({Key? key, required this.bookRepository}) : super(key: key);

  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  late Future<List<Reservation>> reservations;

  @override
  void initState() {
    super.initState();
    reservations = widget.bookRepository.fetchReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réservations'),
      ),
      body: FutureBuilder<List<Reservation>>(
        future: reservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Reservation reservation = snapshot.data![index];
                return ListTile(
                  title: FutureBuilder<Book>(
                    future: widget.bookRepository.getBookById(reservation.bookId),
                    builder: (context, bookSnapshot) {
                      if (bookSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (bookSnapshot.hasError) {
                        return Text('Erreur: ${bookSnapshot.error}');
                      } else if (bookSnapshot.hasData) {
                        Book book = bookSnapshot.data!;
                        return Text('ID de la réservation: ${reservation.id}, Titre du livre: ${book.title}');
                      } else {
                        return Text('Livre inconnu');
                      }
                    },
                  ),
                  subtitle: Text('Date de réservation: ${reservation.date}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await widget.bookRepository.deleteReservation(reservation.id!);
                        setState(() {
                          reservations = widget.bookRepository.fetchReservations();
                        });
                      },
                    ),
                );
              },
            );
          } else {
            return Center(child: Text('Aucune réservation'));
          }
        },
      ),
    );
  }
}
