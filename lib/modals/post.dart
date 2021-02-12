import 'package:flutter/material.dart';

class Post {
  String postId;
  String postTitle;
  String author;
  String url;
  DateTime createdAt;

  Post(
      {@required this.postId,
      this.author,
      this.createdAt,
      this.postTitle,
      this.url});

  Post.fromJson(Map<String, dynamic> json)
      : postId = json['id'],
        author = json['author'],
        postTitle = json['title'],
        url = json['url'],
        createdAt = json['created_at'];
}
