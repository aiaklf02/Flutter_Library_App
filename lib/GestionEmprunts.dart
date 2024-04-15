class Emprunt {
  final int? empruntId;
  final int bookId;
  final bool Remis;
  final DateTime dateEmprunt;
  final DateTime dateRetour;

  Emprunt({
    this.empruntId,
    required this.bookId,
    required this.dateEmprunt,
    required this.dateRetour,
    this.Remis = false,
  });
    factory Emprunt.fromMap(Map<String, dynamic> map) {
      return Emprunt(
        empruntId: map['empruntId'],
        bookId: map['bookId'],
        dateEmprunt: DateTime.parse(map['dateEmprunt']),
        dateRetour: DateTime.parse(map['dateRetour']),
        Remis: map['Remis'] == 1,
      );
    }
   Map<String, dynamic> toMap() {
    return {
      'empruntId': empruntId,
      'bookId': bookId,
      'dateEmprunt': dateEmprunt.toIso8601String(),
      'dateRetour': dateRetour.toIso8601String(),
      'Remis': Remis ? 1 : 0,
    };
  }

}


