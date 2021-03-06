import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Rowan's App",
      home: RandomWords(),
      theme: ThemeData(
        primarySwatch: Colors.red
      )
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Rowan's App"),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved,)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),

      itemBuilder: (context, i) {
        if (i.isOdd) return Divider(color: Colors.grey);

        final index = i ~/ 2;

        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: TextStyle(color: Colors.blueGrey, fontSize: 18)
      ),
      trailing: new Icon(
        alreadySaved? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors. : Colors.blueGrey,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
              (WordPair pair) {
                return ListTile(
                  title: new Text(
                    pair.asPascalCase,
                    style: new TextStyle(color: Colors.white70, fontSize: 18)
                  )
                );
              }
          );

          final List<Widget> divided = ListTile
            .divideTiles(tiles: tiles, context: context, color: Colors.white30)
            .toList();

          return new Scaffold(
            backgroundColor: Colors.black38,
            appBar: new AppBar(
              title: const Text('Saved Suggestions')
            ),
            body: new ListView(children: divided)
          );
        }
      )
    );
  }
}
