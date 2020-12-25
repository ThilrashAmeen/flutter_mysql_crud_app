import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateUser extends StatefulWidget {
  final String id;
  final String name;
  final String email;

  const UpdateUser({Key key, this.id, this.name, this.email}) : super(key: key);

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _TxtFullName = new TextEditingController();
  final _TxtEmail = new TextEditingController();
  bool _valName = false;
  bool _valEmail = false;

  // Update User Function
  Future _updateDetails(String name, String email) async {
    var url = "http://192.168.1.102/php_docs/flutter_crud/update_data.php";
    final response = await http
        .post(url, body: {"name": name, "email": email, "id": widget.id});
    var res = response.body;
    print(res);
    if (res == "true") {
      Navigator.pop(context);
    } else {
      print("Error : " + res);
    }
  }

  // Delete User Function
  Future _deleteUser() async {
    var url = "http://192.168.1.102/php_docs/flutter_crud/delete_user.php";
    final response = await http.post(url, body: {"id": widget.id});
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
    _TxtFullName.text = widget.name;
    _TxtEmail.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
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
                  child: Text('Update Details'),
                  onPressed: () {
                    setState(() {
                      _TxtFullName.text.isEmpty
                          ? _valName = true
                          : _valName = false;
                      _TxtEmail.text.isEmpty
                          ? _valEmail = true
                          : _valEmail = false;
                      if (_valName == false && _valName == false) {
                        _updateDetails(_TxtFullName.text, _TxtEmail.text);
                      }
                    });
                  },
                ),
                RaisedButton(
                  color: Colors.red,
                  child: Text('Delete'),
                  onPressed: () {
                    _deleteUser();
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
