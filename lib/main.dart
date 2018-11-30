import 'package:flutter/material.dart';
import 'package:gif/gif/gif.dart';
import 'package:gif/gif/gifService.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
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

  String _tag = "";

  _MyHomePageState(this.gifService);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            _buildSearchButton(),
          ],
        ),
        body: ListView(children: [
          Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.only(top: 24.0, bottom: 36.0),
                child: _buildCategorySearchInput(),
              ),
              FutureBuilder<Gif>(
                  future: gifService.fetchImageUrlAsync(_tag),
                  builder: _buildImage),
            ]),
          ),
        ]));
  }

  Widget _buildCategorySearchInput() {
    return Center(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: TextField(
            onChanged: (text) => _tag = text,
            onSubmitted: (_) => _refreshImage(),
            decoration:
                InputDecoration(labelText: "Search"),
          ),
        ),
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
