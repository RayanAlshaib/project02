import 'package:flutter/material.dart';
import 'search.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Search',
          style:TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color:Colors.white,),),
        centerTitle:true,
        backgroundColor:Colors.brown),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Our Book Store!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30), // Spacing between text and button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white,),
              child: Text('Search Books'),
            ),
          ],
        ),
      ),
    );
  }
}
