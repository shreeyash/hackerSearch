import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackerSearch/modals/search_result.dart';
import 'package:hackerSearch/screens/post_details_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hacker News'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
      body: Center(
          child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Developed by Shreeyash Haritashya for ApnaHood'),
        ),
      )),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<String> recentSearches = ['Hello', 'Fossil'];
  final List<String> searchResults = ['Hello', 'Fossil'];
  final String apiUrl = 'https://hn.algolia.com/api/v1/search?query=';

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions to perform for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: getSearchResult(query),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostDetailsPage(
                                    documentId: snapshot.data[index].storyId,
                                  )),
                        );
                      },
                      tileColor:
                          index.isEven ? Colors.blue[50] : Colors.grey[50],
                      leading: Icon(Icons.image),
                      subtitle: Text(
                        snapshot.data[index].storyId,
                        style: TextStyle(color: Colors.black),
                      ),
                      title: Text(
                        snapshot.data[index].storyTitle,
                        style: TextStyle(color: Colors.blueAccent),
                      ));
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Show when someone searches for anything
    final List<String> suggestionList = query.isEmpty
        ? recentSearches
        : searchResults.where((element) => element.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          if (query.isEmpty) {
            query = suggestionList[index];
          }
          showResults(context);
        },
        leading: Icon(Icons.list_alt),
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].substring(0, query.length),
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              children: [
                TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }

  Future<List<SearchResult>> getSearchResult(String query) async {
    List<SearchResult> apiSearchResults = [];
    String url = apiUrl + query.toLowerCase() + '&tags=story';
    var result = await http.get(url);
    Map<String, dynamic> user = jsonDecode(result.body);
    List hits = user['hits'];
    hits.forEach((element) {
      apiSearchResults.add(SearchResult(
          storyId: element['objectID'].toString(),
          storyTitle: element['title']));
    });

    return apiSearchResults;
  }
}
