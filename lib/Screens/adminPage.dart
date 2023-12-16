import 'package:flutter/material.dart';
import 'package:clientflutter/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPageSceen extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: AdminPageScreen(),
    );
  }
}
class AdminPageScreen extends StatefulWidget
{
  @override
  AdminPageScreenScreenState createState() => AdminPageScreenScreenState();
}

class AdminPageScreenScreenState extends State<AdminPageScreen>
{

  List<User> dataList = [];

  Future<void> listUsers() async {
    final response = await http.get(Uri.parse('http://localhost:8092/api_users/users'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<User>.from(jsonData.map((data) => User.fromJson(data)));
      });
    }
  }
  Future<void> blockUser(int id, BuildContext context) async {
    final response = await http.put(Uri.parse('http://172.20.10.3:8092/api_users/block/$id'));
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
  Future<void> inBlockUser(int id, BuildContext context) async {
    final response = await http.put(Uri.parse('http://localhost:8092/api_users/inBlock/$id'));
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
    final response = await http.put(Uri.parse('http://172.20.10.3:8092/api_users/changeRole/$id/$role'));
    if (response.statusCode == 200)
    {
      String message = "Роль назначена!";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
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
          backgroundColor: Colors.deepPurple,
          title: Text('Список пользователей', style: TextStyle(color: Colors.white)),
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
                          'Имя:',
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
                          'Email:',
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
                            'Статус:',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            (data.active.toString()),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ]
                    ),
                    Row(
                        children: [
                          Text(
                            'Роль:',
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
                        backgroundColor: Colors.deepPurple,
                        onPrimary: Colors.white,
                      ),
                      child: Text('Заблокировать'),
                      onPressed: () {
                        blockUser(data.id,context);
                      },
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        onPrimary: Colors.white,
                      ),
                      child: Text('Разблокировать'),
                      onPressed: () {
                        inBlockUser(data.id,context);
                      },
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return AlertDialog(
                                  title: Text('Выберите роль'),
                                  content: DropdownButton<String>(
                                    value: selectedRole,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedRole = newValue;
                                      });
                                    },
                                    items: <String>['ROLE_USER', 'ROLE_MODER', 'ROLE_ADMIN']
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
                                      child: Text('OK'),
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