import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mysql_crud_app/add_user.dart';
import 'package:flutter_mysql_crud_app/update_user.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  // This is the root widget of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Romoving the DEBUG banner
      home: Home(),
      routes: <String, WidgetBuilder>{
        '/add_user': (BuildContext context) => new AddUser()
      },
    );
  }
}

Future<List> getData() async {
  var _url = "http://192.168.1.102/php_docs/flutter_crud/get_data.php";
  final _response = await http.get(_url);
  var _dataRecieved = json.decode(_response.body);
  // print(_dataRecieved);
  return _dataRecieved;
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD - MYSQL'),
        centerTitle: true,
      ),
      body: new FutureBuilder<List>(
        future: getData(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            print('Error in Loading ' + snapshot.error.toString());
          }
          return snapshot.hasData
              ? new ItemList(
                  list: snapshot.data,
                )
              : new Center(
                  child: CircularProgressIndicator(),
                );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/add_user');
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;

  const ItemList({Key key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateUser(
                              id: list[i]['ID'],
                              name: list[i]['NAME'],
                              email: list[i]['EMAIL'],
                            )));
                // print('Edit / Delete');
              },
              leading: CircleAvatar(
                child: Text(
                    list[i]['NAME'].toString().substring(0, 1).toUpperCase()),
              ),
              title: new Text(
                list[i]['NAME'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: new Text(
                list[i]['EMAIL'],
                style: TextStyle(fontSize: 15),
              ),
            ),
          );
        });
  }
}
