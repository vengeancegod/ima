import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clientflutter/Models/User.dart';
import 'package:clientflutter/Screens/userApplication.dart';
import 'package:clientflutter/Screens/userContract.dart';
import 'package:clientflutter/Screens/clientPage.dart';
import 'dart:convert';
import 'dart:io';
import 'insuranceHome.dart';


class lk extends StatefulWidget {
  @override
  _lk createState() => _lk();
}

class _lk extends State<lk> {

  User? user;
  String avatarUrl = '';

  @override
  void initState() {
    super.initState();
    fingByUser();
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }


  Future<void> fingByUser() async
  {
    int? userId = await getUserId();
    final response = await http.get(
        Uri.parse('http://localhost:8092/users/user/$userId'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        user = User.fromJson(jsonData);
      });
    }
    else {
      throw Exception('Ошибка загрузки!');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Мой профиль',style: TextStyle(color: Colors.white)),
        leading: user != null && user!.roles.contains("ROLE_USER")
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => insuranceHome()),);
          },
        )
            : null,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Id: ${user?.id}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(

              'ФИО: ${user?.name}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${user?.email}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Телефон: ${user?.numberPhone}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
                'Роль: ${user != null ? (user!.roles.contains("ROLE_CLIENT") ? "Клиент" : (user!.roles.contains("ROLE_AGENT") ? "Страховой агент" : "Администратор")) : ""}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                onPrimary: Colors.white,
                fixedSize: Size(200, 35),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => insuranceHome(),
                  ),
                );
              },
              child: Text('Выйти'),
            ),

          ],
        ),
      ),
    );
  }
}