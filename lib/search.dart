import 'package:flutter/material.dart';
import 'book.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controllerID = TextEditingController();
  String _resultText = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _controllerID.dispose();
    super.dispose();
  }

  // Update the displayed text
  void update(String text) {
    setState(() {
      _resultText = text;
    });
  }


  void getProduct() {
    try {
      int pid = int.parse(_controllerID.text);
      setState(() {
        _isLoading = true;
        _resultText = '';
      });

      search(update, pid);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _resultText = 'Wrong arguments';
      });
    }
  }


  void fetchBooks() {
    setState(() {
      _isLoading = true;
      _resultText = '';
    });


    update((success) {
      if (success) {
        setState(() {
          _resultText = "Books fetched successfully!";
        });
      } else {
        setState(() {
          _resultText = "Error: Unable to load books.";
        });
      }
    } as String);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerID,
              decoration: const InputDecoration(
                labelText: 'Enter book ID between 1 & 15',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (value) => getProduct(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
              onPressed: getProduct,
              child: const Text('Search by ID'),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
              onPressed: fetchBooks,
              child: const Text('Fetch All Books'),
            ),

            const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return ListTile(
                      title: Text(book.title),
                      subtitle: Text(book.author),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailsScreen(book: book),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Author: ${book.author}',
              style: const TextStyle(fontSize: 18),
            ),
            if (book.subject != null)
              Text('Subject: ${book.subject}', style: const TextStyle(fontSize: 16)),
            if (book.publicationDate != null)
              Text('Publication Date: ${book.publicationDate}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(
              book.description ?? 'No description available.',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
