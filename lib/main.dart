import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For making HTTP requests

void main() {
  runApp(FetchDataApp());
}

class FetchDataApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data App',
      home: FetchDataScreen(),
    );
  }
}

class FetchDataScreen extends StatefulWidget {
  @override
  _FetchDataScreenState createState() => _FetchDataScreenState();
}

class _FetchDataScreenState extends State<FetchDataScreen> {
  Map<String, dynamic>? post; // Stores the fetched post
  bool isLoading = false; // Tracks the loading state

  // Function to fetch a random post from the API
  Future<void> fetchRandomPost() async {
    setState(() {
      isLoading = true; // Show loading spinner
    });

    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
      if (response.statusCode == 200) {
        setState(() {
          post = json.decode(response.body); // Decode the JSON response
          isLoading = false; // Hide loading spinner
        });
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Hide loading spinner
      });
      // Optionally handle errors here
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Data App'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show spinner when loading
            : post != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Post Title:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        post!['title'],
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Post Body:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        post!['body'],
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Text('Press the button to fetch a post!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchRandomPost, // Fetch data on button press
        child: Icon(Icons.download),
      ),
    );
  }
}
