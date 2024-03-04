

import 'package:clientflutter/Screens/contractPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:clientflutter/Models/ContractModel.dart';
import 'package:clientflutter/Screens/clientPage.dart';
import 'package:clientflutter/Screens/agentPage.dart';


import '../Models/User.dart';
import 'agentPage.dart';


class listContract extends StatefulWidget {

  @override
  listContractState createState() => listContractState();
}

class listContractState extends State<listContract> {
  final headers = {'Content-Type': 'application/json'};
  List<ContractModel> dataList = [];
  User? user;

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
  Future<void> getContracts() async {
    final response = await http.get(Uri.parse('http://192.168.43.59:8092/contracts/get'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<ContractModel>.from(jsonData.map((data) => ContractModel.fromJson(data)));
      });
    }
  }
  Future<void> deleteContracts(int? contractId, BuildContext context) async {

    final response = await http.delete(Uri.parse('http://192.168.43.59:8092/contracts/delete/$contractId'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }
    getContracts();
  }
  @override
  void initState() {
    super.initState();
    getContracts();
  }

  Future<void> myContracts() async {
    int? userId = await getUserId();
    final response = await http.get(Uri.parse('http://192.168.43.59:8092/contracts/myContracts/$userId'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<ContractModel>.from(jsonData.map((data) => ContractModel.fromJson(data)));
      });
    }

  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Список договоров', style: TextStyle(color: Colors.white)),
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
                            'Страховая премия: ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            utf8.decode(data.insurancePremium.toString().codeUnits),
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
                            'Серия полиса: ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            utf8.decode(data.policySeries.toString().codeUnits),
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
                            'Номер полиса: ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            utf8.decode(data.policyNumber.toString().codeUnits),
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
                            'Тип договора: ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            utf8.decode(data.typeTreaty.toString().codeUnits),
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
                     deleteContracts(data.id, context);
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