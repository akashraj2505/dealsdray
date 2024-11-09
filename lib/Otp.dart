// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart'as http;
// import 'package:dealsdray/DashBoard.dart';
// import 'package:dealsdray/Login.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class Otp extends StatefulWidget {
//   final String mob;
//   final String userid;
//   final String deviceid;
//    Otp({super.key, required this.mob, required this.userid, required this.deviceid});
//
//   @override
//   State<Otp> createState() => _OtpState();
// }
//
// class _OtpState extends State<Otp> {
//   late Timer _timer;
//   int _start = 120; // Timer for 2 minutes
//   List<String> otpCode = List.generate(4, (index) => '');
//   List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
//   List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
//   List<String> otpDigits = List.filled(6, '');
//
//
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//     validateOtp(otpControllers.toString());
//   }
//   var sample ={};
//
//   Future<void> validateOtp(String otp) async {
//     try {
//       final response = await http.post(
//         Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/otp/verification"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "otp": otpControllers.toString(),
//           "deviceId":widget.deviceid,
//           "userId": widget.userid, // Use the stored userId from your previous response
//         }),
//       );
//       print(response.statusCode);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//          sample = json.decode(response.body);
//         print(sample);
//         if (sample['status'] == 1) {
//           print("OTP is valid");
//           Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
//           // Navigate to the next screen or perform any other actions
//         } else {
//           showError();
//           // Show error to the user
//         }
//       } else {
//         print("Failed to verify OTP: ${response.body}");
//       }
//     } catch (e) {
//       print("Error verifying OTP: $e");
//     }
//   }
//   void showError() {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Otp")));
//     setState(() {
//       otpControllers.forEach((controller) => controller.clear());
//       otpDigits = List.filled(6, ''); // Reset OTP digits
//       focusNodes[0].requestFocus(); // Refocus on the first field
//     });
//   }
//
//   // Handle OTP field change
//   void onOtpFieldChange(int index, String value) {
//     if (value.isNotEmpty) {
//       otpDigits[index] = value; // Save the value in otpDigits
//       if (index < 5) {
//         FocusScope.of(context).requestFocus(focusNodes[index + 1]); // Move to next field
//       } else {
//         // If all fields are filled, verify OTP
//         String otp = otpDigits.join();
//         validateOtp(otp);
//       }
//     }
//   }
//   void startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_start == 0) {
//         timer.cancel();
//       } else {
//         setState(() {
//           _start--;
//         });
//       }
//     });
//   }
//
//   String get timerText {
//     final minutes = (_start ~/ 60).toString().padLeft(2, '0');
//     final seconds = (_start % 60).toString().padLeft(2, '0');
//     return "$minutes : $seconds";
//   }
//
//   void navigateToNextPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => Dashboard()), // Replace with your target page
//     );
//   }
//
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             // Icon or Image
//             Image.asset('assets/otp_icon.png', height: 100),
//             // Replace with your image path
//             SizedBox(height: 30),
//             // OTP Verification Text
//             Text(
//               'OTP Verification',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'We have sent a unique OTP number\nto your mobile ${widget.mob}',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             SizedBox(height: 30),
//             // OTP input fields
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(4, (index) {
//                 return Container(
//                   width: 50,
//                   child: TextField(
//                     controller: otpControllers[index],
//                     focusNode: focusNodes[index],
//                     onChanged: (value) => onOtpFieldChange(index, value),
//                     keyboardType: TextInputType.number,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 24),
//                     maxLength: 1,
//                     decoration: InputDecoration(
//                       counterText: '',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   ),
//                 );
//               }),
//             ),
//             SizedBox(height: 30),
//             // Timer and Resend
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   timerText,
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     // Resend OTP functionality
//                     setState(() {
//                       _start = 120;
//                       startTimer();
//                     });
//                   },
//                   child: Text(
//                     'SEND AGAIN',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dealsdray/DashBoard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Otp extends StatefulWidget {
  final String mob;
  final String userid;
  final String deviceid;

  Otp(
      {super.key,
      required this.mob,
      required this.userid,
      required this.deviceid});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  late Timer _timer;
  int _start = 120; // Timer for 2 minutes
  List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  List<String> otpDigits = List.generate(6, (index) => '');

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  Future<void> validateOtp(String otp) async {
    try {
      final response = await http.post(
        Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/otp/verification"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "otp": otp, // Use the joined OTP string here
          "deviceId": widget.deviceid,
          "userId": widget.userid,
        }),
      );
      print("Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var sample = json.decode(response.body);
        print(sample);
        if (sample['status'] == 1) {
          print("OTP is valid");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        } else {
          showError();
        }
      } else {
        print("Failed to verify OTP: ${response.body}");
        showError();
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      showError();
    }
  }

  void showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Invalid OTP")),
    );
    setState(() {
      otpControllers.forEach((controller) => controller.clear());
      otpDigits = List.filled(6, ''); // Reset OTP digits
      focusNodes[0].requestFocus(); // Refocus on the first field
    });
  }

  void onOtpFieldChange(int index, String value) {
    if (value.isNotEmpty) {
      otpDigits[index]= value;
      print("${otpDigits}");
      String otp = otpDigits.join();
      print(otp);
      value =otp;
      print(value);
    if(value.length==4){
      validateOtp(otp);
    }else{
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String get timerText {
    final minutes = (_start ~/ 60).toString().padLeft(2, '0');
    final seconds = (_start % 60).toString().padLeft(2, '0');
    return "$minutes : $seconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Image.asset('assets/otp_icon.png', height: 100),
            SizedBox(height: 30),
            Text(
              'OTP Verification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We have sent a unique OTP number\nto your mobile ${widget.mob}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Container(
                  width: 50,
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    onChanged: (value) => onOtpFieldChange(index, value),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                );
              }),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timerText,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _start = 120;
                      startTimer();
                    });
                  },
                  child: Text(
                    'SEND AGAIN',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
