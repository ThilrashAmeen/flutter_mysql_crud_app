import 'package:flutter/material.dart';
import 'package:flutter_mysql_crud_app/main.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatefulWidget {
  AddUser({Key key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _TxtFullName = new TextEditingController();
  final _TxtEmail = new TextEditingController();
  bool _valName = false;
  bool _valEmail = false;

  Future _saveDetails(String name, String email) async {
    var url = "http://192.168.1.102/php_docs/flutter_crud/save_data.php";
    final response = await http.post(url, body: {"name": name, "email": email});
    var res = response.body;
    if (res == "true") {
      Navigator.pop(context);
    } else {
      print("Error : " + res);
    }
  }

  @override
  void dispose() {
    _TxtFullName.dispose();
    _TxtEmail.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: new InputDecoration(
                labelText: 'Full Name',
                hintText: 'Full Name',
                errorText: _valName ? 'Name can\'t be empty' : null,
              ),
              controller: _TxtFullName,
            ),
            TextField(
              decoration: new InputDecoration(
                labelText: 'Email',
                hintText: 'Email',
                errorText: _valEmail ? 'Email can\'t be empty' : null,
              ),
              controller: _TxtEmail,
            ),
            ButtonBar(
              children: [
                RaisedButton(
                  color: Colors.green,
                  child: Text('Save Details'),
                  onPressed: () {
                    setState(() {
                      _TxtFullName.text.isEmpty
                          ? _valName = true
                          : _valName = false;
                      _TxtEmail.text.isEmpty
                          ? _valEmail = true
                          : _valEmail = false;
                      if (_valName == false && _valName == false) {
                        _saveDetails(_TxtFullName.text, _TxtEmail.text);
                      }
                    });
                  },
                ),
                RaisedButton(
                  color: Colors.red,
                  child: Text('Clear'),
                  onPressed: () {
                    _TxtFullName.clear();
                    _TxtEmail.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
