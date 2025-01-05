import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String _URL = 'booksearch0.atwebpages.com';
class Book {
  final int id;
  final String title;
  final String author;
  final String? subject;
  final String? description;
  final int? publicationDate;

  Book(
      this.id,this.title, this.author, this.subject, this.description, this.publicationDate,
  );

  @override
  String toString() {
    return 'ID: $id\nTitle: $title\nAuthor: $author\nSubject: $subject\nDescription: $description\nPublication Date: $publicationDate';
  }
}


List<Book> books = [];


void update(Function(bool success) update) async {
  try {
    final url = Uri.http(_URL, 'getBooks.php');
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      books.clear();
      final jsonResponse = convert.jsonDecode(response.body);

      if (jsonResponse is List) {
        for (var row in jsonResponse) {
          books.add(Book(
            int.parse(row['id']),
            row['title'],
            row['author'],
            row['subject'],
            row['description'],
            row['publication_date'],
          ));
        }
        update(true);
      } else {
        update(false);
      }
    } else {
      print('Error: ${response.body}');
      update(false);
    }
  } catch (e) {
    print('Exception: $e');
    update(false);
  }
}


void search(Function(String text) update, int pid) async {

    final url = Uri.http(_URL, 'searchBooks.php', {'id': pid.toString()});
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    books.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse.isNotEmpty) {
        var row = jsonResponse[0];
        Book b = Book(
          int.parse(row['id']),
          row['title'],
          row['author'],
          row['subject'],
          row['description'],
          row['publicationDate'],
        );
        books.add(b);
        update(b.toString());
      } else {
        update("No books found with this ID.");
      }
    } else {
      update("Error fetching book data.");
    }

}
class Show extends StatelessWidget {
  const Show({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) => Column(children: [
          const SizedBox(height: 10),
          Container(
              color: index % 2 == 0 ? Colors.brown: Colors.white,
              padding: const EdgeInsets.all(5),
              width: width * 0.9, child: Row(children: [
            SizedBox(width: width * 0.15),
            Flexible(child: Text(books[index].toString(), style: TextStyle(fontSize: width * 0.045)))
          ]))
        ])
    );
  }
}