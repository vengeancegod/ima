import 'dart:convert';

import 'package:flutter/material.dart';



class signinUsers extends StatelessWidget {
  final minimumPadding = 5.0;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signup(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    final url = Uri.parse('http://localhost:8092/users/signup');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email':email,
      'password':password
    });

    final response = await http.post(url, headers: headers, body:body);
    if (response.statusCode == 200)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
      Navigator.push(context,MaterialPageRoute(builder: (context) => signinUsers()));
    }
    else
    {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка!'),
          content: Text('Пользователь с таким именем уже существует!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleSmall;
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: Form(
        child: Padding(
          padding: EdgeInsets.all(minimumPadding * 2),
          child: ListView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                      top: minimumPadding, bottom: minimumPadding),
                  child: TextFormField(
                    style: textStyle,
                    controller: emailController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Пожалуйста, введите ваш email';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'email',
                        hintText: 'Введите ваш email',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: minimumPadding, bottom: minimumPadding),
                  child: TextFormField(
                    style: textStyle,
                    controller: passwordController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Пожалуйста, введите ваш пароль';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Пароль',
                        hintText: 'Введите ваш пароль',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  )),
              ElevatedButton(onPressed: () {}, child: Text('Войти'))
            ],
          ),
        ),
      ),
    );
  }
}
