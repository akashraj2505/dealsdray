import 'dart:convert';
import 'package:dealsdray/Mail.dart';
import 'package:dealsdray/Otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final String deviceId;

  Login({super.key, required this.deviceId});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState(){
    super.initState();
    userid();
  }
  TextEditingController controller = TextEditingController();
  var sample = {};
  String?userId;
  sendotp() async {
    final response = await http.post(
        Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/otp"),
        headers: {"content-type": "application/json"},
        body: jsonEncode(
            {"mobileNumber": controller.text, "deviceId": widget.deviceId}));
    if (response.statusCode == 200 || response.statusCode == 201) {
      sample = json.decode(response.body);
      print(sample);
      setState(() {
        userId = sample['data']['userId'];
        print(userId);
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Otp(
                    mob: controller.text,userid: userId.toString(), deviceid: widget.deviceId
                  )));
    }
  }
  userid() async {
    final response = await http.post(
        Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/otp"),
        headers: {"content-type": "application/json"},
        body: jsonEncode(
            {"mobileNumber": controller.text, "deviceId": widget.deviceId}));
    if (response.statusCode == 200 || response.statusCode == 201) {
      sample = json.decode(response.body);
      print(sample);
      setState(() {
        userId = sample['data']['userId'];
        print(userId);
      });
    }
  }


  final deals = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: deals,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Logo
              Image.asset(
                'assets/logo.jpeg',
                height: 100,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 20),
              // Toggle buttons for Phone and Email
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Phone',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Mail(
                                    userid: userId.toString(),
                                  )));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Email',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Welcome message
              Text(
                'Glad to see you!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Please provide your phone number',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 30),
              // Phone input field
              TextFormField(
                controller: controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: UnderlineInputBorder(),
                ),
                validator: (input) {
                  if (!RegExp(
                          r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$")
                      .hasMatch(input!)) {
                    return "  Please Enter a valid phone number";
                  }
                },
              ),
              SizedBox(height: 30),
              // Send code button
              ElevatedButton(
                onPressed: () {
                  if (deals.currentState!.validate()) {
                    sendotp();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[800],
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'SEND CODE',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
