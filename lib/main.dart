import 'package:flutter/material.dart';
import 'package:gif/gif/gif.dart';
import 'package:gif/gif/gifService.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var gifService = GifService();
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Random gif viewer', gifService: gifService),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final GifService gifService;
  final String title;

  MyHomePage({Key key, this.title, this.gifService}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState(gifService);
}

class _MyHomePageState extends State<MyHomePage> {

  final GifService gifService;
  final List<String> _ratings = ["", "Y", "G", "PG", "PG-13", "R" ];

  String _tag = "";
  String _rating = "";

  _MyHomePageState(this.gifService);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 36.0),
                  child: Row(
                    children: [
                      _buildRatingDropdown(),
                      _buildCategorySearchInput(),
                      _buildSearchButton(),
                    ],
                  ),
                ),
                FutureBuilder<Gif>(
                    future: gifService.fetchImageUrlAsync(_tag, _rating),
                    builder: _buildImage),
              ]),
        ));
  }

  Widget _buildCategorySearchInput() {
    return Container(
      width: 160.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 32.0),
        child: TextField(
          onChanged: (text) {
            _tag = text;
          },
          onSubmitted: (String text) {
            _tag = text;
            _refreshImage();
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              labelText: "Category"
          ),
        ),
      ),
    );
  }

  _buildRatingDropdown() {
    return Container(
      padding: const EdgeInsets.only(left: 24.0),
      child: DropdownButton<String>(
        value: _rating == "" ? null : _rating,
        items: _ratings.map((String rating) {
          return DropdownMenuItem<String>(value: rating, child: Text(rating));
        }).toList(),
        onChanged: (String rating) {
          _rating = rating;
          _refreshImage();
        },
        hint: Text("Rating"),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
          onPressed: _refreshImage,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.refresh),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("Random!"),
              ),
            ],
          )),
    );
  }

  void _refreshImage() {
    setState(() {});
  }

  Widget _buildImage(_, AsyncSnapshot<Gif> snapshot) {
    if (snapshot.hasData) {
      return Image.network(snapshot.data.url);
    }
    return CircularProgressIndicator();
  }
}
