
import 'dart:convert';
import 'package:clientflutter/Models/User.dart';
import 'package:clientflutter/Screens/insuranceHome.dart';
import 'package:clientflutter/Screens/signinUsers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class signupUsers extends StatelessWidget {

  final minimumPadding = 5.0;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberPhoneController = TextEditingController();

  Future<void> signup(BuildContext context) async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String phoneNumber = numberPhoneController.text;

    final url = Uri.parse('http://localhost:8092/users/signup');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': name,
      'email':email,
      'password':password,
      'phoneNumber':phoneNumber
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

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleSmall;
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
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
                    controller: nameController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Пожалуйста, введите ваше имя';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Имя',
                        hintText: 'Введите ваш имя',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  )),
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
                        labelText: 'Email',
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
                    obscureText: true,
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
              Padding(
                  padding: EdgeInsets.only(
                      top: minimumPadding, bottom: minimumPadding),
                  child: TextFormField(
                    style: textStyle,
                    controller: numberPhoneController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Пожалуйста, введите номер телефона';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Номер телефона',
                        hintText: 'Введите ваш номер телефона',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
              )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  signup(context);
                },
                child: Text('Зарегистрироваться'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
