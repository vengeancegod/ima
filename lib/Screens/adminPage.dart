import 'package:flutter/material.dart';
import 'package:clientflutter/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'lk.dart';

class AdminPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: adminPage(),
    );
  }
}
class adminPage extends StatefulWidget
{
  @override
  adminPageState createState() => adminPageState();
}

class adminPageState extends State<adminPage>
{

  List<User> dataList = [];

  Future<void> listUsers() async {
    final response = await http.get(Uri.parse('http://localhost:8092/users/get'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<User>.from(jsonData.map((data) => User.fromJson(data)));
      });
    }
  }
  Future<void> delete(int id, BuildContext context) async {
    final response = await http.delete(Uri.parse('http://localhost:8092/users/delete/$id'));
    if (response.statusCode == 200)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
      listUsers();
    }
  }
  Future<void> changeRole(int id, String? role) async {
    final response = await http.put(Uri.parse('http://localhost:8092/users/changeRole/$id/$role'));
    if (response.statusCode == 200)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
      listUsers();
    }
  }
  @override
  void initState()
  {
    super.initState();
    listUsers();
  }

  @override
  Widget build(BuildContext context)
  {
    String? selectedRole;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Список пользователей: ', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => lk()),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final data = dataList[index];
            return Card(
              elevation: 15,
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Имя: ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          utf8.decode(data.name.codeUnits),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Email: ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          utf8.decode(data.email.codeUnits),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                        children: [
                          Text(
                            'Роль: ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            (data.roles.toString()),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                      child: Text('Удалить'),
                      onPressed: () {
                        delete(data.id,context);
                      },
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return AlertDialog(
                                  title: Text('Роли'),
                                  content: DropdownButton<String>(
                                    value: selectedRole,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedRole = newValue;
                                      });
                                    },
                                    items: <String>['ROLE_CLIENT', 'ROLE_AGENT', 'ROLE_ADMINISTRATOR']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    })
                                        .toList(),
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        changeRole(data.id, selectedRole);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Oк'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Text('Назначить роль'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}