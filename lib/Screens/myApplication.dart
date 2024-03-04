import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:clientflutter/Models/ApplicationModel.dart';
import 'package:clientflutter/Models/User.dart';
import 'package:clientflutter/Screens/lk.dart';
import 'package:clientflutter/Screens/clientPage.dart';


class myApplication extends StatefulWidget {
  @override
  myApplicationState createState() => myApplicationState();
}

class myApplicationState extends State<myApplication> {
  myApplication? application;
  User? user;

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
  final headers = {'Content-Type': 'application/json'};
  List<ApplicationModel> dataList = [];

  Future<void> myApp() async {
    int? userId = await getUserId();
    final response = await http.get(Uri.parse('http://192.168.43.59:8092/applications/myApplications/$userId'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<ApplicationModel>.from(jsonData.map((data) => ApplicationModel.fromJson(data)));
      });
    }
  }

  Future<void> deleteApplication(int? applicationId, BuildContext context) async {
    final response = await http.delete(Uri.parse('http://192.168.43.59:8092/applications/delete/$applicationId'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }
    myApp();
  }
  @override
  void initState() {
    super.initState();
    myApp();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Мои заявки', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => clientPage()),);
            },
          ),
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
                    Row(
                        children: [
                          Text(
                            'ФИО клиента: ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            utf8.decode(data.fullName.codeUnits),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: 8),
                    Row(
                        children: [
                          Text(
                            'Серия и номер паспорта (через пробел): ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            utf8.decode(data.numberSeriesPassport.toString().codeUnits),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: 8),
                    Row(
                        children: [
                          Text(
                            'Тип страхования: ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            utf8.decode(data.insuranceType.codeUnits),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: 5),
                    Row(
                        children: [
                          Text(
                            'Страховая сумма::',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            utf8.decode(data.insuranceSum.toString().codeUnits),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: 5),
                    Row(
                        children: [
                          Text(
                            'Статус: ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            utf8.decode(data.status.codeUnits),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              onPrimary: Colors.white,
                            ),
                            child: Text('Удалить'),
                            onPressed: () {
                              deleteApplication(data?.id, context);
    },
    ),
    ),
    ],
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

