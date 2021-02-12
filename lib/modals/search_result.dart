import 'package:flutter/material.dart';

class SearchResult {
  String storyTitle;
  String storyId;

  SearchResult({@required this.storyId, this.storyTitle});

  SearchResult.fromJson(Map<String, dynamic> json)
      : storyId = json['story_id'],
        storyTitle = json['story_title'];

  Map<String, dynamic> toJson() =>
      {'story_id': storyId, 'story_title': storyTitle};
}
