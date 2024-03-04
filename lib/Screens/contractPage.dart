import 'dart:convert';

import 'package:clientflutter/Screens/applicationPage.dart';
import 'package:flutter/material.dart';
import 'package:clientflutter/Models/User.dart';
import 'package:clientflutter/Models/ApplicationModel.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/ContractModel.dart';
import '../main.dart';
import 'agentPage.dart';
void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}
class contractPage extends StatefulWidget {
  final int applicationId;
  contractPage({required this.applicationId});

  @override
  _contractPageState createState() => _contractPageState();
}

class _contractPageState extends State<contractPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Оформление договора'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 8.0),
            TextField(
              controller: contractfullName,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.blue),
                labelText: 'ФИО клиента: ',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: contractTypeTreaty,
              maxLines: null,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.blue),
                labelText: 'Тип контракта',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: contractPolicySeries,
              maxLines: null,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.blue),
                labelText: 'Серия полиса',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: contractPolicyNumber,
              maxLines: null,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.blue),
                labelText: 'Номер полиса',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: contractInsuranceType,
              maxLines: null,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.blue),
                labelText: 'Тип страхования',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: contractInsurancePremium,
              maxLines: null,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.blue),
                labelText: 'Страховая премия',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                addContract(widget.applicationId, context);
              },
              child: Text('Оформить'),
            ),
          ],
        ),
      ),
    );
  }

  List<ApplicationModel> dataList = [];

  User? user;
  final TextEditingController contractfullName = TextEditingController();
  final TextEditingController contractTypeTreaty = TextEditingController();
  final TextEditingController contractPolicySeries = TextEditingController();
  final TextEditingController contractPolicyNumber = TextEditingController();
  final TextEditingController contractInsuranceType = TextEditingController();
  final TextEditingController contractInsurancePremium = TextEditingController();


  Future<void> addApplication() async {
    final response = await http.get(Uri.parse('http://192.168.43.59:8092/applications/appok'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<ApplicationModel>.from(jsonData.map((data) => ApplicationModel.fromJson(data)));
      });
    }
  }
  Future<void> addContract(int? applicationId, BuildContext context) async {
    int? userId = await getUserId();
    String fullName = contractfullName.text;
    String typeTreaty = contractTypeTreaty.text;
    String policySeries = contractPolicySeries.text;
    String policyNumber = contractPolicyNumber.text;
    String insuranceType = contractInsuranceType.text;
    String insurancePremium = contractInsurancePremium.text;

    final url = Uri.parse('http://192.168.43.59:8092/contracts/createContract/$applicationId/$userId');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'fullName': fullName,
      'typeTreaty': typeTreaty,
      'insuranceType': insuranceType,
      'insurancePremium': insurancePremium,
      'policySeries': policySeries,
      'policyNumber': policyNumber,
    });
    final response = await http.post(url, headers: headers, body: body);
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
      contractfullName.clear();
      contractTypeTreaty.clear();
      contractInsuranceType.clear();
      contractPolicyNumber.clear();
      contractPolicySeries.clear();
      contractInsurancePremium.clear();
    }
    Navigator.push(context,MaterialPageRoute(builder: (context) => applicationPage()));
  }
}