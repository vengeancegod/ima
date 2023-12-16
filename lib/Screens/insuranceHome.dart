import 'package:clientflutter/Screens/signinUsers.dart';
import 'package:clientflutter/Screens/signupUsers.dart';
import 'package:flutter/material.dart';

class insuranceHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return insuranceHomeState();
  }
}

class insuranceHomeState extends State<insuranceHome> {
  final minimumPadding = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Страховое агентство'),
      ),
      body: Center(child: Text('Добро пожаловать в наше приложение!')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: minimumPadding, bottom: minimumPadding),
          children: <Widget>[
            DrawerHeader(
              child: Text('Страховое агентство'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Регистрация'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => signupUsers()));
              },
            ),
            ListTile(
              title: Text('Авторизация'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => signinUsers()));
              },
            )
          ],
        ),
      ),
    );
  }
}
