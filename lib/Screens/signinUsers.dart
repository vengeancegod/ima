import 'dart:convert';
import 'package:clientflutter/Screens/signupUsers.dart';
import 'package:clientflutter/Screens/adminPage.dart';
import 'package:clientflutter/Models/LoginModel.dart';
import 'package:clientflutter/Screens/clientPage.dart';
import 'package:clientflutter/Screens/agentPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class signinUsers extends StatelessWidget {
  final minimumPadding = 5.0;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



    @override
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {
                            signin(context);
                          },
                          child: Text('Войти'),
                        ),
                      ],
                  ),
              ),
          ),
      );
    }

  Future<void> signin(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    final url = Uri.parse('http://localhost:8092/users/signin');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email':email,
      'password':password
    });

    final response = await http.post(url, headers: headers, body:body);
    if (response.statusCode == 200)
    {
      LoginModel loginModel = LoginModel.fromJson(json.decode(response.body));

      List roles = loginModel.roles;
      int userId = loginModel.id;

      Future<void> saveUserId(int userId) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userId);
      }
      saveUserId(userId);

      for (String role in roles)
      {
        if (role == 'ROLE_USER')
        {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.body),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => clientPage()),
          );
        }
        if (role == 'ROLE_AGENT') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.body),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => agentPage()),
          );
        }
        if (role == 'ROLE_ADMIN') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Вы успешно авторизировались!"),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => adminPage()),
          );
        }

      }
    }
    else{
      if(response.statusCode == 204) {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Ошибка!'),
                content: Text('У вас нет аккаунта, хотите создать его ?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => signupUsers()),
                      );
                    },
                    child: Text('Создать аккаунт'),
                  ),
                ],
              ),
        );
      }
      else{
        if(response.statusCode == 404)
        {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text('Ошибка!'),
                  content: Text('Ваш аккаунт заблокирован ! Пожалуйста, создайте новый аккаунт.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => signupUsers()),
                        );
                      },
                      child: Text('Создать аккаунт'),
                    ),
                  ],
                ),
          );
        }
        else{
          if(response.statusCode == 500)
          {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Ошибка!'),
                content: Text('У Вас есть аккаунт ? Если да, то проверьте правильность введённых данных!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => signupUsers()),
                      );
                    },
                    child: Text('У меня нет аккаунта, создать'),
                  ),
                ],
              ),
            );
          }

        }
      }
    }
  }
}
