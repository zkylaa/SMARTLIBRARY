// lib/models/book_model.dart
class BookModel {
  final int id;
  final String title;
  final String author;
  final String isbn;
  final String category;
  final String synopsis;
  final String coverUrl;
  final int totalCopies;
  final int availableCopies;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    this.isbn = '',
    this.category = '',
    this.synopsis = '',
    this.coverUrl = '',
    this.totalCopies = 1,
    this.availableCopies = 1,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      isbn: json['isbn'] ?? '',
      category: json['category'] ?? '',
      synopsis: json['synopsis'] ?? '',
      coverUrl: json['cover_url'] ?? '',
      totalCopies: json['total_copies'] is int
          ? json['total_copies']
          : int.tryParse(json['total_copies'].toString()) ?? 1,
      availableCopies: json['available_copies'] is int
          ? json['available_copies']
          : int.tryParse(json['available_copies'].toString()) ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'isbn': isbn,
        'category': category,
        'synopsis': synopsis,
        'cover_url': coverUrl,
        'total_copies': totalCopies,
        'available_copies': availableCopies,
      };
}