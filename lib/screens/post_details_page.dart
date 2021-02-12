import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackerSearch/modals/post.dart';
import 'package:http/http.dart' as http;

class PostDetailsPage extends StatelessWidget {
  final String documentId;
  PostDetailsPage({@required this.documentId});
  final String apiUrl = 'https://hn.algolia.com/api/v1/items/';

  Future<Post> getPost() async {
    String url = apiUrl + documentId;
    var result = await http.get(url);
    Map<String, dynamic> postMap = jsonDecode(result.body);
    print(postMap['id']);

    Post post = Post(
        postId: postMap['id'].toString(),
        postTitle: postMap['title'],
        author: postMap['author'],
        url: postMap['url']);
    return post;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_left,
            size: 40,
          ),
        ),
      ),
      body: FutureBuilder(
        future: getPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 200,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('PostId :'),
                          SizedBox(
                            width: 10,
                          ),
                          Text(snapshot.data.postId),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        snapshot.data.postTitle,
                        style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 16,
                            color: Colors.blue[900]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text('Author :'),
                          SizedBox(
                            width: 10,
                          ),
                          Text(snapshot.data.author),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        snapshot.data.url,
                        style: TextStyle(color: Colors.blue),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
