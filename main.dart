import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Img> fetchImg() async {
  final response =
      await http.get('http://www.splashbase.co/api/v1/images/random');

  if (response.statusCode == 200) {
   
    print(json.decode(response.body));
    return Img.fromJson(json.decode(response.body));
  } else {
   
    throw Exception('Failed to load img');
  }
}

class Img {
  final String url;

  Img({this.url});

  factory Img.fromJson(Map<String, dynamic> json) {
    return Img(
      url: json['url'],

    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Img> futureImg;
  void change(){
    setState(() {
      futureImg=fetchImg();
    });
  }
  @override
  void initState() {
    super.initState();
    futureImg = fetchImg();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImageWidget',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryTextTheme: TextTheme(title:TextStyle(color: Colors.black))
  
      ),
      
      home: Scaffold(
        appBar: AppBar(
          title: Text('random image api'),
        ),
        body: Column(
          children:<Widget>[
          FutureBuilder<Img>(
            future: futureImg,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var text = Image.network(snapshot.data.url);
                return text;
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
          RaisedButton(
            onPressed: change,
            child:Text('generate new image'),
            color: Colors.red[200],
            ),
          
          ]
           
        ),
      ),
    );
  }
}
