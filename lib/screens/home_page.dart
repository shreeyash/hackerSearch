import 'package:flutter/material.dart';

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
      drawer: Drawer(),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<String> recentSearches = ['Jaipur', 'Delhi'];
  final List<String> searchResults = ['Jaipur', 'Delhi','Kolkata'];
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
    // TODO: implement buildResults
    //Show result on base of selection
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Show when someone searches for anything
    final List<String> suggestionList =
        query.isEmpty ? recentSearches : searchResults;
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.list_alt),
        title: Text(suggestionList[index]),
      ),
      itemCount: suggestionList.length,
    );
  }
}
