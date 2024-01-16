import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:clientflutter/Screens/applicationPage.dart';
import 'package:clientflutter/Screens/lk.dart';



class clientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    PlaceholderWidget(color: Colors.red, text: '', index: 0),
    PlaceholderWidget(color: Colors.green, text: 'Страница создания заявок', index: 1),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.toc),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Отправить заявку',
          ),
        ],
      ),
    );
  }
}
Future<int?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId');
}
class PlaceholderWidget extends StatelessWidget {
  final Color color;
  final String text;
  final int index;
  List<String> myList = [];

  final TextEditingController applicationfullName = TextEditingController();
  final TextEditingController applicationNumberSeriesPassport = TextEditingController();
  final TextEditingController applicationInsuranceType = TextEditingController();
  final TextEditingController applicationInsuranceSum = TextEditingController();
  final TextEditingController applicationStatus = TextEditingController();

  PlaceholderWidget({required this.color, required this.text,required this.index});

  Future<void> add(BuildContext context) async
  {
    int? userId = await getUserId();
    String fullName = applicationfullName.text;
    String numberSeriesPassport = applicationNumberSeriesPassport.text;
    String insuranceType= applicationInsuranceType.text;
    String insuranceSum = applicationInsuranceSum.text;
    String status = applicationStatus.text;

    final url = Uri.parse('http://192.168.43.59:8092/applications/createApplication/$userId');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'fullName': fullName,
      'numberSeriesPassport': numberSeriesPassport,
      'insuranceType': insuranceType,
      'insuranceSum': insuranceSum,
      'status': status,
    });
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }

    applicationfullName.clear();
    applicationNumberSeriesPassport.clear();
    applicationInsuranceType.clear();
    applicationInsuranceSum.clear();
    applicationStatus.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),

      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            if(index == 0) ...[
              SingleChildScrollView(
                child: Container(
                  height: 278,
                  child: Row(
                    children: [
                      Expanded(
                        child: Image.network(
                          'https://sun6-20.userapi.com/s/v1/ig2/GolcmJFBPjSoP15Fzw-7icbKxxReKYBAHsDsy4QjoV-Un11unj0S6XAvk7V1BfNTDlGgVt_62371foFKE6MG1JZy.jpg?size=957x957&quality=95&crop=42,0,957,957&ava=1',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width:20),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      fixedSize: Size(405, 35),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => applicationPage(),
                        ),
                      );
                    },
                    child: Text('Мои заявки'),
                  ),
                ],
              ),
            ],
            if(index == 1) ...[
              SizedBox(height: 8.0),
              TextField(
                controller: applicationfullName,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.blue),
                  labelText: 'ФИО клиента: ',
                ),
              ),
              TextFormField(
                controller: applicationNumberSeriesPassport,
                maxLines: null,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.blue),
                  labelText: 'Серия и номер паспорта (через пробел): ',
                ),
              ),
              TextFormField(
                controller: applicationInsuranceType,
                maxLines: null,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.blue),
                  labelText: 'Тип страхования: ',
                ),
              ),
              TextFormField(
                controller: applicationInsuranceSum,
                maxLines: null,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.blue),
                  labelText: 'Страховая сумма: ',
                ),
              ),
              ElevatedButton(
              style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              minimumSize: Size(405, 35),
              ),
              onPressed: () {
                add(context);
              },
              child: Text('Отправить заявку'),
              ),
            ],
          ]
      ),
    );
  }
}