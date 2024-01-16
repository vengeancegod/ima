

import 'package:clientflutter/Screens/contractPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:clientflutter/Models/ApplicationModel.dart';
import 'package:clientflutter/Screens/clientPage.dart';
import 'package:clientflutter/Screens/agentPage.dart';


import '../Models/User.dart';
import 'agentPage.dart';


class applicationPage extends StatefulWidget {
  @override
  applicationPageState createState() => applicationPageState();
}
class contractButton extends StatefulWidget {
  final int applicationId;
  final Function(int, BuildContext) addContract;

  contractButton({required this.applicationId, required this.addContract});

  @override
  _contractButtonState createState() => _contractButtonState();
}

class _contractButtonState extends State<contractButton> {
  bool isContracted = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(
        isContracted ? Icons.done_all : Icons.done_all_outlined,
        color: isContracted ? Colors.green: Colors.grey,
      ),
      label: Text('Оформить договор'),
      onPressed: () {
        setState(() {
          isContracted = true;
        });

        widget.addContract(widget.applicationId, context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => contractPage()),
        );
      },
    );
  }
}
class applicationPageState extends State<applicationPage> {

  final url = Uri.parse('http://192.168.43.59:8092/applications/app');
  final headers = {'Content-Type': 'application/json'};
  List<ApplicationModel> dataList = [];
  User? user;

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
  Future<void> addApplication() async {
    final response = await http.get(Uri.parse('http://192.168.43.59:8092/applications/appok'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<ApplicationModel>.from(jsonData.map((data) => ApplicationModel.fromJson(data)));
      });
    }
  }
  Future<void> allApplication() async {
    final response = await http.get(Uri.parse('http://192.168.43.59:8092/applications/app'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<ApplicationModel>.from(jsonData.map((data) => ApplicationModel.fromJson(data)));
      });
    }
  }
  Future<void> addContract(int? applicationId, BuildContext context) async {
    int? userId = await getUserId();
    final response = await http.post(Uri.parse('http://172.20.10.3:8092/api_responses/addResponses/$applicationId/$userId'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }
    else
    {
      if (response.statusCode == 500)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body),
          ),
        );
      }
    }
  }
  @override
  void initState() {
    super.initState();
    addApplication();
    allApplication();
  }
  _blockButton() async{
    int? user = 0;
    user = await getUserId();
    return user;
  }
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text('Список заявок', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => agentPage()),);
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
                    SizedBox(height: 5),
                    Row(
                        children: [
                          Text(
                            'Серия и номер паспорта (через пробел): ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            utf8.decode(data.numberSeriesPassport.toString().codeUnits),
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
                            'Тип страхования:',
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
                            'Страховая сумма: ',
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
                    FutureBuilder<int?>(
                      future: getUserId(),
                      builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            int? userId = snapshot.data;
                            return Column(
                              children: [
                                if(data.user?.id != userId)...[
                                  SizedBox(height: 8),
                                  contractButton(
                                    applicationId: data.id,
                                    addContract: addContract,
                                  ),

                                ],
                                if(data.user?.id == userId) ...[
                                  SizedBox(height: 8),
                                  Container(
                                    child: Text(
                                      'Ваша заявка!',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ],
                            );
                          }
                          else
                          {
                            return Text('Ошибка получения id');
                          }
                        }
                        else
                        {
                          return CircularProgressIndicator();
                        }
                      },
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