import 'dart:convert';

import 'package:dealsdray/DashBoard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class Mail extends StatefulWidget {
  final String userid;
   Mail({super.key, required this.userid});

  @override
  State<Mail> createState() => _MailState();
}

class _MailState extends State<Mail> {
  TextEditingController mail = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController referal = TextEditingController();
  bool _isPasswordVisible = false;
  final deals = GlobalKey<FormState>();
  var sample={};
  createacc()async{
    final response = await http.post(Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/email/referral"),
    headers: {
      "content-type":"application/json"
    },
      body: jsonEncode({
        "email":mail.text,
        "password":pass.text,
        "referralCode":referal.text,
        "userId":widget.userid
      })
    );
    if(response.statusCode==200||response.statusCode==201){
      sample = json.decode(response.body);
      print(sample);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){Navigator.pop(context);},
            child: Icon(Icons.arrow_back_ios)),
      ),
      floatingActionButton: Container(
        width: 70, // Adjust width as needed
        height: 70, // Adjust height as needed
        child: FloatingActionButton(
          onPressed: () {
            if(deals.currentState!.validate()){
              setState(() {
                createacc();
              });
            }
          },
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // Adjust the radius
          ),
          child: Icon(Icons.arrow_forward, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: deals,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Container(
                    height: 200,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/logo.jpeg"),
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text("Let's Begin!", style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text("Please enter your credentials to proceed", style: TextStyle(fontSize: 20,color: Colors.black26,),),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: mail,
                    decoration: InputDecoration(
                      hintText: "Your Email"
                    ),
                    validator: (input) {
                      if (!RegExp(r"^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+")
                          .hasMatch(input!)) {
                        return "  Please Enter a valid mail id";
                      }
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: pass,
                    obscureText: !_isPasswordVisible, // Controls the visibility of the password
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Create Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                          });
                        },
                      ),
                    ),
                    validator: (input) {
                      if (!RegExp(r"^\d{4}[A-Z][a-z]+$").hasMatch(input!)) {
                        return "  Please Enter a correct password";
                      }
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: referal,
                    decoration: InputDecoration(
                      hintText: "Referal Code (optional)"
                    ),
                    validator: (input) {
                      if (!RegExp(r"^\d{8}$").hasMatch(input!)) {
                        return "  Please Enter a correct refferal";
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
